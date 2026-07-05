from datetime import date, timedelta


def get_time_hour(appointment_time):
    if appointment_time is None:
        return None

    if isinstance(appointment_time, timedelta):
        return appointment_time.seconds // 3600

    if isinstance(appointment_time, (int, float)):
        return int(appointment_time) // 3600

    if isinstance(appointment_time, str):
        return int(appointment_time.split(":")[0])

    if hasattr(appointment_time, "hour"):
        return appointment_time.hour

    return None


def calculate_no_show_risk(appointment):
    score = 20
    factors = []

    past_no_show_count = appointment.get("past_no_show_count", 0) or 0

    if past_no_show_count >= 2:
        score += 35
        factors.append("Patient has multiple previous no-shows")
    elif past_no_show_count == 1:
        score += 20
        factors.append("Patient has one previous no-show")

    if appointment["appointment_type"] == "New Consultation":
        score += 10
        factors.append("New consultation appointment")

    appointment_date = appointment["appointment_date"]

    if isinstance(appointment_date, str):
        appointment_date = date.fromisoformat(appointment_date)

    days_until = (appointment_date - date.today()).days

    if days_until <= 1:
        score += 10
        factors.append("Appointment is very soon")

    hour = get_time_hour(appointment["appointment_time"])

    if hour is not None and hour < 10:
        score += 5
        factors.append("Morning appointment")

    score = min(score, 100)

    if score >= 70:
        risk_level = "High"
    elif score >= 40:
        risk_level = "Medium"
    else:
        risk_level = "Low"

    return {
        "risk_score": score,
        "risk_level": risk_level,
        "factors": factors
    }