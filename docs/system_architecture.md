# System Architecture

The system follows a microservices architecture and consists of the following components:

- **Data Aggregation Module**: Collects data from environmental sensors.
- **Data Processing Module**: Processes and refines collected data.
- **AI Forecasting Module**: Provides predictions based on processed data.
- **Mobile App**: Presents user-specific data and notifications.
- **Web App**: Displays general environmental data for all users.
- **API Gateway**: Manages communication and routes requests between modules.
- **User Profiling Module**: Tailors data presentation based on user profiles.
- **User Management Module**: Manages user accounts, permissions, and roles.

Here’s a visual representation of the architecture:
```mermaid
---
title: System Architecture Overview
---
graph LR
    subgraph UserInterface[User Interface]
        MobileApp[Mobile App]
        WebApp[Web App]
    end

    subgraph UserServices[User Services]
        UserManagement[User Management Module]
        UserProfile[User Profiling Module]
    end

    subgraph DataServices[Data Services]
        DataAgg[Data Aggregation Module]
        DataProc[Data Processing Module]
    end

    APIGateway[API Gateway] --> DataAgg
    APIGateway --> DataProc
    APIGateway --> AIModule[AI Forecasting Module]
    APIGateway --> UserManagement
    APIGateway --> UserProfile
    APIGateway --> MobileApp
    APIGateway --> WebApp
```

```mermaid
---
title: Core Data Flow
---
graph TD
    DataAgg[Data Aggregation Module] -.->|Collects| SensorData[External API]
    DataProc[Data Processing Module] -->|Processes| DataAgg
    AIModule[AI Forecasting Module] -->|Forecasts| DataProc
    MobileApp[Mobile App] -->|User-Specific Data| APIGateway[API Gateway]
    WebApp[Web App] -->|General Data| APIGateway
```

```mermaid
---
title: Database Ownership Diagram
---
graph LR
    %% Define Modules and Their Databases
    DataAgg[Data Aggregation Module] --> DataAggDB[(Data Aggregation DB)]
    DataProc[Data Processing Module] --> DataProcDB[(Data Processing DB)]
    AIModule[AI Forecasting Module] --> AIDB[(AI Forecast DB)]
    UserProfile[User Profiling Module] --> UsersDB[(UsersDB)]
    UserManagement[User Management Module] --> UsersDB[(UsersDB)]

    %% User Interface Components Communicating via API Gateway
    subgraph UserInterface[User Interface]
        MobileApp[Mobile App]
        WebApp[Web App]
    end

    %% API Gateway Communicating with Modules
    UserInterface --> APIGateway[API Gateway]
    APIGateway --> DataAgg
    APIGateway --> DataProc
    APIGateway --> AIModule
    APIGateway --> UserProfile
    APIGateway --> UserManagement
```

# Improved Architecture Diagram 
```mermaid
---
title: Improved Architecture Diagram
---
graph LR
    subgraph backend
        DataAgg
        DataProc
        AIModule
    end

    subgraph frontend
        MobileApp
        WebApp
    end

    DataAgg[Data Aggregation Module] -.->SensorData[External API]
    DataProc[Data Processing Module] -->DataAgg
    DataAgg --> DataProc
    AIModule[AI Forecasting Module] <-->DataProc
    DataProc --> AIModule
    MobileApp[Mobile App] <-->|User-Specific Data| APIGateway([API Gateway])
    WebApp[Web App] <-->|General Data| APIGateway
    DataProc <-->|Common Data| APIGateway
    DataAgg <-->|Raw Data| APIGateway
```


