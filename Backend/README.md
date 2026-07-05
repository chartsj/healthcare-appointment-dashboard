# Healthcare Backend

This is the FastAPI backend for the healthcare appointment project.

## How to Run the Backend

First, go into the backend folder:

```bash
cd backend
```

Activate the virtual environment:

```bash
source venv/Scripts/activate
```

Then run the FastAPI server:

```bash
uvicorn main:app --reload
```

The backend will start at:

```text
http://127.0.0.1:8000
```

You can view the FastAPI documentation at:

```text
http://127.0.0.1:8000/docs
```

## Notes

Make sure MySQL Server is running before starting the backend.

The `--reload` option is used during development so the server automatically restarts when code changes.