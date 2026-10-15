document.addEventListener("DOMContentLoaded", () => {
    // Create Toast Container
    const toastContainer = document.createElement("div");
    toastContainer.className = "toast-container";
    document.body.appendChild(toastContainer);

    function showToast(message, isError = false) {
        const toast = document.createElement("div");
        toast.className = "toast-notification";
        if (isError) {
            toast.style.borderLeftColor = "var(--status-cancelled)";
        }
        
        toast.innerHTML = `
            <div class="toast-icon">${isError ? '\u26a0\ufe0f' : '\u2728'}</div>
            <div class="toast-message">${message}</div>
        `;
        
        toastContainer.appendChild(toast);
        
        // Trigger show animation
        setTimeout(() => {
            toast.classList.add("show");
        }, 50);
        
        // Hide and remove toast
        setTimeout(() => {
            toast.classList.remove("show");
            setTimeout(() => {
                toast.remove();
            }, 400);
        }, 3200);
    }

    // Intercept click on "Thêm +" buttons
    document.body.addEventListener("click", (e) => {
        const btn = e.target.closest(".btn-add-cart");
        if (!btn) return;
        
        e.preventDefault();
        
        const pid = btn.getAttribute("data-pid");
        const productName = btn.getAttribute("data-name") || "s\u1ea3n ph\u1ea9m";
        const url = btn.getAttribute("href");
        
        // Append ajax=true parameter
        const ajaxUrl = url + (url.indexOf("?") >= 0 ? "&" : "?") + "ajax=true";
        
        // Disable button temporarily to prevent spamming
        btn.style.pointerEvents = "none";
        btn.style.opacity = "0.7";
        
        fetch(ajaxUrl, {
            headers: {
                "X-Requested-With": "XMLHttpRequest"
            }
        })
        .then(response => {
            if (!response.ok) throw new Error("M\u1ea5t k\u1ebft n\u1ed1i m\u00e1y ch\u1ee7");
            return response.json();
        })
        .then(data => {
            btn.style.pointerEvents = "auto";
            btn.style.opacity = "1";
            
            if (data.status === "success") {
                // Update badge count
                const badges = document.querySelectorAll(".cart-badge");
                badges.forEach(badge => {
                    badge.textContent = data.cartSize;
                    
                    // Trigger bounce animation
                    badge.classList.remove("nav-cart-bounce");
                    void badge.offsetWidth; // Trigger DOM reflow to restart animation
                    badge.classList.add("nav-cart-bounce");
                });
                
                showToast("\u0110\u00e3 th\u00eam \"" + productName + "\" v\u00e0o gi\u1ecfi h\u00e0ng!");
            } else {
                showToast(data.message || "Kh\u00f4ng th\u1ec3 th\u00eam v\u00e0o gi\u1ecfi h\u00e0ng!", true);
            }
        })
        .catch(err => {
            btn.style.pointerEvents = "auto";
            btn.style.opacity = "1";
            showToast("C\u00f3 l\u1ed7i x\u1ea3y ra, vui l\u00f2ng th\u1eed l\u1ea1i sau!", true);
            console.error(err);
        });
    });
});
