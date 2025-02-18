# Predictive Project Management with AI-Driven Insights

## **Project Description**
This project introduces **AI-powered predictive analytics** to revolutionize project management. By leveraging **machine learning, NLP, and interactive dashboards**, we provide real-time insights into risk assessment, task progression, and resource allocation, ensuring **data-driven decision-making** for project managers.

## **Team Members**
- **Divya Bomaraboina**  
  _Skills:_ Data Handling (Python, R, SQL), Visualizations (Tableau, Excel), Adaptability  
- **Ranxinji He**  
  _Skills:_ SQL, Java, Python, Market Strategy, Pricing  
- **Ramish Fatima**  
  _Skills:_ Python, R, Tableau, ML, Project Management, Risk Analytics  
- **Meiqi Hu**  
  _Skills:_ Microsoft Office Suite, SQL, Tableau  
- **VSN Sai Krishna Mohan Kocherlakota**  
  _Skills:_ Python, LLMs, OpenAI API, Generative AI Development  

## **Business Problem**
Traxidy, a project management software, lacked **data-driven project evaluation** and relied heavily on **subjective GYR (Green, Yellow, Red) project status assessments**. This led to:
- **Inefficient resource allocation**
- **Delayed risk detection**
- **Limited clarity on actionable next steps**

Our AI-driven approach addresses these gaps by providing:
✅ **Objective risk evaluation**
✅ **Predictive modeling for project outcomes**
✅ **Data-backed optimization strategies**

## **AI-Driven Approach & Models Used**

### **1. Exploratory Data Analysis (EDA)**
- **Data Processing & Preprocessing**
  - Extracted raw data from `dump.sql` and structured it via an **ERD (Entity Relationship Diagram)**.
  - Converted relational database tables into **cleaned CSV files**.
  - Identified **patterns in task completion, risk trends, and resource allocation**.

### **2. Predictive Modeling for Project Status & Risk Assessment**
✅ **Risk Classification:** Random Forest model to classify and prioritize project risks.  
✅ **LSTM Forecasting:** Used for predicting delays, risk levels, and resource requirements.  
✅ **Risk Score Prediction:** Utilized `R²` to assess explained variance in project risks.

**Results:**
| Model               | Initial Accuracy | Improved Accuracy |
|---------------------|----------------|-----------------|
| GYR Status Model   | 64%            | 75%             |
| LSTM Forecasting   | -              | 76% Validation Accuracy |

🎯 **Key Outcomes:**
- **Proactive risk identification**
- **Optimized project scheduling**
- **Enhanced resource allocation**

## **Dashboard & Visualization**
✅ **Tableau Dashboards** for real-time project insights
✅ **Dynamic Filtering & Interactive Visualizations**
✅ **Live chatbot integration** for enhanced data exploration

## **Chatbot Capabilities**
🚀 **Real-time project insights**  
🛠 **Natural Language Processing (NLP)** for intuitive queries  
📊 **Automated responses** with data-driven insights  

**Example Queries:**
- _“What are the risks for Project 105?”_
- _“Show me the GYR status of all active projects”_
- _“Predict the delay probability for Project 101”_

## **Implementation Details**
### **1. Website Development**
- **Frontend:** HTML, JavaScript (embedded Tableau visualizations)
- **Backend:** Flask (Python)
- **Chatbot Integration:** Flask API with NLP-based query processing

### **2. Deployment & Execution**
- **Run Chatbot Locally:** `python chatbot.py`
- **Access Web App:** `http://127.0.0.1:5000`
- **Embedded Tableau Dashboards** for seamless user interaction

## **Findings & Recommendations**
📌 **Data Inconsistencies Impacted Risk Predictions**  
📌 **Better Data Standardization Can Improve Model Accuracy**  
📌 **User Feedback Loops Needed for Continuous Model Improvement**  
📌 **Expand Features to Include Historical Benchmarking**

## **Future Enhancements**
✅ **Scalability Testing on Larger Datasets**
✅ **External Data Integration for More Contextual Insights**
✅ **Hybrid AI + Heuristic Models for Greater Accuracy**
✅ **Advanced Data Augmentation for Handling Missing Values**

## **References**
- _Nieto-Rodriguez, A., & Vargas, R. V. (2023). How AI will transform project management. Harvard Business Review._
- _Sharma, R., Kaushal, S., & Gupta, D. (2021). Risk management in project management using machine learning techniques._
- _Yadav, M., & Vyas, V. (2022). Data-driven decision making in project management: A review. IEEE Access._
- _Tableau Public Library (2021). Using dashboards for real-time risk management in projects._
