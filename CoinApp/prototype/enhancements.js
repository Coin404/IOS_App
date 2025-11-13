// 增强用户界面真实感的JavaScript函数库

// 更新状态栏时间
function updateStatusBarTime() {
    const timeElements = document.querySelectorAll('.ios-status-bar .text-dark.font-semibold');
    timeElements.forEach(element => {
        const now = new Date();
        let hours = now.getHours();
        let minutes = now.getMinutes();
        minutes = minutes < 10 ? '0' + minutes : minutes;
        element.textContent = `${hours}:${minutes}`;
    });
}

// 初始化状态栏
function initStatusBar() {
    updateStatusBarTime();
    // 每分钟更新一次时间
    setInterval(updateStatusBarTime, 60000);
}

// 添加iOS风格的点击波纹效果
function addRippleEffect() {
    const clickableElements = document.querySelectorAll('.setting-item, .task-item, .diary-item, .achievement-card, .stat-card');
    
    clickableElements.forEach(element => {
        element.addEventListener('click', function(e) {
            // 排除带开关的设置项
            if (!this.querySelector('.ios-switch')) {
                const ripple = document.createElement('span');
                const rect = this.getBoundingClientRect();
                const size = Math.max(rect.width, rect.height);
                const x = e.clientX - rect.left - size / 2;
                const y = e.clientY - rect.top - size / 2;
                
                ripple.style.width = ripple.style.height = `${size}px`;
                ripple.style.left = `${x}px`;
                ripple.style.top = `${y}px`;
                ripple.classList.add('ripple');
                
                // 移除之前的波纹
                const oldRipple = this.querySelector('.ripple');
                if (oldRipple) {
                    oldRipple.remove();
                }
                
                this.appendChild(ripple);
            }
        });
    });
}

// 初始化iOS风格的开关
function initIOSSwitches() {
    const switches = document.querySelectorAll('.ios-switch input');
    switches.forEach(switchEl => {
        switchEl.addEventListener('change', function() {
            // 添加轻微的震动反馈（如果设备支持）
            if (navigator.vibrate) {
                navigator.vibrate(10);
            }
        });
    });
}

// 添加滑动返回手势支持（模拟）
function addSwipeGestureSupport() {
    let touchStartX = 0;
    let touchEndX = 0;
    
    document.addEventListener('touchstart', function(e) {
        touchStartX = e.changedTouches[0].screenX;
    }, false);
    
    document.addEventListener('touchend', function(e) {
        touchEndX = e.changedTouches[0].screenX;
        handleSwipeGesture();
    }, false);
    
    function handleSwipeGesture() {
        const swipeThreshold = 50;
        // 从左侧向右滑动，模拟返回手势
        if (touchEndX - touchStartX > swipeThreshold && touchStartX < 50) {
            console.log('Swipe back gesture detected');
            // 这里可以添加返回上一页的逻辑
            // window.history.back();
        }
    }
}

// 添加滚动时导航栏样式变化
function addScrollEffects() {
    const topNavigation = document.querySelector('.top-navigation');
    if (topNavigation) {
        window.addEventListener('scroll', function() {
            if (window.scrollY > 10) {
                topNavigation.style.boxShadow = '0 2px 8px rgba(0, 0, 0, 0.1)';
            } else {
                topNavigation.style.boxShadow = '0 1px 3px rgba(0, 0, 0, 0.05)';
            }
        });
    }
}

// 初始化页面加载动画
function initPageLoadAnimation() {
    // 添加页面淡入效果
    document.body.style.opacity = '0';
    setTimeout(() => {
        document.body.style.transition = 'opacity 0.3s ease';
        document.body.style.opacity = '1';
    }, 100);
}

// 添加底部标签栏切换效果
function initTabBarSwitching() {
    const tabItems = document.querySelectorAll('.tab-item');
    tabItems.forEach(tab => {
        tab.addEventListener('click', function() {
            // 移除所有激活状态
            tabItems.forEach(item => {
                item.classList.remove('active');
                item.classList.add('inactive');
            });
            
            // 设置当前激活状态
            this.classList.remove('inactive');
            this.classList.add('active');
            
            // 添加轻微的震动反馈（如果设备支持）
            if (navigator.vibrate) {
                navigator.vibrate(10);
            }
        });
    });
}

// 添加iOS风格的下拉刷新效果（简单模拟）
function addPullToRefresh() {
    let startY = 0;
    let refreshing = false;
    const refreshThreshold = 80;
    let refreshElement = null;
    
    // 创建刷新指示器
    function createRefreshIndicator() {
        if (!refreshElement) {
            refreshElement = document.createElement('div');
            refreshElement.className = 'pull-refresh-indicator';
            refreshElement.style.cssText = `
                position: absolute;
                top: -60px;
                left: 0;
                right: 0;
                height: 60px;
                display: flex;
                justify-content: center;
                align-items: center;
                color: #FF6B6B;
                font-size: 14px;
                transition: transform 0.3s ease;
                transform: translateY(0);
            `;
            refreshElement.innerHTML = '<i class="fa fa-spinner fa-spin"></i> 刷新中...';
            document.body.insertBefore(refreshElement, document.body.firstChild);
        }
    }
    
    document.addEventListener('touchstart', function(e) {
        if (window.scrollY === 0 && !refreshing) {
            startY = e.touches[0].pageY;
        }
    }, { passive: true });
    
    document.addEventListener('touchmove', function(e) {
        if (window.scrollY === 0 && !refreshing && e.touches[0].pageY > startY) {
            const pullDistance = e.touches[0].pageY - startY;
            if (pullDistance > 0) {
                createRefreshIndicator();
                const transformDistance = Math.min(pullDistance * 0.5, refreshThreshold);
                refreshElement.style.transform = `translateY(${transformDistance}px)`;
                
                if (pullDistance > refreshThreshold) {
                    refreshElement.innerHTML = '<i class="fa fa-check"></i> 释放刷新';
                } else {
                    refreshElement.innerHTML = '<i class="fa fa-arrow-down"></i> 下拉刷新';
                }
            }
        }
    }, { passive: true });
    
    document.addEventListener('touchend', function() {
        if (window.scrollY === 0 && !refreshing && refreshElement) {
            const currentTransform = refreshElement.style.transform;
            const translateY = parseInt(currentTransform.replace('translateY(', '').replace('px)', '')) || 0;
            
            if (translateY >= refreshThreshold) {
                refreshing = true;
                refreshElement.innerHTML = '<i class="fa fa-spinner fa-spin"></i> 刷新中...';
                refreshElement.style.transform = 'translateY(60px)';
                
                // 模拟刷新数据
                setTimeout(() => {
                    refreshElement.style.transform = 'translateY(0)';
                    refreshing = false;
                    
                    // 在这里可以添加实际的数据刷新逻辑
                    console.log('Data refreshed');
                }, 1500);
            } else {
                refreshElement.style.transform = 'translateY(0)';
            }
        }
    }, { passive: true });
}

// 初始化所有增强功能
function initAllEnhancements() {
    // 添加通用的波纹效果样式
    const style = document.createElement('style');
    style.textContent = `
        .ripple {
            position: absolute;
            border-radius: 50%;
            background-color: rgba(255, 255, 255, 0.6);
            transform: scale(0);
            animation: ripple 0.6s linear;
            pointer-events: none;
            z-index: 1000;
        }
        
        @keyframes ripple {
            to {
                transform: scale(4);
                opacity: 0;
            }
        }
    `;
    document.head.appendChild(style);
    
    // 初始化各个功能
    initStatusBar();
    initIOSSwitches();
    addRippleEffect();
    addSwipeGestureSupport();
    addScrollEffects();
    initPageLoadAnimation();
    initTabBarSwitching();
    
    // 只在可滚动的页面添加下拉刷新
    if (document.querySelector('.main-content')) {
        addPullToRefresh();
    }
}

// 当文档加载完成时初始化所有增强功能
document.addEventListener('DOMContentLoaded', initAllEnhancements);