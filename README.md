# Good Night App

"Good Night" application to let users track when they go to bed and when they wake up.

## Prerequisites

- Ruby version 3.3.6
- Rails version 8.0.1
- Database SQLite

## Getting Started

1. Clone the repository: `git clone https://github.com/rendyrey/tripla-good-night.git`
2. Install gem dependencies: `bundle install`
3. Set up the database and seed the database with 10 users and 50 sleep records: `rails db:create db:migrate db:seed`
4. Start the Rails server on development mode: `rails server`
5. By default the app url will be `localhost:3000`

## API Endpoints

### Clock In

- Endpoint: `POST /api/v1/sleep-records/clock-in/:user_id`
- Params:
  - `user_id`: ID of the user who clock in
- Description: Creates a new sleep record with the current time as the bedtime for the specified user.
- Response: Return all clocked-in times, order by created time
- Response Example:
```json
{
  "message": "Successfully clocked in",
  "data": {
    "user": {
        "id": 1,
        "name": "Laurie Crona"
    },
    "clocked_in_times": [
        "2025-01-23T02:15:45.916Z",
        "2025-01-23T07:59:52.797Z",
        "2025-01-23T02:53:01.205Z",
        "2025-01-23T06:11:51.475Z",
        "2025-01-23T08:02:24.405Z"
    ]
  }
}
```

### Wake Up/Clock Out

- URL: `PATCH /api/v1/sleep-records/wake-up/:user_id`
- Parameters:
  - `user_id` (integer): ID of user who are going to wake up
- Description: Updte the wake-up time of the active sleep record
- Response: Return success message and the particular sleep record data
- Response Example:
```json
{
  "message":"Successfully clocked out/wake up",
  "data": {
    "wake_at":"2025-01-23T08:15:55.415Z",
    "user_id":1,
    "id":51,
    "sleep_at":"2025-01-23T08:02:24.405Z",
    "created_at":"2025-01-23T08:02:24.411Z",
    "updated_at":"2025-01-23T08:15:55.416Z"
  }
}
```

### User follow other user

- Endpoint: `POST /api/v1/users/:user_id/follow/:followed_user_id`
- Params:
  - `user_id`: ID of the user who are going to follow other
  - `followed_user_id`: ID of the user who being followed
- Description: User with ID :user_id follows user with ID :followed_user_id
- Response: Return success message
- Response Example:
```json
{"message":"Successfully followed"}
```

### User unfollow other user
- Endpoint: `POST /api/v1/users/:user_id/unfollow/:followed_user_id`
- Params:
  - `user_id` (integer): ID user who are going to unfollow other user
  - `followed_user_id`: ID of the user who being unfollowed
- Description: User with ID :user_id unfollows user with ID :followed_user_id (delete record)
- Response: Return success message
- Response Example:
```json
{"message":"Successfully unfollowed"}
```

### Get All Sleep Records

- URL: `GET /api/v1/sleep_records`
- Description: Retrieves all sleep records of all users, ordered by their creation time.
- Response: Return list of sleep records
- Response Example:
```json
[
    {
        "id": 1,
        "user_id": 9,
        "sleep_at": "2025-01-23T00:32:30.689Z",
        "wake_at": "2025-01-23T06:39:20.348Z",
        "created_at": "2025-01-23T08:00:57.421Z",
        "updated_at": "2025-01-23T08:00:57.421Z"
    },
    {
        "id": 2,
        "user_id": 1,
        "sleep_at": "2025-01-23T02:15:45.916Z",
        "wake_at": "2025-01-22T23:03:28.451Z",
        "created_at": "2025-01-23T08:00:57.426Z",
        "updated_at": "2025-01-23T08:00:57.426Z"
    },
    ...
]
```

### Get Following Users' Sleep Records

- URL: `GET /api/v1/sleep-records/following-sleep-records/:user_id`
- Parameters:
  - `user_id`: ID of the user whose followed users' sleep records are to be retrieved
- Description: Retrieves sleep records of all users followed by the :user_id.
- Response: Return sleep records of all followed users by :user_id from the previous week, sorted by the duration of sleep length.
- Response Example:
```json
[
  {
      "id": 50,
      "user_id": 2,
      "sleep_at": "2025-01-23T03:48:01.305Z",
      "wake_at": "2025-01-23T03:54:38.185Z",
      "created_at": "2025-01-23T08:00:57.498Z",
      "updated_at": "2025-01-23T08:00:57.498Z",
      "duration": 396
  },
  {
      "id": 13,
      "user_id": 6,
      "sleep_at": "2025-01-23T07:30:10.226Z",
      "wake_at": "2025-01-23T07:59:48.724Z",
      "created_at": "2025-01-23T08:00:57.449Z",
      "updated_at": "2025-01-23T08:00:57.449Z",
      "duration": 1778
  },
  {
      "id": 20,
      "user_id": 4,
      "sleep_at": "2025-01-23T04:46:18.333Z",
      "wake_at": "2025-01-23T05:52:47.865Z",
      "created_at": "2025-01-23T08:00:57.460Z",
      "updated_at": "2025-01-23T08:00:57.460Z",
      "duration": 3989
  },
  ...
]
```
## Postman Collection
If you want to try the API collection, you can use this simple postman collection
- [Link to Postman Collection](https://drive.google.com/file/d/11ybfCC_lCAjXkHvt3p_pdduWvkeuVjwH/view?usp=sharing)
