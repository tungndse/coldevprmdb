create TABLE testtbl
(
    id   int PRIMARY KEY NOT NULL identity (1,1),
    name TEXT            NOT NULL,

)

insert into testtbl
values ('TESTROW1');

select *
from testtbl;

--------------------------------------------------------------------

Drop table testtbl;


CREATE TABLE role
(
    id   BIGINT IDENTITY (1,1) NOT NULL
        CONSTRAINT pk_role PRIMARY KEY,
    name text                  NOT NULL
        CONSTRAINT uq_role_name UNIQUE,

);

CREATE table account
(
    id       BIGINT IDENTITY (1,1) NOT NULL
        CONSTRAINT pk_account PRIMARY KEY,
    role_id  BIGINT                NOT NULL
        CONSTRAINT fk_account_role FOREIGN KEY REFERENCES role (id),
    username TEXT                  not null
        CONSTRAINT uq_account_username UNIQUE,
    password TEXT                  not null,
    address  TEXT                  not null,

);

CREATE TABLE product (
    id BIGINT IDENTITY (1,1) NOT NULL CONSTRAINT pk_product PRIMARY KEY ,
    name TEXT NOT NULL ,
    description TEXT NOT NULL ,
    price NUMERIC NOT NULL default 0,
    category int not null ,
    image_url TEXT,
    stock_quantity bigint NOT NULL default 0,
    created_at timestamp default getdate(),
    status int not null default 1,

    CONSTRAINT chk_price CHECK (price >= 0),
    CONSTRAINT chk_category_positive_and_greater_than_0 CHECK (category > 0),
    CONSTRAINT chk_stock_quantity_equal_or_greater_than_0 CHECK (stock_quantity >=0),
    CONSTRAINT chk_status_equal_or_greater_than_0 CHECK (status > -1),

)






