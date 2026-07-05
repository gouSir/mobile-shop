# 手机商城 - 

## 项目概述
一个基于 Java Servlet + JSP + MySQL 的手机购物平台网站。

## 技术栈
- **后端**: Java Servlet + JSP
- **数据库**: MySQL 8.0 (数据库名: `mobile`)
- **前端**: Bootstrap 5 + 原生 JavaScript
- **构建工具**: Maven
- **服务器**: Apache Tomcat 8.5+

## 项目结构
```
mobile-shop/
├── database/
│   └── init.sql          # 数据库初始化脚本（表结构+初始数据）
├── src/main/java/com/shop/
│   ├── model/            # 实体类
│   │   ├── User.java        用户实体
│   │   ├── Product.java     商品实体
│   │   ├── CartItem.java    购物车项实体
│   │   ├── Order.java       订单实体
│   │   └── OrderItem.java   订单明细实体
│   ├── dao/              # 数据访问层
│   │   ├── UserDao.java     用户DAO
│   │   ├── ProductDao.java  商品DAO
│   │   ├── CartDao.java     购物车DAO
│   │   └── OrderDao.java    订单DAO
│   ├── servlet/          # 控制器层
│   │   ├── LoginServlet.java        登录
│   │   ├── RegisterServlet.java     注册
│   │   ├── LogoutServlet.java       退出
│   │   ├── ProductServlet.java      商品列表/搜索/详情
│   │   ├── CartServlet.java         购物车
│   │   ├── OrderServlet.java        订单
│   │   ├── AdminProductServlet.java 管理员-商品管理
│   │   └── AdminOrderServlet.java   管理员-订单管理
│   ├── filter/           # 过滤器
│   │   └── EncodingFilter.java   编码过滤器
│   └── util/             # 工具类
│       └── DBUtil.java          数据库连接工具
├── src/main/webapp/
│   ├── WEB-INF/
│   │   └── web.xml       # 部署描述符
│   ├── css/              # 样式文件
│   ├── js/               # JS脚本
│   ├── images/           # 商品图片
│   └── jsp/              # 前端页面
│       ├── header.jsp        公共头部+导航
│       ├── footer.jsp        公共底部
│       ├── index.jsp         首页（轮播+推荐+品牌+分类）
│       ├── login.jsp         登录页
│       ├── register.jsp      注册页
│       ├── product_list.jsp  商品列表（品牌/分类筛选+搜索）
│       ├── product_detail.jsp 商品详情
│       ├── cart.jsp          购物车
│       ├── order_create.jsp  确认下单
│       ├── order_list.jsp    我的订单
│       └── admin/
│           ├── product_list.jsp  管理员-商品管理
│           ├── product_form.jsp  管理员-商品添加/编辑
│           └── order_list.jsp    管理员-订单管理
└── pom.xml               # Maven配置
```

## 环境要求
- JDK 1.8+
- Maven 3.6+
- MySQL 8.0
- Apache Tomcat 8.5 或 Tomcat 9

## 快速开始

### 1. 初始化数据库
打开 MySQL 客户端，执行 `database/init.sql`：
```bash
mysql -u root -p < database/init.sql
```
密码: `root`

该脚本会：
- 创建 `mobile` 数据库
- 创建5张表（users, products, cart, orders, order_items）
- 插入管理员账号和测试用户
- 插入15款手机商品数据

### 2. 配置数据库连接
数据库连接配置在 `src/main/java/com/shop/util/DBUtil.java`：
- URL: `jdbc:mysql://localhost:3306/mobile`
- 用户名: `root`
- 密码: `root`
如需修改，直接编辑该文件即可。

### 3. 编译部署
```bash
# 在项目根目录下
mvn clean package

# 将 target/mobile-shop.war 部署到 Tomcat 的 webapps 目录
```

或在 IDE（Eclipse/IntelliJ IDEA）中：
1. 导入为 Maven 项目
2. 配置 Tomcat Server
3. 运行项目

### 4. 访问
- 首页: `http://localhost:8080/mobile-shop/`
- 登录: `http://localhost:8080/mobile-shop/user/login`

## 测试账号
| 角色 | 用户名 | 密码 | 说明 |
|------|--------|------|------|
| 管理员 | admin | admin123 | 可管理商品和订单 |
| 普通用户 | test | test123 | 可浏览和购物 |

## 功能说明

### 普通用户功能
1. **注册/登录**: 用户注册和登录
2. **商品浏览**: 按品牌、分类筛选，关键词搜索
3. **商品详情**: 查看商品详细信息和价格
4. **购物车**: 添加商品、修改数量、删除
5. **下单**: 确认收货信息后提交订单
6. **订单查看**: 查看历史订单和状态

### 管理员功能
1. **商品管理**: 添加/编辑/删除商品
2. **订单管理**: 查看所有订单，发货/完成/删除订单

## 数据库表结构
- **users**: 用户表（id, username, password, email, phone, address, role）
- **products**: 商品表（id, name, brand, description, price, stock, image, category）
- **cart**: 购物车（id, user_id, product_id, quantity）
- **orders**: 订单表（id, user_id, order_no, total_amount, status, 收货信息）
- **order_items**: 订单明细（id, order_id, product_id, 商品快照）

## 注意事项
- 商品图片请放置在 `src/main/webapp/images/` 目录下
- 数据库密码请根据实际情况修改 `DBUtil.java`
- 项目使用 javax.servlet (Tomcat 9兼容)，如使用 Tomcat 10+ 需迁移到 Jakarta EE
