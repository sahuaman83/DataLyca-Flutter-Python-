# mobile_app

Admin App Flutter Application

## Getting Started

This project is a starting point for a Flutter application.

# json_data info
- validation of activity_info_screen json data is required.
- device_info_screen.json require 3 array of last_error value which contain the error component(recording/uploading/pocessing/inferencing), Date/Time, Device_ID, Error_Severity().
- home_screen.json "video_upload_details" add " status" key containig if activity started, ended, file not uploaded to s3, etc. 
- start_recording_screen.json "player_select_details" add player id key for individual players. 