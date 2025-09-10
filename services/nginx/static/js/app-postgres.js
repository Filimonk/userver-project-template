async function sendGreeting() {
    const name = document.getElementById('name').value;
    const resultDiv = document.getElementById('result');
    
    if (!name) {
        resultDiv.innerHTML = 'Пожалуйста, введите имя';
        resultDiv.className = 'result error';
        return;
    }
    
    try {
        // Отправляем запрос к микросервису
        const response = await fetch(`/api/hello-postgres?name=${encodeURIComponent(name)}`);
        
        if (!response.ok) {
            throw new Error(`Ошибка HTTP: ${response.status}`);
        }
        
        const data = await response.text();
        resultDiv.innerHTML = `Ответ от сервера: ${data}`;
        resultDiv.className = 'result success';
    } catch (error) {
        resultDiv.innerHTML = `Ошибка: ${error.message}`;
        resultDiv.className = 'result error';
        console.error('Ошибка:', error);
    }
}

// Добавляем обработчик нажатия Enter в поле ввода
document.getElementById('name').addEventListener('keypress', function(event) {
    if (event.key === 'Enter') {
        sendGreeting();
    }
});

