/* ARTYBLANC — Shopify Theme JavaScript */
(function() {
    'use strict';

    document.addEventListener('DOMContentLoaded', function() {
        initNavScroll();
        initScrollReveals();
        initAccordions();
        initProductGallery();
        initSmoothScroll();
    });

    /* ═══ NAV SCROLL ═══ */
    function initNavScroll() {
        var nav = document.getElementById('nav');
        if (!nav) return;
        var ticking = false;
        window.addEventListener('scroll', function() {
            if (!ticking) {
                requestAnimationFrame(function() {
                    if (window.scrollY > 80) {
                        nav.classList.add('scrolled');
                    } else {
                        nav.classList.remove('scrolled');
                    }
                    ticking = false;
                });
                ticking = true;
            }
        }, { passive: true });
    }

    /* ═══ SCROLL REVEALS ═══ */
    function initScrollReveals() {
        var els = document.querySelectorAll('.reveal');
        if (!els.length) return;
        if (!('IntersectionObserver' in window)) {
            els.forEach(function(el) { el.classList.add('visible'); });
            return;
        }
        var observer = new IntersectionObserver(function(entries) {
            entries.forEach(function(entry) {
                if (entry.isIntersecting) {
                    entry.target.classList.add('visible');
                    observer.unobserve(entry.target);
                }
            });
        }, { threshold: 0.1, rootMargin: '0px 0px -50px 0px' });
        els.forEach(function(el) { observer.observe(el); });
    }

    /* ═══ ACCORDIONS ═══ */
    function initAccordions() {
        var triggers = document.querySelectorAll('.accordion-trigger');
        triggers.forEach(function(trigger) {
            trigger.addEventListener('click', function() {
                var item = trigger.closest('.accordion-item');
                var isOpen = item.classList.contains('open');
                // Close siblings
                var siblings = item.parentElement.querySelectorAll('.accordion-item.open');
                siblings.forEach(function(s) { s.classList.remove('open'); s.querySelector('.accordion-trigger').setAttribute('aria-expanded', 'false'); });
                // Toggle
                if (!isOpen) {
                    item.classList.add('open');
                    trigger.setAttribute('aria-expanded', 'true');
                }
            });
        });
    }

    /* ═══ PRODUCT GALLERY ═══ */
    function initProductGallery() {
        var thumbs = document.querySelectorAll('.product-thumb');
        var mainImg = document.getElementById('product-main-img');
        if (!thumbs.length || !mainImg) return;
        thumbs.forEach(function(thumb) {
            thumb.addEventListener('click', function() {
                thumbs.forEach(function(t) { t.classList.remove('product-thumb--active'); });
                thumb.classList.add('product-thumb--active');
                var newSrc = thumb.getAttribute('data-src');
                if (newSrc) {
                    mainImg.style.opacity = '0';
                    setTimeout(function() { mainImg.src = newSrc; mainImg.style.opacity = '1'; }, 250);
                }
            });
        });
    }

    /* ═══ SMOOTH SCROLL ═══ */
    function initSmoothScroll() {
        document.querySelectorAll('a[href^="#"]').forEach(function(a) {
            a.addEventListener('click', function(e) {
                var href = a.getAttribute('href');
                if (href === '#' || href === '#0') return;
                var target = document.querySelector(href);
                if (target) {
                    e.preventDefault();
                    target.scrollIntoView({ behavior: 'smooth', block: 'start' });
                }
            });
        });
    }
})();
