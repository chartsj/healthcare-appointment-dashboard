from fastapi import FastAPI, HTTPException, Query
from fastapi.encoders import jsonable_encoder
from fastapi.middleware.cors import CORSMiddleware
from database import get_db_connection
import mysql.connector
from pydantic import BaseModel
from datetime import date, time
import math
from datetime import date, timedelta
from scoring import calculate_no_show_risk

app = FastAPI(title="Healthcare Appointment API")


class AppointmentCreate(BaseModel):
    patient_id: int
    appointment_date: date
    appointment_time: time
    department_id: int
    appointment_type: str
# Allow your frontend to call this backend
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:5173",
        "http://127.0.0.1:5173",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
def home():
    return {"message": "Healthcare API is running"}

@app.get("/no-show-predictions/upcoming")
def get_upcoming_predictions(days:int=Query(default=7,ge=1,le=30)):
    conn = None
    cursor = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        query="""
                select a.appointment_id, p.patient_id, a.appointment_date,
                TIME_FORMAT(a.appointment_time, '%H:%i') AS appointment_time, ap.no_show_probability, ap.risk_level, ap.predicted_at
                from patients p join appointments a on p.patient_id = a.patient_id 
                join appointment_predictions ap on a.appointment_id = ap.appointment_id
                where a.appointment_date between curdate() and curdate()+ interval %s day and a.appointment_status='Scheduled'
                order by a.appointment_date asc, a.appointment_time asc
                ;
                """
        cursor.execute(query, (days,))
        predictions = cursor.fetchall()
        return {
            "days": days,
            "total": len(predictions),
            "predictions": predictions
        }

    except mysql.connector.Error as error:
        print("Database error:", error)
        raise HTTPException(
            status_code=500,
            detail="Failed to fetch upcoming prediction results."
        )

    finally:
        if cursor:
            cursor.close()

        if conn:
            conn.close()


@app.get("/no-show-predictions/run")
def run_no_show_predictions(
    days:int=Query(default=7,ge=1,le=30)):
    conn = None
    cursor = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        start_date=date.today()
        end_date = start_date + timedelta(days=days)

        query ="""
                SELECT
                a.appointment_id,
                a.patient_id,
                a.appointment_date,
                a.appointment_time,
                a.department_id,
                a.appointment_type,
                a.appointment_status,
                (
                    SELECT COUNT(*)
                    FROM appointments past
                    WHERE past.patient_id = a.patient_id
                      AND past.appointment_status = 'No-Show'
                      AND past.appointment_date < a.appointment_date
                ) AS past_no_show_count
            FROM appointments a
            WHERE a.appointment_status = 'Scheduled'
              AND a.appointment_date BETWEEN %s AND %s
            ORDER BY a.appointment_date ASC, a.appointment_time ASC

                """
        cursor.execute(query, (start_date, end_date))
        appointments = cursor.fetchall()

        insert_query = """
            INSERT INTO appointment_predictions
            (
                appointment_id,
                no_show_probability,
                risk_level,
                predicted_at,
                model_version
            )
            VALUES (%s, %s, %s, NOW(),%s)
            ON DUPLICATE KEY UPDATE
                no_show_probability = VALUES(no_show_probability),
                risk_level = VALUES(risk_level),
                predicted_at = NOW()
        """

        summary = {
            "total_appointments": len(appointments),
            "high_risk": 0,
            "medium_risk": 0,
            "low_risk": 0
        }
        for appointment in appointments:
            prediction=calculate_no_show_risk(appointment)
            if prediction["risk_level"]=="High":
                summary["high_risk"]+=1
            elif prediction["risk_level"]=="Medium":
                summary["medium_risk"]+=1
            else:
                summary["low_risk"]+=1
            no_show_probability = round(prediction["risk_score"] / 100,4)
            cursor.execute(insert_query,
                           (appointment["appointment_id"],
                           no_show_probability,
                           prediction["risk_level"],
                           "rule_based_v1"
                           
                           ))
            conn.commit()
        return jsonable_encoder({
            "message":"No-show risk predictions generated successfully.",
            "summary": summary
        })


    except mysql.connector.Error as error:
        if conn:
            conn.rollback()
        raise HTTPException(
            status_code=500,
            detail=f"Database error: {error}"
        )

    except Exception as error:
        if conn:
            conn.rollback()
        raise HTTPException(
            status_code=500,
            detail=f"Unexpected error: {error}"
        )

    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()

@app.get("/patients")
def get_patients():
    conn = None
    cursor = None

    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        
        query = """
            SELECT *
            FROM patients
            
        """
        cursor.execute(query)
        

        appointments = cursor.fetchall()
        return jsonable_encoder(appointments)

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()


@app.post("/appointments", status_code=201)
def create_appointment(appointment: AppointmentCreate):
    conn = None
    cursor = None

    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        query = """
            INSERT INTO appointments
            (patient_id, appointment_date, appointment_time, department_id, appointment_type,appointment_status,created_at)
            VALUES (%s, %s, %s, %s, %s, %s, NOW())
        """

        cursor.execute(query, (
            appointment.patient_id,
            appointment.appointment_date,
            appointment.appointment_time,
            appointment.department_id,
            appointment.appointment_type,
            'Scheduled'
        ))

        conn.commit()

        return {
            "message": "Appointment created successfully",
            "appointment_id": cursor.lastrowid
        }

    except mysql.connector.Error as error:
        raise HTTPException(status_code=500, detail=str(error))

    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()









@app.get("/appointments/upcoming")
def get_upcoming_appointments(
    days:int=Query(default=7,ge=1,le=30),
    
):
    conn = None
    cursor = None

    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        query="""
                select a.appointment_id,
                a.patient_id,
                a.appointment_date,
                TIME_FORMAT(a.appointment_time, '%H:%i') AS appointment_time,
                d.department_name,
                a.appointment_type,
                a.appointment_status,
                a.created_at
                from appointments a 
                join departments d on a.department_id=d.department_id 
                where a.appointment_status='Scheduled' 
                and 
                a.appointment_date between curdate() and curdate()+interval %s day
                order by a.appointment_date asc, a.appointment_time asc
                """
        cursor.execute(query,(days,))
        appointments=cursor.fetchall()
        return jsonable_encoder(appointments)

    except mysql.connector.Error as error:
        raise HTTPException(status_code=500, detail=f"Database error: {error}")

    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()



@app.get("/appointments")
def get_appointments(
    page:int=Query(default=1,ge=1),
    page_size:int=Query(default=10,ge=1,le=100)
):
    conn = None
    cursor = None

    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        offset = page_size*(page-1)
        query = """
            select count(*) as total from appointments;
        """
        cursor.execute(query)
        
        total_records=cursor.fetchone()['total']
        
        total_pages = math.ceil(total_records/page_size)

        query = """
            SELECT a.appointment_id, a.patient_id, a.appointment_date, 
            TIME_FORMAT(a.appointment_time, '%H:%i') AS appointment_time,
            d.department_name, a.appointment_type, a.appointment_status, a.created_at
            FROM appointments a join departments d on a.department_id=d.department_id
            order by a.appointment_date desc, a.appointment_time desc
            limit %s offset %s
            ;
            
        """
        cursor.execute(query,(page_size,offset))
        

        

        appointments = cursor.fetchall()
        return jsonable_encoder({
            "data":appointments,
            "pagination": {
                "page": page,
                "page_size": page_size,
                "total_records": total_records,
                "total_pages": total_pages,
                "has_next": page < total_pages,
                "has_previous": page > 1
            }
        })

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()


@app.get("/appointments/{appointment_id}")
def get_appointment_by_id(appointment_id: int):
    conn = None
    cursor = None

    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        query = """
            SELECT *
            FROM appointments
            WHERE appointment_id = %s
        """
        cursor.execute(query, (appointment_id,))

        appointment = cursor.fetchone()

        if appointment is None:
            raise HTTPException(status_code=404, detail="Appointment not found")

        return jsonable_encoder(appointment)

    except HTTPException:
        raise

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()