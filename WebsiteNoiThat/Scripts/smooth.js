// smooth.js – Tùy chỉnh giao diện mượt (issue #20)
// Hiệu ứng xuất hiện khi cuộn + nút "Về đầu trang". Vanilla JS, không cần jQuery.
(function () {
    'use strict';

    var giamChuyenDong = window.matchMedia &&
        window.matchMedia('(prefers-reduced-motion: reduce)').matches;

    // 1) Các khối sản phẩm/khung nội dung "mọc lên" nhẹ nhàng khi cuộn tới
    function ganHieuUngHien() {
        var targets = document.querySelectorAll('.boxsp, .well, .panel');
        if (!targets.length) return;

        if (!('IntersectionObserver' in window) || giamChuyenDong) {
            // Trình duyệt cũ hoặc người dùng bật giảm chuyển động: hiện luôn
            for (var i = 0; i < targets.length; i++) targets[i].classList.add('fx-in');
            return;
        }

        for (var j = 0; j < targets.length; j++) targets[j].classList.add('fx-reveal');

        var io = new IntersectionObserver(function (entries) {
            for (var k = 0; k < entries.length; k++) {
                if (entries[k].isIntersecting) {
                    entries[k].target.classList.add('fx-in');
                    io.unobserve(entries[k].target);
                }
            }
        }, { rootMargin: '0px 0px -40px 0px', threshold: 0.05 });

        for (var m = 0; m < targets.length; m++) io.observe(targets[m]);
    }

    // 2) Nút tròn "Về đầu trang" ở góc phải dưới
    function ganNutVeDau() {
        var btn = document.createElement('button');
        btn.id = 'backtotop';
        btn.type = 'button';
        btn.setAttribute('aria-label', 'Về đầu trang');
        btn.title = 'Về đầu trang';
        btn.innerHTML = '<i class="fa fa-arrow-up" aria-hidden="true"></i>';
        btn.addEventListener('click', function () {
            window.scrollTo({
                top: 0,
                behavior: giamChuyenDong ? 'auto' : 'smooth'
            });
        });
        document.body.appendChild(btn);

        window.addEventListener('scroll', function () {
            if (window.pageYOffset > 300) btn.classList.add('hien');
            else btn.classList.remove('hien');
        }, { passive: true });
    }

    function chay() {
        try {
            ganHieuUngHien();
            ganNutVeDau();
        } catch (e) {
            // Không bao giờ để hiệu ứng làm hỏng trang
        }
    }

    if (document.readyState !== 'loading') chay();
    else document.addEventListener('DOMContentLoaded', chay);
})();
