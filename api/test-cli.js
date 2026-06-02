const http = require('http');

const BASE_URL = 'http://localhost:3000/api';

async function request(path, method = 'GET', body = null, token = null) {
  return new Promise((resolve, reject) => {
    const url = new URL(BASE_URL + path);
    const options = {
      hostname: url.hostname,
      port: url.port,
      path: url.pathname + url.search,
      method: method,
      headers: {
        'Content-Type': 'application/json',
      }
    };

    if (token) {
      options.headers['Authorization'] = `Bearer ${token}`;
    }

    const req = http.request(options, (res) => {
      let data = '';
      res.on('data', (chunk) => data += chunk);
      res.on('end', () => {
        try {
          resolve({ status: res.statusCode, data: JSON.parse(data) });
        } catch (e) {
          resolve({ status: res.statusCode, data });
        }
      });
    });

    req.on('error', reject);

    if (body) {
      req.write(JSON.stringify(body));
    }
    req.end();
  });
}

async function runTests() {
  console.log('=====================================');
  console.log('1. MENGUJI REGISTER & LOGIN');
  console.log('=====================================');
  
  // Mencoba register (abaikan jika email sudah ada)
  const regEmail = `petani${Math.floor(Math.random() * 1000)}@agrotani.com`;
  console.log(`Mencoba mendaftar dengan email: ${regEmail}...`);
  const regRes = await request('/auth/register', 'POST', {
    name: 'Petani Budi',
    email: regEmail,
    password: 'password123'
  });
  console.log('Register Response:', JSON.stringify(regRes.data));

  console.log('\nMencoba login...');
  const loginRes = await request('/auth/login', 'POST', {
    email: regEmail,
    password: 'password123'
  });
  console.log('Login Response:', JSON.stringify(loginRes.data, null, 2));
  
  const token = loginRes.data.token || loginRes.data.accessToken;
  if (!token) {
    console.error('❌ Gagal mendapatkan token. Pastikan server NestJS sudah berjalan.');
    return;
  }
  console.log('✅ Token berhasil didapatkan\n');

  console.log('=====================================');
  console.log('2. MENGUJI GET PROFILE');
  console.log('=====================================');
  
  const profileRes = await request('/auth/profile', 'GET', null, token);
  console.log('Response:', JSON.stringify(profileRes.data, null, 2), '\n');

  console.log('=====================================');
  console.log('3. MENGUJI CHAT GEMINI (SESI BARU)');
  console.log('=====================================');
  console.log('⏳ Menunggu balasan dari Gemini AI...');
  
  const chat1Res = await request('/chat/send', 'POST', {
    message: 'Halo, saya punya masalah dengan tanaman padi yang daunnya menguning. Apa penyebabnya?'
  }, token);
  console.log('Response:', JSON.stringify(chat1Res.data, null, 2));
  
  const sessionId = chat1Res.data.sessionId;
  if (!sessionId) {
    console.error('❌ Gagal mendapatkan sessionId');
    return;
  }
  console.log(`✅ Session ID didapatkan: ${sessionId}\n`);

  console.log('=====================================');
  console.log('4. MENGUJI CHAT GEMINI (LANJUTAN SESI)');
  console.log('=====================================');
  console.log('⏳ Menunggu balasan dari Gemini AI...');
  
  const chat2Res = await request('/chat/send', 'POST', {
    sessionId: sessionId,
    message: 'Apa rekomendasi pupuk yang paling cocok untuk masalah tersebut?'
  }, token);
  console.log('Response:', JSON.stringify(chat2Res.data, null, 2), '\n');

  console.log('=====================================');
  console.log('5. MENGUJI GET SESSIONS');
  console.log('=====================================');
  
  const sessionsRes = await request('/chat/sessions', 'GET', null, token);
  console.log('Response:', JSON.stringify(sessionsRes.data, null, 2), '\n');

  console.log('=====================================');
  console.log('6. MENGUJI GET MESSAGES DARI SESI');
  console.log('=====================================');
  
  const messagesRes = await request(`/chat/${sessionId}/messages`, 'GET', null, token);
  
  // Format pesan agar lebih mudah dibaca di terminal
  if (Array.isArray(messagesRes.data)) {
    console.log('Riwayat Percakapan:');
    messagesRes.data.forEach(msg => {
      const role = msg.role === 'user' ? '👤 USER' : '🤖 BOT ';
      console.log(`${role}: ${msg.content.substring(0, 80)}${msg.content.length > 80 ? '...' : ''}`);
    });
  } else {
    console.log('Response:', JSON.stringify(messagesRes.data, null, 2));
  }
  console.log('\n🎉 TESTING SELESAI!');
}

runTests().catch(console.error);

