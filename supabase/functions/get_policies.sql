CREATE OR REPLACE FUNCTION que_ads.get_policies(
  filter_category_id integer, 
  filter_sub_category_id integer, 
  filter_city_id integer, 
  filter_province_id integer, 
  search_text text, 
  page_size integer, 
  page_number integer)
RETURNS jsonb
LANGUAGE plpgsql
AS $$
declare
  result jsonb;
  total_count integer;
  policies jsonb;
  data_offset integer;
begin

  data_offset = page_size * (page_number - 1);
  RAISE NOTICE 'data_offset: %', data_offset;

  select count(*) into total_count
    from que_ads.policy p
    join que_ads."user" u on u.id = p.user_id
    join que_ads.city c on c.id = p.city_id
    join que_ads.sub_category sc on p.sub_category_id = sc.id
  where (filter_category_id is null or sc.category_id = filter_category_id) AND
        (filter_sub_category_id is null or sc.id = filter_sub_category_id) AND
        (filter_city_id is null or c.id = filter_city_id) AND
        (filter_province_id is null or c.province_id = filter_province_id) AND
        (search_text is null or p.subject ilike '%' || search_text || '%' or p.content ilike '%' || search_text || '%' );

  WITH image_groups AS (
    SELECT 
      pimg.policy_id,
      jsonb_agg(
        jsonb_build_object(
          'id', pimg.id,
          'imageFileName', pimg.image_file_name
        )
      ) AS images
    FROM que_ads.policy_image pimg
    GROUP BY pimg.policy_id
  ),

  paged_policies AS (
    SELECT
      p.id,
      p.subject,
      p.content,
      p.phone_number,
      p.offer_type,
      p.price,
      p.view_count,
      p.reply_count,
      p.edit_date,
      p.create_date,
      p.negotiable_ind,

      u.id AS user_id,
      u.name AS user_name,
      u.last_name AS user_last_name,
      u.email_address AS user_email_address,
      u.phone_number AS user_phone_number,

      c.id AS city_id,
      c.name AS city_name,
      c.postal_code AS city_postal_code,
      c.code AS city_code,
      c.province_id AS city_province_id,

      pr.id AS province_id,
      pr.name AS province_name,
      pr.code AS province_code,

      sc.id AS sub_category_id,
      sc.name AS sub_category_name,

      cat.id AS category_id,
      cat.name AS category_name,

      COALESCE(ig.images, '[]'::jsonb) AS images

    FROM que_ads.policy p
    JOIN que_ads."user" u ON u.id = p.user_id
    JOIN que_ads.city c ON c.id = p.city_id
    JOIN que_ads.province pr ON c.province_id = pr.id
    JOIN que_ads.sub_category sc ON p.sub_category_id = sc.id
    JOIN que_ads.category cat ON sc.category_id = cat.id
    LEFT JOIN image_groups ig ON ig.policy_id = p.id
    WHERE
      (filter_category_id IS NULL OR sc.category_id = filter_category_id) AND
      (filter_sub_category_id IS NULL OR sc.id = filter_sub_category_id) AND
      (filter_city_id IS NULL OR c.id = filter_city_id) AND
      (filter_province_id IS NULL OR c.province_id = filter_province_id) AND
      (search_text IS NULL OR p.subject ILIKE '%' || search_text || '%' OR p.content ILIKE '%' || search_text || '%')
    ORDER BY p.create_date DESC
    LIMIT page_size OFFSET data_offset
  )

  SELECT
    COALESCE(jsonb_agg(jsonb_build_object(
      'id', id,
      'subject', subject,
      'content', content,
      'phoneNumber', phone_number,
      'offerType', offer_type,
      'price', price,
      'viewCount', view_count,
      'replyCount', reply_count,
      'editDate', edit_date,
      'createDate', create_date,
      'negotiable', negotiable_ind,
      'user', jsonb_build_object(
        'id', user_id,
        'name', user_name,
        'lastName', user_last_name,
        'emailAddress', user_email_address,
        'phoneNumber', user_phone_number
      ),
      'city', jsonb_build_object(
        'id', city_id,
        'name', city_name,
        'postalCode', city_postal_code,
        'code', city_code,
        'provinceId', city_province_id
      ),
      'province', jsonb_build_object(
        'id', province_id,
        'name', province_name,
        'code', province_code
      ),
      'subCategory', jsonb_build_object(
        'id', sub_category_id,
        'name', sub_category_name,
        'categoryId', category_id
      ),
      'category', jsonb_build_object(
        'id', category_id,
        'name', category_name
      ),
      'images', images
    )), '[]'::jsonb) INTO policies
  FROM paged_policies;

  result := jsonb_build_object(
    'total', total_count,
    'items', coalesce(policies, '[]'::jsonb)
  );

  return result;

end;    
$$;
