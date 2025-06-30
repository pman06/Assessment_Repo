# Simple service provided
from fastapi import FastAPI, Body, Depends
import schemas
import models
from database import Base, engine, SessionLocal
from sqlalchemy.orm import Session
from datetime import datetime

# import uvicorn

app = FastAPI()

Base.metadata.create_all(engine)
def get_session():
    session = SessionLocal()
    try:
        yield session
    finally:
        session.close()


@app.get('/')
async def home():
    return {'message': 'Welcome to my FastAPI application'}

@app.get("/health")
async def health_check():
    return {"status": "healthy", "timestamp": datetime.now()}

@app.get("/items")
async def get_items(session: Session = Depends(get_session)):
    items = session.query(models.Item).all()
    return {"items": items}


@app.get("/{id}")
async def getItem(id:int, session: Session = Depends(get_session)):
    item = session.query(models.Item).get(id)
    return {"item": item}

@app.post("/items")
async def create_item(item:schemas.Item, session = Depends(get_session)):
    item = models.Item(name = item.name, price = item.price)
    session.add(item)
    session.commit()
    session.refresh(item)
    return {"message": "Item created", "name": item.name, "price":item.price}


@app.put("/{id}")
async def update_item(id:int, item:schemas.Item, session = Depends(get_session)):
    item_object = session.query(models.Item).get(id)
    item_object.name = item.name
    item_object.price = item.price
    session.commit()
    return {"message": "Item Modified", "Item": item}

@app.delete("/{id}")
async def delete_item(id:int, session = Depends(get_session)):
    item_object = session.query(models.Item).get(id)
    session.delete(item_object)
    session.commit()
    session.close()
    return {"message": "Item was deleted"}