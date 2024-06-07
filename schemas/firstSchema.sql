CREATE TABLE testtbl
(
    id   INT PRIMARY KEY NOT NULL IDENTITY (1,1),
    name VARCHAR(MAX)    NOT NULL,

)

INSERT INTO testtbl
VALUES ('TESTROW1');

SELECT *
FROM testtbl;

--------------------------------------------------------------------

DROP TABLE testtbl;
USE master;

CREATE DATABASE coldev;

USE coldev;

CREATE TABLE account_role
(
    id   BIGINT IDENTITY (1,1) NOT NULL
        CONSTRAINT pk_accountrole PRIMARY KEY,
    name NVARCHAR(30)          NOT NULL
        CONSTRAINT uq_role_name UNIQUE,

);

CREATE TABLE account
(
    id       BIGINT IDENTITY (1,1) NOT NULL
        CONSTRAINT pk_account PRIMARY KEY,
    account_role_id  BIGINT                NOT NULL
        CONSTRAINT fk_account_role FOREIGN KEY REFERENCES account_role (id),
    username VARCHAR(100)          NOT NULL
        CONSTRAINT uq_account_username UNIQUE,
    password NVARCHAR(MAX)         NOT NULL,
    address  NVARCHAR(MAX)         NOT NULL,

);

CREATE TABLE product
(
    id             BIGINT IDENTITY (1,1) NOT NULL
        CONSTRAINT pk_product PRIMARY KEY,
    name           NVARCHAR(MAX)         NOT NULL,
    description    NVARCHAR(MAX)         NOT NULL,
    price          DECIMAL(19, 4)        NOT NULL DEFAULT 0,
    category       INT                   NOT NULL,
    image_url      NVARCHAR(MAX),
    stock_quantity BIGINT                NOT NULL DEFAULT 0,
    created_at     DATETIME2                      DEFAULT getdate(),
    status         VARCHAR(10)           NOT NULL DEFAULT 'ACTIVE',

    CONSTRAINT chk_price CHECK (price >= 0),
    CONSTRAINT chk_category_positive_and_greater_than_0 CHECK (category > 0),
    CONSTRAINT chk_stock_quantity_equal_or_greater_than_0 CHECK (stock_quantity >= 0),
    CONSTRAINT chk_product_status_enum CHECK (status IN ('ACTIVE', 'DELETED', 'HIDDEN')),

);

CREATE TABLE combo
(
    id                  BIGINT IDENTITY (1,1) NOT NULL
        CONSTRAINT pk_combo PRIMARY KEY,

    name                NVARCHAR(MAX)         NOT NULL,
    discount_percentage DOUBLE PRECISION,
    discount_value      DECIMAL(19, 4),
    status              VARCHAR(10)           NOT NULL DEFAULT 'ACTIVE',

    CONSTRAINT chk_discount_percentage_0_to_1 CHECK (discount_percentage >= 0 AND discount_percentage <= 1),
    CONSTRAINT chk_discount_value_not_negative CHECK (discount_value >= 0),

    CONSTRAINT chk_combo_status_enum CHECK (status IN ('ACTIVE', 'DELETED', 'HIDDEN')),

);

CREATE TABLE product_combo
(
    id         BIGINT IDENTITY (1,1) NOT NULL
        CONSTRAINT pk_productcombo PRIMARY KEY,
    combo_id   BIGINT                NOT NULL,
    product_id BIGINT                NOT NULL,

    CONSTRAINT fk_productcombo_productid FOREIGN KEY (product_id) REFERENCES product,
    CONSTRAINT fk_productcombo_comboid FOREIGN KEY (combo_id) REFERENCES combo,

    CONSTRAINT UQ_productcombo_productid_comboid UNIQUE (product_id, combo_id)

);

CREATE TABLE customer_order
(
    id           BIGINT IDENTITY (1,1) NOT NULL
        CONSTRAINT pk_customerorder PRIMARY KEY,
    customer_id  BIGINT                NOT NULL,
    combo_id     BIGINT,
    address      NVARCHAR(MAX),
    created_at   DATETIME2                      DEFAULT getdate(),
    completed_at DATETIME2,
    status       VARCHAR(10)           NOT NULL DEFAULT 'PENDING',
    total_price  DECIMAL(19, 4)        NOT NULL DEFAULT 0,


    --CONSTRAINT chk_customerorder_status_enum CHECK (???),
    CONSTRAINT fk_customerorder_customerid FOREIGN KEY (customer_id) REFERENCES account,
    CONSTRAINT fk_customerorder_comboid FOREIGN KEY (combo_id) REFERENCES combo,

);

CREATE TABLE customer_order_item
(
    id         BIGINT IDENTITY (1,1) NOT NULL
        CONSTRAINT pk_customerorderitem PRIMARY KEY,
    order_id   BIGINT                NOT NULL,
    product_id BIGINT                NOT NULL,
    unit_price DECIMAL(19, 4)        NOT NULL DEFAULT 0,
    quantity   BIGINT                NOT NULL DEFAULT 1,
    rating     DOUBLE PRECISION,

    CONSTRAINT fk_customerorderitem_orderid FOREIGN KEY (order_id) REFERENCES customer_order,
    CONSTRAINT fk_customerorderitem_productid FOREIGN KEY (product_id) REFERENCES product,
    CONSTRAINT chk_customerorderitem_quantity_greaterthan_0 CHECK (quantity > 0),
    CONSTRAINT chk_customerorderitem_rating_0_to_5 CHECK (rating >= 0 AND rating <= 5),

);

CREATE TABLE cart_item
(
    id          BIGINT IDENTITY (1,1) NOT NULL
        CONSTRAINT pk_cartitem PRIMARY KEY,
    customer_id BIGINT                NOT NULL,
    product_id  BIGINT                NOT NULL,
    combo_id    BIGINT                NOT NULL,

    is_combo    bit                   NOT NULL,
    quantity    BIGINT                NOT NULL DEFAULT 1,

    CONSTRAINT fk_cartitem_customerid FOREIGN KEY (customer_id) REFERENCES account,
    CONSTRAINT fk_cartitem_productid FOREIGN KEY (product_id) REFERENCES product,
    CONSTRAINT fk_cartitem_comboid FOREIGN KEY (combo_id) REFERENCES combo,
    CONSTRAINT chk_cartitem_quantity_greaterthan_0 CHECK (quantity > 0),

);







