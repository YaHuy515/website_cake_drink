document.addEventListener("DOMContentLoaded", () => {
    // Check if the user turned it off previously
    let isBlossomActive = localStorage.getItem("blossom_active") !== "false";
    
    // Create blossom container
    const container = document.createElement("div");
    container.className = "blossom-container";
    document.body.appendChild(container);
    
    // Create control button
    const toggleBtn = document.createElement("button");
    toggleBtn.className = `blossom-toggle ${isBlossomActive ? "" : "off"}`;
    toggleBtn.title = isBlossomActive ? "T\u1eaft hi\u1ec7u \u1ee9ng hoa \u0111\u00e0o r\u01a1i" : "B\u1eadt hi\u1ec7u \u1ee9ng hoa \u0111\u00e0o r\u01a1i";
    toggleBtn.innerHTML = "\u{1F338}";
    document.body.appendChild(toggleBtn);
    
    let intervalId = null;
    
    function createPetal() {
        if (!isBlossomActive) return;
        
        // Count active petals
        if (container.childElementCount > 35) return; // Limit total petals to prevent lag
        
        const petal = document.createElement("div");
        petal.className = "petal";
        
        // Randomize petal properties
        const size = Math.random() * 15 + 8; // 8px to 23px
        const startX = Math.random() * window.innerWidth;
        const duration = Math.random() * 6 + 6; // 6s to 12s
        const maxOpacity = Math.random() * 0.4 + 0.5; // 0.5 to 0.9
        const swayX = (Math.random() - 0.5) * 300; // Sway direction and distance (-150px to 150px)
        const rotation = Math.random() * 360 + 360; // 360deg to 720deg
        const rotationY = Math.random() * 720 - 360; // -360deg to 360deg
        
        // Apply inline styles and custom CSS variables for keyframe interpolation
        petal.style.width = `${size}px`;
        petal.style.height = `${size}px`;
        petal.style.left = `${startX}px`;
        petal.style.animation = `fall-and-sway ${duration}s linear forwards`;
        petal.style.setProperty("--sway-x", `${swayX}px`);
        petal.style.setProperty("--max-opacity", maxOpacity);
        petal.style.setProperty("--rotation", `${rotation}deg`);
        petal.style.setProperty("--rotation-y", `${rotationY}deg`);
        
        // Add random petal variations (shapes & gradients)
        const shapeType = Math.floor(Math.random() * 3);
        if (shapeType === 0) {
            petal.style.borderRadius = "50% 0 50% 50%"; // Traditional teardrop/leaf
            petal.style.background = "linear-gradient(135deg, #ffb7c5, #ffa0b4)";
        } else if (shapeType === 1) {
            petal.style.borderRadius = "50% 50% 0 50%"; // Rotated leaf
            petal.style.background = "linear-gradient(135deg, #ffd1dc, #ff9eb5)"; // Lighter pink
        } else {
            petal.style.borderRadius = "50% 50% 50% 50%"; // Oval/round petal
            petal.style.background = "linear-gradient(135deg, #ffc0cb, #ff8da1)"; // Darker pink
        }
        
        container.appendChild(petal);
        
        // Clean up petal after animation ends
        setTimeout(() => {
            petal.remove();
        }, duration * 1000);
    }
    
    function startBlossom() {
        if (intervalId) clearInterval(intervalId);
        // Create initial batch of petals immediately
        for (let i = 0; i < 10; i++) {
            setTimeout(createPetal, Math.random() * 5000);
        }
        intervalId = setInterval(createPetal, 400);
    }
    
    function stopBlossom() {
        if (intervalId) {
            clearInterval(intervalId);
            intervalId = null;
        }
        // Empty the container
        container.innerHTML = "";
    }
    
    toggleBtn.addEventListener("click", () => {
        isBlossomActive = !isBlossomActive;
        localStorage.setItem("blossom_active", isBlossomActive);
        
        if (isBlossomActive) {
            toggleBtn.className = "blossom-toggle";
            toggleBtn.title = "T\u1eaft hi\u1ec7u \u1ee9ng hoa \u0111\u00e0o r\u01a1i";
            startBlossom();
        } else {
            toggleBtn.className = "blossom-toggle off";
            toggleBtn.title = "B\u1eadt hi\u1ec7u \u1ee9ng hoa \u0111\u00e0o r\u01a1i";
            stopBlossom();
        }
    });
    
    // Auto-start if active
    if (isBlossomActive) {
        startBlossom();
    }
});
