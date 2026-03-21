<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Lỗi hệ thống - PRJ Cinema</title>
    
    <style>
        /* --- 1. RESET & NỀN TỐI --- */
        body {
            background-color: #0b0f19;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #f8fafc;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
            overflow: hidden;
        }
        * { box-sizing: border-box; }
        
        /* --- 2. KHUNG THÔNG BÁO --- */
        .error-container {
            text-align: center;
            padding: 20px;
        }

        /* Hiệu ứng con số lỗi khổng lồ */
        .error-code {
            font-size: 10rem;
            font-weight: 900;
            margin: 0;
            color: #1f2937;
            position: relative;
            line-height: 1;
            letter-spacing: -5px;
            /* Tạo hiệu ứng chữ đổ bóng xếp lớp */
            text-shadow: 
                2px 2px 0px #3b82f6, 
                4px 4px 0px #1e3a8a;
            animation: glitch 3s infinite;
        }

        @keyframes glitch {
            0% { transform: translate(0); }
            20% { transform: translate(-2px, 2px); }
            40% { transform: translate(-2px, -2px); }
            60% { transform: translate(2px, 2px); }
            80% { transform: translate(2px, -2px); }
            100% { transform: translate(0); }
        }

        .error-message {
            font-size: 1.5rem;
            font-weight: bold;
            color: #3b82f6;
            margin-top: -20px;
            margin-bottom: 15px;
            text-transform: uppercase;
        }

        .error-description {
            color: #94a3b8;
            max-width: 400px;
            margin: 0 auto 30px auto;
            line-height: 1.6;
        }

        /* --- 3. NÚT BẤM QUAY LẠI --- */
        .btn-home {
            display: inline-block;
            background-color: #3b82f6;
            color: white;
            text-decoration: none;
            padding: 12px 35px;
            border-radius: 30px;
            font-weight: bold;
            transition: 0.3s;
            box-shadow: 0 5px 15px rgba(59, 130, 246, 0.4);
        }
        .btn-home:hover {
            background-color: #2563eb;
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(59, 130, 246, 0.6);
        }

        /* Trang trí biểu tượng phim (Dùng CSS vẽ đơn giản) */
        .film-icon {
            font-size: 3rem;
            margin-bottom: 20px;
            display: block;
        }
    </style>
</head>
<body>

    <div class="error-container">
        <span class="film-icon">🎬</span>
        
        <h1 class="error-code">404</h1>
        
        <div class="error-message">Đã xảy ra lỗi!</div>
        
        <p class="error-description">
            Rất tiếc, trang bạn đang tìm kiếm không tồn tại hoặc hệ thống đang gặp sự cố nhỏ. 
            Vui lòng thử lại sau hoặc quay về trang chủ.
        </p>
        
        <a href="HomeController" class="btn-home">
            Quay lại Trang Chủ
        </a>
    </div>

</body>
</html>