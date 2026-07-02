-- ========================================
-- 手机商城数据库 mobile
-- ========================================
CREATE DATABASE IF NOT EXISTS mobile_shop DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE mobile_shop;

-- 用户表
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS cart;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    address VARCHAR(200),
    role VARCHAR(10) DEFAULT 'user' COMMENT 'user=普通用户, admin=管理员',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 商品表（手机）
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL COMMENT '商品名称',
    brand VARCHAR(50) COMMENT '品牌',
    description TEXT COMMENT '商品描述',
    price DECIMAL(10,2) NOT NULL COMMENT '价格',
    stock INT DEFAULT 0 COMMENT '库存',
    image VARCHAR(200) COMMENT '图片路径',
    category VARCHAR(50) COMMENT '分类',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品表';

-- 购物车表
CREATE TABLE cart (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT DEFAULT 1,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='购物车表';

-- 订单表
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    order_no VARCHAR(50) NOT NULL UNIQUE COMMENT '订单编号',
    total_amount DECIMAL(10,2) NOT NULL COMMENT '总金额',
    status VARCHAR(20) DEFAULT '待发货' COMMENT '待发货/已发货/已完成',
    receiver_name VARCHAR(50) COMMENT '收货人',
    receiver_phone VARCHAR(20) COMMENT '收货电话',
    receiver_address VARCHAR(200) COMMENT '收货地址',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

-- 订单详情表
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    product_name VARCHAR(100) COMMENT '商品名称',
    product_price DECIMAL(10,2) COMMENT '商品单价',
    quantity INT COMMENT '数量',
    subtotal DECIMAL(10,2) COMMENT '小计',
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单详情表';

-- ========================================
-- 插入初始数据
-- ========================================

-- 管理员账号: admin / admin123
INSERT INTO users (username, password, role) VALUES ('admin', 'admin123', 'admin');

-- 测试用户: test / test123
INSERT INTO users (username, password, email, phone, address) VALUES
('test', 'test123', 'test@qq.com', '13800138000', '北京市朝阳区');

-- 手机商品数据
INSERT INTO products (name, brand, description, price, stock, image, category) VALUES
('iPhone 16 Pro Max', 'Apple', 'A18 Pro芯片 | 6.9英寸超视网膜XDR显示屏 | 4800万像素主摄 | 钛金属设计', 9999.00, 50, 'iphone16.jpg', '旗舰机'),
('iPhone 16', 'Apple', 'A18芯片 | 6.1英寸超视网膜XDR显示屏 | 4800万像素主摄 | 灵动岛设计', 5999.00, 80, 'iphone16_standard.jpg', '旗舰机'),
('华为 Mate 70 Pro', 'Huawei', '麒麟9100芯片 | 6.82英寸OLED曲面屏 | 5000万像素可变光圈 | 鸿蒙系统', 6999.00, 60, 'mate70.jpg', '旗舰机'),
('华为 Pura 70 Ultra', 'Huawei', '麒麟9010芯片 | 6.8英寸LTPO OLED屏 | 1英寸大底主摄 | 卫星通信', 8999.00, 45, 'pura70.jpg', '拍照手机'),
('小米 15 Pro', 'Xiaomi', '骁龙8 Gen4 | 6.73英寸2K AMOLED屏 | 徕卡光学镜头 | 120W快充', 4999.00, 100, 'mi15pro.jpg', '旗舰机'),
('小米 15', 'Xiaomi', '骁龙8 Gen4 | 6.36英寸1.5K屏 | 徕卡三摄 | 90W快充', 3999.00, 120, 'mi15.jpg', '旗舰机'),
('OPPO Find X8 Pro', 'OPPO', '天玑9400 | 6.78英寸AMOLED曲面屏 | 哈苏影像 | 100W闪充', 5999.00, 70, 'findx8.jpg', '拍照手机'),
('vivo X200 Pro', 'Vivo', '天玑9400 | 6.78英寸AMOLED屏 | 蔡司APO长焦 | 蓝海电池', 4999.00, 65, 'x200pro.jpg', '拍照手机'),
('三星 Galaxy S25 Ultra', 'Samsung', '骁龙8 Gen4定制版 | 6.9英寸Dynamic AMOLED | 2亿像素 | S Pen', 9699.00, 40, 's25ultra.jpg', '旗舰机'),
('荣耀 Magic7 Pro', 'Honor', '骁龙8 Gen4 | 6.8英寸OLED四曲屏 | 鹰眼相机 | 青海湖电池', 5299.00, 55, 'magic7.jpg', '旗舰机'),
('一加 13', 'OnePlus', '骁龙8 Gen4 | 6.82英寸2K东方屏 | 哈苏影像 | 100W快充', 4499.00, 85, 'oneplus13.jpg', '旗舰机'),
('红米 K80 Pro', 'Redmi', '骁龙8 Gen3 | 6.67英寸2K屏 | 5000万主摄 | 120W快充', 2999.00, 150, 'k80pro.jpg', '性价比'),
('真我 GT6 Pro', 'Realme', '骁龙8 Gen4 | 6.78英寸1.5K屏 | 索尼IMX890主摄 | 240W快充', 3499.00, 90, 'gt6pro.jpg', '性价比'),
('iQOO 13', 'iQOO', '骁龙8 Gen4 | 6.78英寸2K E7屏 | 电竞芯片 | 120W快充', 3999.00, 75, 'iqoo13.jpg', '游戏手机'),
('ROG Phone 9 Pro', 'ASUS', '骁龙8 Gen4 | 6.78英寸165Hz AMOLED | AirTrigger肩键 | 5500mAh', 5499.00, 30, 'rog9.jpg', '游戏手机');
