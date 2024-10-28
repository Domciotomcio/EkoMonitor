# Environmental Monitoring System EkoMonitor

## Table of Contents
1. [Project Overview](#project-overview)
2. [Features](#features)
3. [System Architecture](docs/system_architecture.md)
4. [Technologies Used](#technologies-used)
5. [Setup and Installation](#setup-and-installation)
6. [Managing Branches](docs/managing_branches.md)
7. [Usage](#usage)
8. [Project Structure](#project-structure)

## Project Overview
The **Environmental Monitoring System** is a microservices-based system designed to collect, process, forecast, and present data related to environmental factors, such as air quality, humidity, and other indicators. The goal is to provide users with meaningful insights through a mobile app, a web app, and AI-powered forecasting capabilities.

## Features
- **Data Collection**: Aggregates environmental data from IoT devices or other data sources.
- **Data Processing**: Processes and refines raw data for analysis.
- **AI Forecasting**: Predicts environmental changes using an AI model.
- **User Profiling**: Personalizes data presentation for each user.
- **User Management**: Manages user accounts, authentication, and authorization.
- **Data Presentation**: Offers both a mobile app for personalized insights and a web app for general data access.

## System Architecture
System architecture under this [link](docs/system_architecture.md).

## Technologies Used
- **Backend**: Python (FastAPI for services)
- **Frontend**: Angular (Web App), Flutter (Mobile App)
- **Database**: *To discuss*
- **AI/ML**: *To discuss*
- **API Gateway**: RestfulAPI and gateway *to discuss*
- **Messaging/Communication**: *To discuss*

## Setup and Installation
Setup and installation under this [link](docs/setup_and_instalation.md).

## Usage
In progress

## Project Structure
The project is organized into the following directories under `src/`:

- **data_aggregation**: Collects data from environmental sensors.
- **data_processing**: Processes and refines collected data.
- **ai_forecasting**: Provides predictions based on processed data.
- **mobile_app**: Presents user-specific data and notifications.
- **web_app**: Displays general environmental data for all users.
- **api_gateway**: Manages communication and routes requests between modules.
- **user_profiling**: Tailors data presentation based on user profiles.
- **user_management**: Manages user accounts, permissions, and roles.
