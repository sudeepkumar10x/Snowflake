-- Total Sales
select sum(o_totalprice) from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS where to_timestamp(o_orderdate) = :daterange;

-- No of ORDERS
select count(O_ORDERKEY) from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS where to_timestamp(o_orderdate) = :daterange;

--Order Status wise Count
select o_orderstatus, count(*) from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS
where to_timestamp(o.o_orderdate) =:daterange
group by o_orderstatus;


--Nationwise Sales
select n.n_name ,sum(o.o_totalprice) 
from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS o 
LEFT OUTER JOIN
SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.customer c
ON o.o_custkey=c.c_custkey
LEFT OUTER JOIN 
SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.nation n
on c.c_nationkey = n.n_nationkey
where to_timestamp(o.o_orderdate) =:daterange
group by n.n_name;

--Region wise Sales
select r.r_name ,sum(o.o_totalprice) 
from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS o 
LEFT OUTER JOIN
SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.customer c
ON o.o_custkey=c.c_custkey
LEFT OUTER JOIN 
SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.nation n
on c.c_nationkey = n.n_nationkey
LEFT OUTER JOIN
SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.region r
on n.n_nationkey=r.r_regionkey
where to_timestamp(o.o_orderdate) =:daterange
group by r.r_name;

