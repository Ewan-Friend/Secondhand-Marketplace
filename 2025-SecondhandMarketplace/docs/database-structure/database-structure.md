# Supabase database structure

![Database Structure](../assets/database-structure/overallstructure.png)


## Categories

![Categories](../assets/database-structure/categories.png)

- ```id <uuid>``` - unique identifier
- ```name <string>``` - category name

## Items

![Items](../assets/database-structure/items.png)

- ```id <uuid>``` - unique identifier
- ```seller_id <uuid>``` - foreign key for the profiles table
- ```title <string>``` - item name
- ```description <string>``` - item description
- ```rating <float>``` - stars out of 5
- ```category_id <uuid>``` - foreign key for categories table
- ```created_at <string>``` - exact date and time that item was listed
- ```price <float>``` - price of the item (£ default)
- ```condition <string>``` - selling condition of the item

## Item Images

![Item images](../assets/database-structure/item_images.png)

- ```id <uuid>``` - unique identifier
- ```item_id <uuid>``` - foreign key for the items table
- ```image_url <string>``` - url to image held in Supabase item image bucket
- ```sort_order <int>``` - priority of image

## Profiles

![Profiles](../assets/database-structure/profiles.png)

- ```id <uuid>``` - unique identifier
- ```created_at <string>``` - exact date and time that profile was created
- ```created_at <string>``` - exact date and time that profile was last updated
- ```username <string>``` - profile name
- ```location <string>``` - location of user
- ```rating_score <float>```  - stars out of 5
- ```rating_count <int>``` - number of people who have reviewed the profile
- ```avatar_url <string>``` - url to image held in Supabase avatar bucket
- ```bio <string>``` - profile bio
- ```postal_code <string>``` - postal code of the profile