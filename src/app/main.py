from fastapi import FastAPI

from app.iban_router import router

# Initialize FastAPI application for IBAN enrichment service
app = FastAPI()


@app.get("/")
def read_root():
    """
    Health check endpoint to verify API availability.
    """

    return {
        "message": "Welcome to IBAN Search API"
    }


app.include_router(router)