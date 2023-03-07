
-- 1

select
  extract ( hour from timestamp_seconds( visitStartTime ) ) as hour_of_day -- extracts the hour from the timestamp in epoch time associated w/ a session start
  , sum ( totals.hits ) as number_of_events -- aggregates the number of "hits" or events
  , count( distinct concat(fullVisitorId, visitId) ) as unique_session_count -- counts unique records of a combination of fullVisitorId & visitId appended together to get a true calculation of "sessions"
  , count( distinct fullVisitorId ) as unique_user_count -- counts unique "users" or fullVisitorIds 
from
  bigquery-public-data.google_analytics_sample.ga_sessions_20170801
group by 1 -- groups by hour_of_day
order by 1 asc -- arranges the result query by ascending hours of the day (chronological)

-- 2

select
  p.v2ProductCategory as product_category -- product category from nested "products"
  , count( distinct fullVisitorId ) as unique_user_count -- counts unique "users" or fullVisitorIds 
from
  bigquery-public-data.google_analytics_sample.ga_sessions_20170801
  , unnest(hits) as h -- unnests hits from table
  , unnest (h.product) as p -- unnests products from hits
where h.eventInfo.eventAction in ('Quickview Click', 'Product Click', 'Promotion Click') and h.type = 'EVENT' -- filters query results where eventActions are within a set of click envents and filters out "PAGE" events
group by 1 -- groups by product category
order by 2 desc -- orders by unique users in descending order

-- 3

select
  case 
    when totals.transactions > 0 
        then 'with_purchase' 
    else 'without_purchase' 
  end as session_purchase_type -- creates a new categorization of records based on the premise that transactions with a value > 0 are a "purchase". Any resulting record where a value is <= 0 is labelled as "without_purchase"
  , count( distinct concat( fullVisitorId, visitId ) ) as unique_session_count -- counts unique records of a combination of fullVisitorId & visitId appended together to get a true calculation of "sessions"
from
  bigquery-public-data.google_analytics_sample.ga_sessions_20170801
  , unnest(hits) as h -- unnests hits from table
where h.eventInfo.eventAction = 'Add to Cart' -- filters for "Add to Cart" events only
group by 1 -- groups by session_purchase_type

-- 4

select distinct
  concat(fullVisitorId, visitId) as unique_session_id -- a combination of fullVisitorId & visitId appended together to get a true unique key of each "sessions"
  , trafficSource.source -- traffic source from which the session originated (could be a variety of redirects from various websites/hooks)
  , trafficSource.medium -- medium of the traffic source ("organic", "cpc", "referral", or unique key)
  , device.deviceCategory -- type of device (Mobile, Tablet, Desktop)
  , geoNetwork.country -- country from which sessions originated
  , visitNumber -- session number for the user associated w/ a session
  , totals.timeOnSite -- total time of the session expressed in seconds
  , totals.sessionQualityDim -- precreated feature determining session quality (could be a quick pre-prepped linear relationship w/ purchases)
  , case
      when totals.transactions > 0 then 1
      else 0
    end
  as is_purchase -- binary flag describing if a session resulted in a purchase (1) or not (0)
from
  bigquery-public-data.google_analytics_sample.ga_sessions_20170801
  , unnest(hits) as h
where 1=1 
   and h.eventInfo.eventAction = 'Add to Cart' -- filtering for "Add to Carts" only


