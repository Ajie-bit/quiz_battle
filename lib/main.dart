import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const QuizBattleApp());
}

class QuizBattleApp extends StatelessWidget {
  const QuizBattleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz Battle',
      home: const CategoryScreen(),
    );
  }
}

////////////////////////////////////////////////////////////
/// CATEGORY SCREEN
////////////////////////////////////////////////////////////

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {
        "title": "Bahasa Indonesia",
        "icon": Icons.menu_book,
        "questions": bahasaIndonesiaQuestions,
      },
      {
        "title": "Matematika",
        "icon": Icons.calculate,
        "questions": matematikaQuestions,
      },
      {
        "title": "Bahasa Inggris",
        "icon": Icons.language,
        "questions": bahasaInggrisQuestions,
      },
      {
        "title": "Pendidikan Pancasila",
        "icon": Icons.account_balance,
        "questions": pancasilaQuestions,
      },
      {
        "title": "Pendidikan Agama",
        "icon": Icons.mosque,
        "questions": agamaQuestions,
      },
      {
        "title": "Sejarah",
        "icon": Icons.history_edu,
        "questions": sejarahQuestions,
      },
      {
        "title": "PJOK",
        "icon": Icons.sports_soccer,
        "questions": pjokQuestions,
      },
      {
        "title": "Seni Budaya",
        "icon": Icons.palette,
        "questions": seniQuestions,
      },
      {
        "title": "Informatika",
        "icon": Icons.computer,
        "questions": informatikaQuestions,
      },
      {"title": "IPA", "icon": Icons.science, "questions": ipaQuestions},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFF6B4A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "Choose Lesson",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Select your lesson category",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.builder(
                  itemCount: categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (_, index) {
                    final category = categories[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizScreen(
                              questions: category["questions"],
                              categoryName: category["title"],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              category["icon"],
                              size: 50,
                              color: Colors.deepOrange,
                            ),
                            const SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                category["title"],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// QUIZ SCREEN
////////////////////////////////////////////////////////////

class QuizScreen extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final String categoryName;

  const QuizScreen({
    super.key,
    required this.questions,
    required this.categoryName,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final AudioPlayer player = AudioPlayer();

  int currentQuestion = 0;
  int score = 0;
  int seconds = 30;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        nextQuestion();
      }
    });
  }

  void resetTimer() {
    seconds = 30;
  }

  void checkAnswer(int index) async {
    if (index == widget.questions[currentQuestion]["answer"]) {
      score++;
      await player.play(AssetSource("sounds/correct.mp3"));
    } else {
      await player.play(AssetSource("sounds/wrong.mp3"));
    }

    nextQuestion();
  }

  void nextQuestion() {
    timer?.cancel();

    if (currentQuestion < widget.questions.length - 1) {
      setState(() {
        currentQuestion++;
        resetTimer();
      });

      startTimer();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ResultScreen(score: score, total: widget.questions.length),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = (currentQuestion + 1) / widget.questions.length;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.7),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.close, color: Colors.white),
                      Text(
                        widget.categoryName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${currentQuestion + 1}/${widget.questions.length}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation(Colors.amber),
                  ),
                  const SizedBox(height: 30),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          value: seconds / 30,
                          strokeWidth: 8,
                          backgroundColor: Colors.white12,
                          valueColor: const AlwaysStoppedAnimation(
                            Colors.orange,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$seconds",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "sec",
                            style: TextStyle(color: Colors.white54),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2D3E),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      widget.questions[currentQuestion]["question"],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: ListView.builder(
                      itemCount:
                          widget.questions[currentQuestion]["options"].length,
                      itemBuilder: (_, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2D3E),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            onTap: () {
                              checkAnswer(index);
                            },
                            leading: CircleAvatar(
                              backgroundColor: Colors.orange,
                              child: Text(
                                String.fromCharCode(65 + index),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              widget
                                  .questions[currentQuestion]["options"][index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// RESULT SCREEN
////////////////////////////////////////////////////////////

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;

  const ResultScreen({super.key, required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/trophy.png", height: 220),
              const SizedBox(height: 30),
              const Text(
                "QUIZ FINISHED",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "$score / $total",
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 55,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// QUESTIONS
////////////////////////////////////////////////////////////

List<Map<String, dynamic>> bahasaIndonesiaQuestions = [
  {
    "question": "Antonim panas adalah?",
    "options": ["Hangat", "Dingin", "Api", "Terik"],
    "answer": 1,
  },
  {
    "question": "Sinonim pintar adalah?",
    "options": ["Bodoh", "Rajin", "Cerdas", "Malas"],
    "answer": 2,
  },
  {
    "question": "Kalimat tanya diakhiri tanda?",
    "options": [".", "!", ",", "?"],
    "answer": 3,
  },
  {
    "question": "Pantun terdiri dari ... baris.",
    "options": ["2", "3", "4", "5"],
    "answer": 2,
  },
  {
    "question": "Lawan kata tinggi adalah?",
    "options": ["Pendek", "Kecil", "Rendah", "Tipis"],
    "answer": 2,
  },
  {
    "question": "Cerita khayalan disebut?",
    "options": ["Fiksi", "Fakta", "Berita", "Iklan"],
    "answer": 0,
  },
  {
    "question": "Huruf pertama kalimat memakai?",
    "options": ["Huruf kecil", "Huruf kapital", "Angka", "Simbol"],
    "answer": 1,
  },
  {
    "question": "Teks prosedur berisi?",
    "options": ["Cerita", "Langkah-langkah", "Puisi", "Pendapat"],
    "answer": 1,
  },
  {
    "question": "Puisi rakyat disebut?",
    "options": ["Novel", "Drama", "Pantun", "Cerpen"],
    "answer": 2,
  },
  {
    "question": "Lawan kata cepat adalah?",
    "options": ["Lambat", "Keras", "Rajin", "Dekat"],
    "answer": 0,
  },
  {
    "question": "Kata hubung disebut?",
    "options": ["Verba", "Konjungsi", "Nomina", "Adjektiva"],
    "answer": 1,
  },
  {
    "question": "Teks berita berisi?",
    "options": ["Fakta", "Khayalan", "Lelucon", "Pantun"],
    "answer": 0,
  },
  {
    "question": "Sinonim cantik adalah?",
    "options": ["Buruk", "Indah", "Kotor", "Jelek"],
    "answer": 1,
  },
  {
    "question": "Drama ditampilkan dalam bentuk?",
    "options": ["Lukisan", "Tarian", "Pertunjukan", "Patung"],
    "answer": 2,
  },
  {
    "question": "Kalimat perintah diakhiri tanda?",
    "options": [".", ",", "?", "!"],
    "answer": 3,
  },
  {
    "question": "Paragraf narasi berisi?",
    "options": ["Cerita", "Angka", "Rumus", "Data"],
    "answer": 0,
  },
  {
    "question": "Lawan kata siang adalah?",
    "options": ["Sore", "Pagi", "Malam", "Subuh"],
    "answer": 2,
  },
  {
    "question": "Ringkasan dibuat agar bacaan menjadi?",
    "options": ["Panjang", "Singkat", "Sulit", "Rumit"],
    "answer": 1,
  },
  {
    "question": "Membaca puisi harus dengan?",
    "options": ["Nada", "Irama", "Ekspresi", "Semua benar"],
    "answer": 3,
  },
  {
    "question": "Ide pokok adalah?",
    "options": ["Kalimat penjelas", "Inti paragraf", "Judul", "Gambar"],
    "answer": 1,
  },
];
List<Map<String, dynamic>> matematikaQuestions = [
  {
    "question": "5 + 7 = ?",
    "options": ["10", "11", "12", "13"],
    "answer": 2,
  },
  {
    "question": "9 x 3 = ?",
    "options": ["18", "21", "27", "30"],
    "answer": 2,
  },
  {
    "question": "20 - 8 = ?",
    "options": ["10", "11", "12", "13"],
    "answer": 2,
  },
  {
    "question": "36 : 6 = ?",
    "options": ["4", "5", "6", "7"],
    "answer": 2,
  },
  {
    "question": "Akar dari 49 adalah?",
    "options": ["5", "6", "7", "8"],
    "answer": 2,
  },
  {
    "question": "3² = ?",
    "options": ["6", "8", "9", "12"],
    "answer": 2,
  },
  {
    "question": "15 + 10 = ?",
    "options": ["20", "25", "30", "35"],
    "answer": 1,
  },
  {
    "question": "50 : 5 = ?",
    "options": ["5", "10", "15", "20"],
    "answer": 1,
  },
  {
    "question": "7 x 8 = ?",
    "options": ["54", "56", "58", "60"],
    "answer": 1,
  },
  {
    "question": "100 - 25 = ?",
    "options": ["70", "75", "80", "85"],
    "answer": 1,
  },
  {
    "question": "Keliling persegi rumusnya?",
    "options": ["s x s", "4 x sisi", "p x l", "2 x p"],
    "answer": 1,
  },
  {
    "question": "Luas persegi panjang?",
    "options": ["p x l", "s x s", "2 x p", "4 x s"],
    "answer": 0,
  },
  {
    "question": "12 x 12 = ?",
    "options": ["124", "134", "144", "154"],
    "answer": 2,
  },
  {
    "question": "90 : 10 = ?",
    "options": ["7", "8", "9", "10"],
    "answer": 2,
  },
  {
    "question": "25% dari 100 adalah?",
    "options": ["20", "25", "30", "50"],
    "answer": 1,
  },
  {
    "question": "Bilangan genap adalah?",
    "options": ["3", "5", "7", "8"],
    "answer": 3,
  },
  {
    "question": "Bilangan prima adalah?",
    "options": ["4", "6", "7", "8"],
    "answer": 2,
  },
  {
    "question": "2/4 sama dengan?",
    "options": ["1/2", "1/3", "2/3", "3/4"],
    "answer": 0,
  },
  {
    "question": "10 x 10 = ?",
    "options": ["50", "80", "100", "120"],
    "answer": 2,
  },
  {
    "question": "Sudut siku-siku besarnya?",
    "options": ["45°", "90°", "180°", "360°"],
    "answer": 1,
  },
];

List<Map<String, dynamic>> bahasaInggrisQuestions = [
  {
    "question": "Meaning of cat?",
    "options": ["Anjing", "Kucing", "Burung", "Ikan"],
    "answer": 1,
  },
  {
    "question": "Meaning of book?",
    "options": ["Meja", "Tas", "Buku", "Kursi"],
    "answer": 2,
  },
  {
    "question": "Opposite of big?",
    "options": ["Tall", "Small", "Wide", "Heavy"],
    "answer": 1,
  },
  {
    "question": "Meaning of apple?",
    "options": ["Jeruk", "Mangga", "Apel", "Anggur"],
    "answer": 2,
  },
  {
    "question": "Meaning of school?",
    "options": ["Rumah", "Sekolah", "Pasar", "Jalan"],
    "answer": 1,
  },
  {
    "question": "Meaning of red?",
    "options": ["Merah", "Biru", "Hijau", "Kuning"],
    "answer": 0,
  },
  {
    "question": "Meaning of water?",
    "options": ["Api", "Udara", "Air", "Tanah"],
    "answer": 2,
  },
  {
    "question": "Meaning of teacher?",
    "options": ["Guru", "Dokter", "Polisi", "Petani"],
    "answer": 0,
  },
  {
    "question": "Meaning of banana?",
    "options": ["Pisang", "Pepaya", "Semangka", "Melon"],
    "answer": 0,
  },
  {
    "question": "Meaning of chair?",
    "options": ["Pintu", "Jendela", "Kursi", "Lemari"],
    "answer": 2,
  },
  {
    "question": "Meaning of happy?",
    "options": ["Sedih", "Senang", "Marah", "Takut"],
    "answer": 1,
  },
  {
    "question": "Meaning of fish?",
    "options": ["Ayam", "Ikan", "Sapi", "Kambing"],
    "answer": 1,
  },
  {
    "question": "Opposite of hot?",
    "options": ["Cold", "Warm", "Dry", "Big"],
    "answer": 0,
  },
  {
    "question": "Meaning of mother?",
    "options": ["Ayah", "Kakak", "Ibu", "Adik"],
    "answer": 2,
  },
  {
    "question": "Meaning of car?",
    "options": ["Motor", "Mobil", "Sepeda", "Bus"],
    "answer": 1,
  },
  {
    "question": "Meaning of sun?",
    "options": ["Bulan", "Bintang", "Matahari", "Awan"],
    "answer": 2,
  },
  {
    "question": "Meaning of dog?",
    "options": ["Kucing", "Kelinci", "Anjing", "Burung"],
    "answer": 2,
  },
  {
    "question": "Meaning of table?",
    "options": ["Meja", "Kursi", "Papan", "Tas"],
    "answer": 0,
  },
  {
    "question": "Meaning of milk?",
    "options": ["Teh", "Kopi", "Susu", "Jus"],
    "answer": 2,
  },
  {
    "question": "Meaning of house?",
    "options": ["Sekolah", "Rumah", "Toko", "Kantor"],
    "answer": 1,
  },
];

List<Map<String, dynamic>> pancasilaQuestions = [
  {
    "question": "Sila pertama Pancasila adalah?",
    "options": [
      "Kemanusiaan",
      "Ketuhanan Yang Maha Esa",
      "Persatuan Indonesia",
      "Keadilan Sosial",
    ],
    "answer": 1,
  },
  {
    "question": "Lambang sila kedua adalah?",
    "options": ["Bintang", "Rantai", "Pohon", "Banteng"],
    "answer": 1,
  },
  {
    "question": "Warna bendera Indonesia adalah?",
    "options": ["Merah Putih", "Merah Biru", "Putih Hijau", "Kuning Merah"],
    "answer": 0,
  },
  {
    "question": "Presiden pertama Indonesia adalah?",
    "options": ["Soeharto", "Habibie", "Soekarno", "Jokowi"],
    "answer": 2,
  },
  {
    "question": "Dasar negara Indonesia adalah?",
    "options": ["UUD", "Pancasila", "Bendera", "Lagu"],
    "answer": 1,
  },
  {
    "question": "Semboyan negara Indonesia adalah?",
    "options": [
      "Tut Wuri Handayani",
      "Bhinneka Tunggal Ika",
      "Merdeka",
      "Garuda Pancasila",
    ],
    "answer": 1,
  },
  {
    "question": "Lambang negara Indonesia adalah?",
    "options": ["Harimau", "Garuda", "Elang", "Rajawali"],
    "answer": 1,
  },
  {
    "question": "Hari kemerdekaan Indonesia tanggal?",
    "options": ["1 Juni", "10 November", "17 Agustus", "28 Oktober"],
    "answer": 2,
  },
  {
    "question": "Contoh sikap gotong royong adalah?",
    "options": ["Bermain sendiri", "Belajar sendiri", "Kerja bakti", "Tidur"],
    "answer": 2,
  },
  {
    "question": "Musyawarah bertujuan untuk?",
    "options": ["Bertengkar", "Mencapai mufakat", "Bermain", "Marah"],
    "answer": 1,
  },
  {
    "question": "Lambang sila ketiga adalah?",
    "options": ["Pohon beringin", "Padi", "Bintang", "Rantai"],
    "answer": 0,
  },
  {
    "question": "Kita harus menghormati ...",
    "options": ["Teman saja", "Guru saja", "Semua orang", "Tetangga saja"],
    "answer": 2,
  },
  {
    "question": "Hak siswa di sekolah adalah?",
    "options": ["Belajar", "Membayar", "Membersihkan jalan", "Tidur"],
    "answer": 0,
  },
  {
    "question": "Kewajiban siswa adalah?",
    "options": ["Belajar", "Bermain terus", "Membolos", "Tidur"],
    "answer": 0,
  },
  {
    "question": "Contoh hidup rukun adalah?",
    "options": ["Bertengkar", "Saling membantu", "Mengejek", "Marah"],
    "answer": 1,
  },
  {
    "question": "Indonesia memiliki banyak ...",
    "options": ["Bahasa dan budaya", "Gunung saja", "Laut saja", "Pulau kecil"],
    "answer": 0,
  },
  {
    "question": "Kita harus cinta kepada ...",
    "options": ["Negara", "Mainan", "Game", "Uang"],
    "answer": 0,
  },
  {
    "question": "Contoh sikap disiplin adalah?",
    "options": [
      "Datang terlambat",
      "Mematuhi aturan",
      "Bolos sekolah",
      "Tidur di kelas",
    ],
    "answer": 1,
  },
  {
    "question": "Lambang sila kelima adalah?",
    "options": ["Padi dan kapas", "Bintang", "Rantai", "Banteng"],
    "answer": 0,
  },
  {
    "question": "Garuda Pancasila adalah?",
    "options": ["Lagu daerah", "Lambang negara", "Nama pulau", "Nama kota"],
    "answer": 1,
  },
];

List<Map<String, dynamic>> agamaQuestions = [
  {
    "question": "Kitab suci umat Islam adalah?",
    "options": ["Injil", "Taurat", "Al-Quran", "Weda"],
    "answer": 2,
  },
  {
    "question": "Jumlah rukun Islam ada?",
    "options": ["3", "4", "5", "6"],
    "answer": 2,
  },
  {
    "question": "Nabi terakhir adalah?",
    "options": ["Nabi Musa", "Nabi Ibrahim", "Nabi Muhammad", "Nabi Isa"],
    "answer": 2,
  },
  {
    "question": "Puasa wajib dilakukan pada bulan?",
    "options": ["Rajab", "Syawal", "Ramadan", "Muharram"],
    "answer": 2,
  },
  {
    "question": "Salat Subuh berjumlah ... rakaat.",
    "options": ["2", "3", "4", "5"],
    "answer": 0,
  },
  {
    "question": "Allah Maha Pengasih disebut?",
    "options": ["Ar-Rahman", "Al-Malik", "Al-Azim", "As-Salam"],
    "answer": 0,
  },
  {
    "question": "Tempat ibadah umat Islam adalah?",
    "options": ["Gereja", "Pura", "Masjid", "Vihara"],
    "answer": 2,
  },
  {
    "question": "Zakat termasuk rukun Islam ke?",
    "options": ["1", "2", "3", "4"],
    "answer": 3,
  },
  {
    "question": "Hari raya umat Islam adalah?",
    "options": ["Natal", "Nyepi", "Idul Fitri", "Waisak"],
    "answer": 2,
  },
  {
    "question": "Malaikat yang menyampaikan wahyu adalah?",
    "options": ["Mikail", "Israfil", "Jibril", "Izrail"],
    "answer": 2,
  },
  {
    "question": "Sebelum salat kita harus?",
    "options": ["Makan", "Wudhu", "Tidur", "Bermain"],
    "answer": 1,
  },
  {
    "question": "Orang yang berpuasa harus menahan?",
    "options": ["Makan dan minum", "Tidur", "Belajar", "Olahraga"],
    "answer": 0,
  },
  {
    "question": "Salat wajib dilakukan ... kali sehari.",
    "options": ["3", "4", "5", "6"],
    "answer": 2,
  },
  {
    "question": "Rukun Islam pertama adalah?",
    "options": ["Puasa", "Salat", "Syahadat", "Zakat"],
    "answer": 2,
  },
  {
    "question": "Perilaku baik disebut?",
    "options": ["Akhlak", "Dosa", "Marah", "Fitnah"],
    "answer": 0,
  },
  {
    "question": "Kita harus hormat kepada?",
    "options": ["Teman saja", "Orang tua", "Tetangga saja", "Guru saja"],
    "answer": 1,
  },
  {
    "question": "Al-Quran diturunkan kepada Nabi?",
    "options": ["Isa", "Muhammad", "Musa", "Ibrahim"],
    "answer": 1,
  },
  {
    "question": "Orang yang berkata jujur akan?",
    "options": ["Dibenci", "Disukai", "Dimarahi", "Dijauhi"],
    "answer": 1,
  },
  {
    "question": "Membaca doa dilakukan sebelum?",
    "options": ["Belajar", "Tidur", "Makan", "Semua benar"],
    "answer": 3,
  },
  {
    "question": "Islam mengajarkan hidup saling?",
    "options": ["Bermusuhan", "Menghina", "Menghormati", "Bertengkar"],
    "answer": 2,
  },
];

List<Map<String, dynamic>> sejarahQuestions = [
  {
    "question": "Indonesia merdeka tahun?",
    "options": ["1942", "1945", "1950", "1965"],
    "answer": 1,
  },
  {
    "question": "Proklamator Indonesia adalah?",
    "options": [
      "Soeharto dan Habibie",
      "Soekarno dan Hatta",
      "Jokowi dan SBY",
      "Diponegoro dan Pattimura",
    ],
    "answer": 1,
  },
  {
    "question": "Hari kemerdekaan Indonesia tanggal?",
    "options": ["1 Juni", "10 November", "17 Agustus", "28 Oktober"],
    "answer": 2,
  },
  {
    "question": "Presiden pertama Indonesia adalah?",
    "options": ["Habibie", "Jokowi", "Soekarno", "Soeharto"],
    "answer": 2,
  },
  {
    "question": "Wakil presiden pertama Indonesia adalah?",
    "options": ["Soeharto", "Mohammad Hatta", "Habibie", "Jokowi"],
    "answer": 1,
  },
  {
    "question": "Penjajah Indonesia paling lama adalah?",
    "options": ["Jepang", "Belanda", "Inggris", "Portugis"],
    "answer": 1,
  },
  {
    "question": "Hari Pahlawan diperingati setiap?",
    "options": ["1 Juni", "17 Agustus", "10 November", "28 Oktober"],
    "answer": 2,
  },
  {
    "question": "Sumpah Pemuda terjadi tahun?",
    "options": ["1908", "1928", "1945", "1965"],
    "answer": 1,
  },
  {
    "question": "Tokoh emansipasi wanita adalah?",
    "options": [
      "Cut Nyak Dien",
      "RA Kartini",
      "Dewi Sartika",
      "Martha Christina",
    ],
    "answer": 1,
  },
  {
    "question": "Pahlawan dari Jawa Tengah adalah?",
    "options": [
      "Pangeran Diponegoro",
      "Pattimura",
      "Imam Bonjol",
      "Hasanuddin",
    ],
    "answer": 0,
  },
  {
    "question": "VOC berasal dari negara?",
    "options": ["Jepang", "Belanda", "Inggris", "Portugis"],
    "answer": 1,
  },
  {
    "question": "Jepang menjajah Indonesia selama?",
    "options": ["1 tahun", "2 tahun", "3,5 tahun", "10 tahun"],
    "answer": 2,
  },
  {
    "question": "Teks proklamasi dibacakan di kota?",
    "options": ["Bandung", "Surabaya", "Jakarta", "Yogyakarta"],
    "answer": 2,
  },
  {
    "question": "Bendera Indonesia berwarna?",
    "options": ["Merah Putih", "Merah Biru", "Putih Hijau", "Kuning Merah"],
    "answer": 0,
  },
  {
    "question": "Lagu kebangsaan Indonesia adalah?",
    "options": [
      "Garuda Pancasila",
      "Indonesia Raya",
      "Hari Merdeka",
      "Bagimu Negeri",
    ],
    "answer": 1,
  },
  {
    "question": "RA Kartini lahir di?",
    "options": ["Jepara", "Bandung", "Jakarta", "Surabaya"],
    "answer": 0,
  },
  {
    "question": "Sumpah Pemuda bertujuan untuk?",
    "options": ["Bermain", "Persatuan pemuda", "Berdagang", "Perang"],
    "answer": 1,
  },
  {
    "question": "Pattimura berasal dari?",
    "options": ["Aceh", "Maluku", "Papua", "Bali"],
    "answer": 1,
  },
  {
    "question": "Hari lahir Pancasila diperingati tanggal?",
    "options": ["1 Juni", "17 Agustus", "10 November", "28 Oktober"],
    "answer": 0,
  },
  {
    "question": "Indonesia pernah dijajah Jepang dan?",
    "options": ["India", "Belanda", "Thailand", "China"],
    "answer": 1,
  },
];

List<Map<String, dynamic>> pjokQuestions = [
  {
    "question": "Olahraga menggunakan bola disebut?",
    "options": ["Renang", "Atletik", "Permainan bola", "Senam"],
    "answer": 2,
  },
  {
    "question": "Jumlah pemain sepak bola adalah?",
    "options": ["5", "7", "9", "11"],
    "answer": 3,
  },
  {
    "question": "Olahraga menggunakan raket adalah?",
    "options": ["Basket", "Badminton", "Renang", "Lari"],
    "answer": 1,
  },
  {
    "question": "Sebelum olahraga harus?",
    "options": ["Tidur", "Makan banyak", "Pemanasan", "Duduk"],
    "answer": 2,
  },
  {
    "question": "Tujuan pemanasan adalah?",
    "options": ["Cepat lelah", "Menghindari cedera", "Mengantuk", "Haus"],
    "answer": 1,
  },
  {
    "question": "Olahraga di air disebut?",
    "options": ["Lari", "Basket", "Renang", "Senam"],
    "answer": 2,
  },
  {
    "question": "Alat untuk badminton adalah?",
    "options": ["Tongkat", "Raket", "Bola", "Helm"],
    "answer": 1,
  },
  {
    "question": "Sepak bola dimainkan dengan?",
    "options": ["Tangan", "Kaki", "Kepala saja", "Tongkat"],
    "answer": 1,
  },
  {
    "question": "Jumlah pemain basket tiap tim adalah?",
    "options": ["5", "6", "7", "11"],
    "answer": 0,
  },
  {
    "question": "Lari termasuk olahraga?",
    "options": ["Atletik", "Air", "Bola", "Bela diri"],
    "answer": 0,
  },
  {
    "question": "Olahraga membuat tubuh menjadi?",
    "options": ["Lemah", "Sehat", "Sakit", "Mengantuk"],
    "answer": 1,
  },
  {
    "question": "Pendinginan dilakukan setelah?",
    "options": ["Tidur", "Olahraga", "Makan", "Belajar"],
    "answer": 1,
  },
  {
    "question": "Bola voli dimainkan dengan?",
    "options": ["Kaki", "Tangan", "Kepala", "Tongkat"],
    "answer": 1,
  },
  {
    "question": "Renang melatih kekuatan?",
    "options": ["Tubuh", "Mata", "Rambut", "Kuku"],
    "answer": 0,
  },
  {
    "question": "Gerakan senam membuat tubuh?",
    "options": ["Kaku", "Lentur", "Pendek", "Lemah"],
    "answer": 1,
  },
  {
    "question": "Olahraga tradisional adalah?",
    "options": ["Gobak sodor", "Basket", "Futsal", "Renang"],
    "answer": 0,
  },
  {
    "question": "Minum air saat olahraga agar?",
    "options": ["Haus", "Tubuh tetap segar", "Lelah", "Mengantuk"],
    "answer": 1,
  },
  {
    "question": "Sportivitas berarti?",
    "options": ["Curang", "Jujur saat bermain", "Marah", "Menang sendiri"],
    "answer": 1,
  },
  {
    "question": "Sepatu olahraga digunakan agar?",
    "options": ["Licin", "Nyaman bergerak", "Cepat rusak", "Berat"],
    "answer": 1,
  },
  {
    "question": "Olahraga rutin membuat tubuh?",
    "options": ["Sakit", "Lemah", "Sehat", "Pendek"],
    "answer": 2,
  },
];

List<Map<String, dynamic>> seniQuestions = [
  {
    "question": "Alat musik dari Jawa Barat adalah?",
    "options": ["Angklung", "Sasando", "Tifa", "Kolintang"],
    "answer": 0,
  },
  {
    "question": "Warna primer adalah?",
    "options": [
      "Merah, kuning, biru",
      "Hijau, hitam, putih",
      "Ungu, pink, abu",
      "Coklat, emas, silver",
    ],
    "answer": 0,
  },
  {
    "question": "Seni tari menggunakan?",
    "options": ["Gerakan tubuh", "Cat", "Kayu", "Bola"],
    "answer": 0,
  },
  {
    "question": "Alat musik dipukul disebut?",
    "options": ["Ritmis", "Melodis", "Modern", "Tradisional"],
    "answer": 0,
  },
  {
    "question": "Tari Saman berasal dari?",
    "options": ["Aceh", "Bali", "Papua", "Jawa"],
    "answer": 0,
  },
  {
    "question": "Menggambar termasuk seni?",
    "options": ["Musik", "Rupa", "Tari", "Teater"],
    "answer": 1,
  },
  {
    "question": "Alat musik petik adalah?",
    "options": ["Drum", "Gitar", "Piano", "Seruling"],
    "answer": 1,
  },
  {
    "question": "Kolase dibuat dengan cara?",
    "options": ["Menempel", "Memukul", "Menari", "Melukis"],
    "answer": 0,
  },
  {
    "question": "Lagu Indonesia Raya diciptakan oleh?",
    "options": ["WR Supratman", "Ismail Marzuki", "Ibu Sud", "AT Mahmud"],
    "answer": 0,
  },
  {
    "question": "Seni teater adalah seni?",
    "options": ["Lukis", "Peran", "Musik", "Patung"],
    "answer": 1,
  },
  {
    "question": "Patung dibuat dari?",
    "options": ["Tanah liat", "Air", "Kertas saja", "Kain"],
    "answer": 0,
  },
  {
    "question": "Alat musik tiup adalah?",
    "options": ["Drum", "Seruling", "Gitar", "Piano"],
    "answer": 1,
  },
  {
    "question": "Menari dilakukan mengikuti?",
    "options": ["Irama", "Cuaca", "Warna", "Angka"],
    "answer": 0,
  },
  {
    "question": "Wayang termasuk seni?",
    "options": ["Teater", "Olahraga", "IPA", "Matematika"],
    "answer": 0,
  },
  {
    "question": "Tifa berasal dari daerah?",
    "options": ["Papua", "Aceh", "Bali", "Jawa"],
    "answer": 0,
  },
  {
    "question": "Lagu anak-anak biasanya bertema?",
    "options": ["Keceriaan", "Perang", "Politik", "Bisnis"],
    "answer": 0,
  },
  {
    "question": "Seni budaya harus?",
    "options": ["Dilupakan", "Dilestarikan", "Dibuang", "Dihapus"],
    "answer": 1,
  },
  {
    "question": "Batik adalah karya seni?",
    "options": ["Musik", "Rupa", "Tari", "Drama"],
    "answer": 1,
  },
  {
    "question": "Piano dimainkan dengan?",
    "options": ["Dipukul", "Ditiup", "Ditekan", "Digesek"],
    "answer": 2,
  },
  {
    "question": "Seni musik adalah seni?",
    "options": ["Suara", "Gambar", "Gerak", "Tulisan"],
    "answer": 0,
  },
];
List<Map<String, dynamic>> informatikaQuestions = [
  {
    "question": "Otak komputer disebut?",
    "options": ["RAM", "CPU", "Mouse", "Monitor"],
    "answer": 1,
  },
  {
    "question": "Alat untuk mengetik adalah?",
    "options": ["Keyboard", "Printer", "Speaker", "Scanner"],
    "answer": 0,
  },
  {
    "question": "Perangkat output adalah?",
    "options": ["Mouse", "Keyboard", "Monitor", "CPU"],
    "answer": 2,
  },
  {
    "question": "Alat untuk menggerakkan kursor adalah?",
    "options": ["Mouse", "Printer", "Speaker", "Flashdisk"],
    "answer": 0,
  },
  {
    "question": "Komputer digunakan untuk?",
    "options": ["Memasak", "Mengolah data", "Mencuci", "Berkebun"],
    "answer": 1,
  },
  {
    "question": "Contoh browser internet adalah?",
    "options": ["Chrome", "Word", "Excel", "Paint"],
    "answer": 0,
  },
  {
    "question": "Internet digunakan untuk?",
    "options": ["Berkomunikasi", "Tidur", "Makan", "Bermain bola"],
    "answer": 0,
  },
  {
    "question": "Perangkat untuk mencetak adalah?",
    "options": ["Printer", "Mouse", "Keyboard", "Scanner"],
    "answer": 0,
  },
  {
    "question": "File disimpan di?",
    "options": ["Monitor", "Storage", "Mouse", "Speaker"],
    "answer": 1,
  },
  {
    "question": "CPU singkatan dari?",
    "options": [
      "Central Processing Unit",
      "Computer Process Unit",
      "Central Program Unit",
      "Control Program User",
    ],
    "answer": 0,
  },
  {
    "question": "Media sosial adalah?",
    "options": ["Instagram", "Word", "Excel", "Paint"],
    "answer": 0,
  },
  {
    "question": "Password digunakan untuk?",
    "options": [
      "Keamanan akun",
      "Bermain game",
      "Menonton TV",
      "Mendengarkan musik",
    ],
    "answer": 0,
  },
  {
    "question": "Monitor berfungsi untuk?",
    "options": ["Menampilkan gambar", "Mengetik", "Mencetak", "Menyimpan data"],
    "answer": 0,
  },
  {
    "question": "Laptop termasuk perangkat?",
    "options": ["Elektronik", "Olahraga", "Musik", "Dapur"],
    "answer": 0,
  },
  {
    "question": "Contoh perangkat input adalah?",
    "options": ["Keyboard", "Monitor", "Speaker", "Printer"],
    "answer": 0,
  },
  {
    "question": "Aplikasi untuk mengetik adalah?",
    "options": ["Word", "Paint", "Chrome", "YouTube"],
    "answer": 0,
  },
  {
    "question": "Cloud storage digunakan untuk?",
    "options": ["Menyimpan data", "Mencuci pakaian", "Memasak", "Olahraga"],
    "answer": 0,
  },
  {
    "question": "Coding adalah kegiatan?",
    "options": ["Memasak", "Menulis program", "Menggambar", "Menyanyi"],
    "answer": 1,
  },
  {
    "question": "Contoh bahasa pemrograman adalah?",
    "options": ["Dart", "Basket", "HTML meja", "Sepeda"],
    "answer": 0,
  },
  {
    "question": "Kita harus menjaga etika saat?",
    "options": ["Menggunakan internet", "Tidur", "Olahraga", "Makan"],
    "answer": 0,
  },
];

List<Map<String, dynamic>> ipaQuestions = [
  {
    "question": "Planet terbesar adalah?",
    "options": ["Mars", "Jupiter", "Venus", "Bumi"],
    "answer": 1,
  },
  {
    "question": "Manusia bernapas dengan?",
    "options": ["Jantung", "Paru-paru", "Hati", "Ginjal"],
    "answer": 1,
  },
  {
    "question": "Tumbuhan membuat makanan melalui?",
    "options": ["Respirasi", "Fotosintesis", "Evaporasi", "Adaptasi"],
    "answer": 1,
  },
  {
    "question": "Air yang dipanaskan akan?",
    "options": ["Membeku", "Menguap", "Mengeras", "Mengendap"],
    "answer": 1,
  },
  {
    "question": "Sumber energi terbesar di bumi adalah?",
    "options": ["Bulan", "Api", "Matahari", "Air"],
    "answer": 2,
  },
  {
    "question": "Hewan pemakan tumbuhan disebut?",
    "options": ["Karnivora", "Herbivora", "Omnivora", "Mamalia"],
    "answer": 1,
  },
  {
    "question": "Organ untuk memompa darah adalah?",
    "options": ["Paru-paru", "Jantung", "Hati", "Lambung"],
    "answer": 1,
  },
  {
    "question": "Benda cair mengikuti bentuk?",
    "options": ["Udara", "Wadah", "Tanah", "Api"],
    "answer": 1,
  },
  {
    "question": "Contoh hewan mamalia adalah?",
    "options": ["Ayam", "Ikan", "Kucing", "Katak"],
    "answer": 2,
  },
  {
    "question": "Pelangi muncul setelah?",
    "options": ["Gempa", "Hujan", "Angin", "Kabut"],
    "answer": 1,
  },
  {
    "question": "Akar tumbuhan berfungsi untuk?",
    "options": ["Bernapas", "Menyerap air", "Melihat", "Berjalan"],
    "answer": 1,
  },
  {
    "question": "Benda padat memiliki bentuk?",
    "options": ["Tetap", "Berubah", "Cair", "Gas"],
    "answer": 0,
  },
  {
    "question": "Planet tempat kita tinggal adalah?",
    "options": ["Mars", "Venus", "Bumi", "Saturnus"],
    "answer": 2,
  },
  {
    "question": "Contoh sumber energi terbarukan adalah?",
    "options": ["Batu bara", "Minyak bumi", "Matahari", "Gas alam"],
    "answer": 2,
  },
  {
    "question": "Gigi digunakan untuk?",
    "options": ["Melihat", "Mengunyah makanan", "Mendengar", "Bernapas"],
    "answer": 1,
  },
  {
    "question": "Perubahan air menjadi es disebut?",
    "options": ["Menguap", "Mencair", "Membeku", "Mengembun"],
    "answer": 2,
  },
  {
    "question": "Bintang pusat tata surya adalah?",
    "options": ["Bulan", "Mars", "Matahari", "Venus"],
    "answer": 2,
  },
  {
    "question": "Manusia membutuhkan air untuk?",
    "options": ["Minum", "Bernapas", "Tidur", "Bermain"],
    "answer": 0,
  },
  {
    "question": "Hewan yang hidup di air adalah?",
    "options": ["Kucing", "Burung", "Ikan", "Ayam"],
    "answer": 2,
  },
  {
    "question": "Lingkungan harus dijaga agar?",
    "options": ["Kotor", "Sehat dan bersih", "Rusak", "Panas"],
    "answer": 1,
  },
];
