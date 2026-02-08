# Supabase database structure
<img width="712" height="366" alt="image" src="https://github.com/user-attachments/assets/b8ebe8f9-4fd8-427c-bcd8-3b4bc6b1600c" />

## Categories
<img width="332" height="142" alt="image" src="https://github.com/user-attachments/assets/dc612b5d-0aa4-4d43-9ddb-619ab29e860e" />

- ```id <uuid>``` - unique identifier
- ```name <string>``` - category name

## Items
<img width="385" height="475" alt="image" src="https://github.com/user-attachments/assets/ec841918-6464-4037-8068-22864198e108" />

- ```id <uuid>``` - unique identifier
- ```seller_id <uuid>``` - foreign key for the profiles table
- ```title <string>``` - item name
- ```description <string>``` - item description
- ```rating <float>``` - stars out of 5
- ```category_id <uuid>``` - foreign key for categories table
- ```created_at <string>``` - exact date and time that item was listed
- ```price <float>``` - price of the item (CHF default)

## Item Images
<img width="388" height="272" alt="image" src="https://github.com/user-attachments/assets/0195aac3-82c1-41c0-b017-5df54432ba77" />

- ```id <uuid>``` - unique identifier
- ```item_id <uuid>``` - foreign key for the items table
- ```image_url <string>``` - url to image held in Supabase item image bucket
- ```sort_order <int>``` - priority of image

## Profiles
<img width="385" height="531" alt="image" src="https://github.com/user-attachments/assets/050ffa52-ae81-4224-9ad0-dbe56c32d1fe" />

- ```id <uuid>``` - unique identifier
- ```created_at <string>``` - exact date and time that profile was created
- ```created_at <string>``` - exact date and time that profile was last updated
- ```username <string>``` - profile name
- ```location <string>``` - location of user
- ```rating_score <float>```  - stars out of 5
- ```rating_count <int>``` - number of people who have reviewed the profile
- ```avatar_url <string>``` - url to image held in Supabase avatar bucket
- ```bio <string>``` - profile bio
