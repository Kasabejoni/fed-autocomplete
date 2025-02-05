# 🚀 Vue (Vite) Frontend - Dockerized

This guide will help you set up and run the **Vue (Vite) frontend** using **Docker**.

---

## 📌 Prerequisites
Make sure you have the following installed on your system:
- **Docker** & **Docker Compose** → [Download](https://www.docker.com/get-started)
- **Git** → [Download](https://git-scm.com/downloads)

---

## 🛠️ Setup Instructions

### **1️⃣ Clone the Repository**
```sh
git clone https://github.com/Kasabejoni/fed-autocomplete.git
cd fed-autocomplete/frontend
```

---

## 🐳 Running with Docker

### **🔹 Start the Frontend**
Run the following command from the `frontend` directory:
```sh
docker-compose up --build -d
```
➡️ **Vue App will be available at:** `http://localhost`

### **🔹 Check Running Containers**
```sh
docker ps
```

### **🔹 Stop Docker Services**
```sh
docker-compose down
```

---

## ✅ Troubleshooting

### **1️⃣ Debugging Docker Logs**
```sh
docker logs vue_frontend
```

🚀 **Your Vue (Vite) frontend is now running with Docker!** 🎉
