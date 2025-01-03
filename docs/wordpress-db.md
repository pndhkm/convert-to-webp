### Database Backup

Before updating image URLs in the database, make sure to back up your database using phpMyAdmin or the `mysqldump` command.

#### Update Image URLs in Database:
After converting the images, you need to update the image URLs in the database to point to the `.webp` files. Run the following SQL commands in phpMyAdmin:
```sql
UPDATE `$posts`
SET post_content = REPLACE(REPLACE(REPLACE(post_content, '.jpg', '.webp'), '.jpeg', '.webp'), '.png', '.webp') 
WHERE post_content LIKE '%<img%' AND (post_content LIKE '%.jpg%' OR post_content LIKE '%.jpeg%' OR post_content LIKE '%.png%');

UPDATE `$posts`
SET guid = REPLACE(REPLACE(REPLACE(guid, '.jpg', '.webp'), '.jpeg', '.webp'), '.png', '.webp')
WHERE guid LIKE '%.jpg%' OR guid LIKE '%.jpeg%' OR guid LIKE '%.png%';

UPDATE `$postmeta` 
SET meta_value = REPLACE(REPLACE(REPLACE(meta_value, '.jpg', '.webp'), '.jpeg', '.webp'), '.png', '.webp') 
WHERE meta_value LIKE '%.jpg%' OR meta_value LIKE '%.jpeg%' OR meta_value LIKE '%.png%';
```

**Note**: Make sure to replace the table names with the ones used in your WordPress database.