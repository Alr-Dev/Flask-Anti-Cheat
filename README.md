# Flask Anti-Cheat Documentation

This project consists of a ban management system built using Flask for the backend API and a Roblox server script to interact with the API. The system allows banning users based on specific reasons and checking their ban status.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [API Endpoints](#api-endpoints)
  - [1. Index Endpoint](#1-index-endpoint)
  - [2. Favicon Endpoint](#2-favicon-endpoint)
  - [3. Ban User Endpoint](#3-ban-user-endpoint)
  - [4. Check Ban Status Endpoint](#4-check-ban-status-endpoint)
- [Roblox Server Integration](#roblox-server-integration)
  - [1. Key Functions](#1-key-functions)
  - [2. Customizing Ban Actions](#2-customizing-ban-actions)
- [Logging](#logging)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Features

- **Ban users** by their user ID with a specified reason.
- **Check if a user is banned.**
- **Log ban actions** to a file.
- **Integrate with a Roblox game** to enforce bans.

## Installation

1. Clone the repository.
2. Install the required Python packages:
   ```bash
   pip install Flask
   ```
3. Run the API server:
   ```bash
   python app.py
   ```
4. Ensure your Roblox game can communicate with the API (update the `BAN_SERVER_URL` if needed).

## API Endpoints

### 1. Index Endpoint

- **URL:** `/`
- **Method:** `GET`
- **Description:** Returns a simple message indicating the server is running.
- **Response:**
  - **200 OK**: `"Ban server is running"`

### 2. Favicon Endpoint

- **URL:** `/favicon.ico`
- **Method:** `GET`
- **Description:** Returns a 204 No Content status for favicon requests.
- **Response:**
  - **204 No Content**

### 3. Ban User Endpoint

- **URL:** `/ban`
- **Method:** `POST`
- **Description:** Bans a user with the provided user ID and optional reason.
- **Request Body:**
  ```json
  {
    "user_id": "123456789",
    "reason": "No reason provided"
  }
  ```
- **Response:**
  - **200 OK:** 
    ```json
    {
      "status": "success",
      "message": "User 123456789 banned"
    }
    ```
  - **400 Bad Request:**
    ```json
    {
      "status": "fail",
      "message": "No user_id provided"
    }
    ```

### 4. Check Ban Status Endpoint

- **URL:** `/check_ban`
- **Method:** `POST`
- **Description:** Checks if a user is banned.
- **Request Body:**
  ```json
  {
    "user_id": "123456789"
  }
  ```
- **Response:**
  - **200 OK:** 
    ```json
    {
      "status": "banned"
    }
    ```
  - **200 OK:** 
    ```json
    {
      "status": "not banned"
    }
    ```

## Roblox Server Integration

The Roblox server script interacts with the Flask API to check for banned users and enforce bans based on exploit detection. The relevant script is as follows:

```lua
local HttpService = game:GetService("HttpService")
local BAN_SERVER_URL = "http://127.0.0.1:5000"

local function checkBan(userId)
    local response = HttpService:PostAsync(BAN_SERVER_URL .. "/check_ban", HttpService:JSONEncode({user_id = userId}), Enum.HttpContentType.ApplicationJson)
    local result = HttpService:JSONDecode(response)
    
    return result.status == "banned"
end

local function banUser(userId, reason)
    local response = HttpService:PostAsync(BAN_SERVER_URL .. "/ban", HttpService:JSONEncode({user_id = userId, reason = reason}), Enum.HttpContentType.ApplicationJson)
    return response
end
```

### 1. Key Functions

- **`checkBan(userId)`**: Sends a request to the `/check_ban` endpoint to determine if a user is banned.
- **`banUser(userId, reason)`**: Sends a request to the `/ban` endpoint to ban a specified user with a reason.

### 2. Customizing Ban Actions

You can customize the actions taken when a player is detected as banned. This may include sending a notification, removing them from the game, or logging additional information.

## Logging

All ban actions are logged into a file (`logs.txt`) for future reference. Each log entry includes the user ID, the timestamp, and the reason for the ban.

## Usage

1. To ban a user, send a POST request to `/ban` with the user ID and reason.
2. To check if a user is banned, send a POST request to `/check_ban` with the user ID.
3. The Roblox server script automatically checks the ban status when a player joins and bans them if necessary.

## Contributing

Feel free to fork the repository, make improvements, and submit a pull request. Ensure your contributions are well-documented.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
