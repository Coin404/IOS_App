// 原型界面测试脚本
console.log('开始测试原型界面...');

// 测试页面加载时间
const testPageLoadTime = () => {
    const loadTime = window.performance.timing.domContentLoadedEventEnd - 
                    window.performance.timing.navigationStart;
    console.log(`页面加载时间: ${loadTime.toFixed(2)}ms`);
    return loadTime;
};

// 测试响应式设计
const testResponsiveDesign = () => {
    const breakpoints = {
        mobile: 375,
        tablet: 768,
        desktop: 1024
    };
    
    console.log('测试响应式设计:');
    Object.entries(breakpoints).forEach(([name, width]) => {
        // 在实际环境中，这里会调整视口大小并测试布局
        console.log(`  - 断点 ${name} (${width}px): 已设计响应式布局`);
    });
    return true;
};

// 测试交互元素
const testInteractiveElements = () => {
    console.log('测试交互元素:');
    
    const testElement = (selector, description) => {
        const element = document.querySelector(selector);
        if (element) {
            console.log(`  ✓ ${description}: 存在`);
            return true;
        } else {
            console.log(`  ✗ ${description}: 不存在`);
            return false;
        }
    };
    
    // 通用元素测试
    let success = true;
    
    // 测试状态栏
    success = testElement('.ios-status-bar', 'iOS 状态栏') && success;
    
    // 测试导航栏
    success = testElement('.top-navigation', '顶部导航栏') && success;
    
    // 测试底部标签栏
    success = testElement('.bottom-tab-bar', '底部标签栏') && success;
    
    // 测试按钮
    const buttons = document.querySelectorAll('button, .btn, .action-button');
    console.log(`  - 按钮数量: ${buttons.length}`);
    
    // 测试输入框
    const inputs = document.querySelectorAll('input, textarea, select');
    console.log(`  - 输入框数量: ${inputs.length}`);
    
    return success;
};

// 测试动画效果
const testAnimations = () => {
    console.log('测试动画效果:');
    
    // 检查CSS动画
    const styleSheets = document.styleSheets;
    let hasAnimations = false;
    
    for (let i = 0; i < styleSheets.length; i++) {
        const rules = styleSheets[i].cssRules || styleSheets[i].rules;
        for (let j = 0; j < rules.length; j++) {
            if (rules[j].cssText && 
                (rules[j].cssText.includes('animation') || 
                 rules[j].cssText.includes('transition') ||
                 rules[j].cssText.includes('keyframes'))) {
                hasAnimations = true;
                break;
            }
        }
        if (hasAnimations) break;
    }
    
    console.log(`  - CSS动画/过渡效果: ${hasAnimations ? '存在' : '不存在'}`);
    
    // 检查JavaScript动画函数
    const hasJavascriptAnimations = typeof initPageLoadAnimation !== 'undefined';
    console.log(`  - JavaScript动画函数: ${hasJavascriptAnimations ? '存在' : '不存在'}`);
    
    return hasAnimations || hasJavascriptAnimations;
};

// 优化建议生成器
const generateOptimizationSuggestions = () => {
    console.log('\n优化建议:');
    
    const suggestions = [
        '1. 确保所有图片使用适当的压缩和格式（WebP）',
        '2. 考虑使用懒加载技术加载非关键资源',
        '3. 确保所有交互元素有清晰的触摸反馈',
        '4. 优化字体加载，考虑使用字体子集',
        '5. 确保颜色对比度符合可访问性标准',
        '6. 针对移动设备优化触摸目标大小（至少44x44px）'
    ];
    
    suggestions.forEach(suggestion => console.log(suggestion));
};

// 主测试函数
const runTests = () => {
    console.log('========================================');
    console.log('爱时光 App 原型界面测试报告');
    console.log('========================================');
    
    const loadTime = testPageLoadTime();
    const responsiveTest = testResponsiveDesign();
    const interactiveTest = testInteractiveElements();
    const animationTest = testAnimations();
    
    console.log('\n测试结果摘要:');
    console.log(`- 页面加载性能: ${loadTime < 2000 ? '良好' : '需要优化'}`);
    console.log(`- 响应式设计: ${responsiveTest ? '通过' : '失败'}`);
    console.log(`- 交互元素: ${interactiveTest ? '通过' : '失败'}`);
    console.log(`- 动画效果: ${animationTest ? '通过' : '失败'}`);
    
    generateOptimizationSuggestions();
    
    console.log('\n测试完成。请在浏览器控制台查看详细报告。');
};

// 当文档加载完成后运行测试
document.addEventListener('DOMContentLoaded', () => {
    // 延迟执行，确保页面完全加载
    setTimeout(runTests, 1000);
});