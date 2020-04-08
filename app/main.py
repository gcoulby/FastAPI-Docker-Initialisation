from fastapi import FastAPI
import uvicorn
import json

# init
app = FastAPI(debug=True)

# Data
with open("app/users.json") as f:
    users = json.load(f)


# Route
@app.get('/api/v1.0/users')
async def get_users():
    return {"users":users}


if __name__ == '__main__':
    uvicorn.run(app,host="0.0.0.0",port="8000")