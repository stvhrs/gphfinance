import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DownloadService {
 String _convertToDirectDownloadLink(String url) {
    // Handle Google Drive links
    if (url.contains('drive.google.com')) {
      final RegExp regex = RegExp(r'/file/d/([a-zA-Z0-9_-]+)');
      final match = regex.firstMatch(url);
      
      if (match != null) {
        final fileId = match.group(1);
        return 'https://drive.google.com/uc?export=download&id=$fileId';
      }
    }
    return url;
  }

  // Fungsi yang dimodifikasi untuk mengarahkan pengguna ke URL unduhan
  Future<void> downloadFile(String url, String fileName) async {
    try {
      final directUrl = _convertToDirectDownloadLink(url);
      
      // Menggunakan window.open untuk mengarahkan browser
      // ke URL unduhan langsung. Ini bypass CORS.
      html.window.open(directUrl, '_blank');
      
      print("Membuka tautan unduhan untuk: $fileName");
      
    } catch (e) {
      print("Gagal membuka tautan unduhan untuk $fileName: $e");
    }
  }


  // Function to iterate through the JSON data and download imgUrl and pdfUrl
  Future<void> downloadAll() async {
    final booksData = 
  {"-OVRyefrseWgmkqz4mJn": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Bahasa-Indonesia-BS-KLS-VII-Cover.png",
      "kelas": "kelas_7",
      "pdfUrl": "https://drive.google.com/file/d/1lHN-EB6tLzkHFTRcyuvSpZ_m_DjF9O_b/view?usp=sharing",
      "title": "B. INDO KELAS VII SMP/MTS"
    },
    "-OVRyey1aoTValU95cHF": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Bahasa-Inggris-BS-KLS-VII-cover.png",
      "kelas": "kelas_7",
      "pdfUrl": "https://drive.google.com/file/d/1Vlbcv4qsOi09qtmHhyEeZNUwJ3c7sXhi/view?usp=sharing",
      "title": "B. INGGRIS KELAS VII SMP/MTS"
    },
    "-OVRyezWrfMZNye2tbK5": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Informatika-BS-KLS-VII-Cover.png",
      "kelas": "kelas_7",
      "pdfUrl": "https://drive.google.com/file/d/1bE-a761_Q5UTgACJWyNFy0J5o8BBxxne/view?usp=sharing",
      "title": "INFORMATIKA KELAS VII SMP/MTS"
    },
    "-OVRyf-f1taPZ-HQJ1fw": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/IPA-BS-KLS-VII-Cover.png",
      "kelas": "kelas_7",
      "pdfUrl": "https://drive.google.com/file/d/1eVJQaWkbui2_v8eNs6RkJk17c-fZPaIy/view?usp=sharing",
      "title": "IPA KELAS VII SMP/MTS"
    },
    "-OVRyf0jPo0unkFTa2w5": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/IPS-BS-KLS-VII-Cover.png",
      "kelas": "kelas_7",
      "pdfUrl": "https://drive.google.com/file/d/1ecA5jcbyYRnBKlQ3-TwfAFZEcLWtVh9a/view?usp=sharing",
      "title": "IPS KELAS VII SMP/MTS"
    },
    "-OVRyf1sw6sgDuWoWSSy": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Kepercayaan-BS-KLS-VII-Cover.png",
      "kelas": "kelas_7",
      "pdfUrl": "https://drive.google.com/file/d/1aC71YzzJzec7GIKFdRwAkUM5bQX8NXQJ/view?usp=sharing",
      "title": "KEPERCAYAAN TUHAN YME KELAS VII SMP/MTS"
    },
    "-OVRyf3BlKHw0tTDu6tP": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Matematika-BS-KLS-VII-cover.png",
      "kelas": "kelas_7",
      "pdfUrl": "https://drive.google.com/file/d/1zui2cWMoZHTa4oB0PBLgJIJs7H1vDjpv/view?usp=sharing",
      "title": "MATEMATIKA KELAS VII SMP/MTS"
    },
    "-OVRyf4Qeb72O69E75S-": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Matematika-BS-KLS-VII-Cover.png",
      "kelas": "kelas_7",
      "pdfUrl": "https://drive.google.com/file/d/19_M9uVkXN2krfBq7c3iggyGdei_3UjPC/view?usp=sharing",
      "title": "MATEMATIKA LISENSI KELAS VII SMP/MTS"
    },
    "-OVRyf5p-bL62Fb8DaJY": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Islam-BS-KLS-VII-Cover.png",
      "kelas": "kelas_7",
      "pdfUrl": "https://drive.google.com/file/d/1CbidsUQTat5z4JN0mUDSeuzQovAUaCbj/view?usp=sharing",
      "title": "PAI KELAS VII SMP/MTS"
    },
    "-OVRyf6zfAdzB6c0dODc": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Pendidikan-Pancasila-BS-KLS-VII-Cover.png",
      "kelas": "kelas_7",
      "pdfUrl": "https://drive.google.com/file/d/1GXggaxRKJK9LM4VlNqWC2Qk7pAzVMYbm/view?usp=sharing",
      "title": "PP KELAS VII SMP/MTS"
    },
    "-OVRyf8DKHERBsTo7Hvl": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_7",
      "pdfUrl": "https://drive.google.com/file/d/1UyuDqY53DKGwe4cga1zN2MKTM_Z64WR_/view?usp=sharing ",
      "title": "AL-QURAN & HADIS VII KMA-MTS"
    },
    "-OVRyf9WOqikaisRwwer": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_7",
      "pdfUrl": "https://drive.google.com/file/d/1UaZuc8JH3sRZScl8Zd2_WDmMoVHW2GY3/view?usp=sharing",
      "title": "AKIDAH & AKHLAK VII KMA-MTS"
    },
    "-OVRyfAnKRB5np8qXb79": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_7",
      "pdfUrl": "https://drive.google.com/file/d/1DNMIKNbrb9FwKHJx5PPRdqYGICFDbdcA/view?usp=sharing",
      "title": "FIKIH VII KMA-MTS"
    },
    "-OVRyfC05cJL5YRbRMJ_": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_7",
      "pdfUrl": "https://drive.google.com/file/d/1kdCnknfne-xFe7IoK_kLooQXM64btUd9/view?usp=sharing",
      "title": "BAHASA ARAB VII KMA-MTS"
    },
    "-OVRyfD9aqyXmryQ4iUV": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_7",
      "pdfUrl": "https://drive.google.com/file/d/1oUGDQLxA99pKKsYkWkZjil38b-K2XLrF/view?usp=sharing",
      "title": "SKI VII KMA-MTS"
    },
    "-OVRyfESIkqDH9lLJcEy": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_7",
      "pdfUrl": "https://drive.google.com/file/d/1UyuDqY53DKGwe4cga1zN2MKTM_Z64WR_/view?usp=sharing ",
      "title": "AL-QURAN & HADIS VII KMA-MTS"
    },
    "-OVRyfFf9OhckDdBZ3-P": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_7",
      "pdfUrl": "https://drive.google.com/file/d/1UaZuc8JH3sRZScl8Zd2_WDmMoVHW2GY3/view?usp=sharing",
      "title": "AKIDAH & AKHLAK VII KMA-MTS"
    },
    "-OVRyfGrDct-f28sV2Ls": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_7",
      "pdfUrl": "https://drive.google.com/file/d/1DNMIKNbrb9FwKHJx5PPRdqYGICFDbdcA/view?usp=sharing",
      "title": "FIKIH VII KMA-MTS"
    },
    "-OVRyfIA3k9NhN_TR2Ey": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_7",
      "pdfUrl": "https://drive.google.com/file/d/1kdCnknfne-xFe7IoK_kLooQXM64btUd9/view?usp=sharing",
      "title": "BAHASA ARAB VII KMA-MTS"
    },
    "-OVRyfJjPF4xKPE4O3oy": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_7",
      "pdfUrl": "https://drive.google.com/file/d/1oUGDQLxA99pKKsYkWkZjil38b-K2XLrF/view?usp=sharing",
      "title": "SKI VII KMA-MTS"
    },
    "-OVRyfL-EkYUaVvdaaX3": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Kristen-BS-KLS-VII-Cover.png",
      "kelas": "kelas_7",
      "pdfUrl": "https://drive.google.com/file/d/1l-IRvVvEn78gPKEl5LsEas6Bb2ONdPF7/view?usp=sharing",
      "title": "AGAMA KRISTEN KELAS VII SMP"
    },
    "-OVRyfMOEjCaNq1wIq3m": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Katolik-BS-KLS-VII-Cover.png",
      "kelas": "kelas_7",
      "pdfUrl": "https://drive.google.com/file/d/1R7QKlqaCxlpvoOgd0Qi0pzojLUlc-uri/view?usp=sharing",
      "title": "AGAMA KATOLIK KELAS VII SMP"
    },
    "-OVRyfNgzxbEPiHnIwl8": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Hindu-BS-KLS-VII-Cover.png",
      "kelas": "kelas_7",
      "pdfUrl": "https://drive.google.com/file/d/1cluDz8trb6L7-ue4UtUKXC57IgcA0g4X/view?usp=sharing",
      "title": "AGAMA HINDU KELAS VII SMP"
    },
    "-OVRyfOxiMHxauhhKHm3": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Buddha-BS-KLS-VII-Cover.png",
      "kelas": "kelas_7",
      "pdfUrl": "https://drive.google.com/file/d/1K2GHjHut8O3_z8DAPvu25AnvRsL80ViI/view?usp=sharing",
      "title": "AGAMA BUDDHA KELAS VII SMP"
    },
    "-OVRyfQANMtWpBkT-OCZ": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Khonghucu-BS-KLS-VII-Cover.png",
      "kelas": "kelas_7",
      "pdfUrl": "https://drive.google.com/file/d/1GepvGdXWKbISaLvEU-wLCUWYav76OMDG/view?usp=sharing",
      "title": "AGAMA KHONGHUCU KELAS VII SMP"
    },
    "-OVRyvyfPjd48kkCWVgr": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Bahasa-Indonesia-BS-KLS-VI-Cover.png",
      "kelas": "kelas_6",
      "pdfUrl": "https://drive.google.com/file/d/17RLU7FHlzpL4AZoq5dqyXtbhx5nryD9L/view?usp=sharing",
      "title": "B. INDO KELAS VI SD/MI"
    },
    "-OVRywOHtc658p_mtA4L": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Inggris_BS_KLS_VI_Lc_Cover.png",
      "kelas": "kelas_6",
      "pdfUrl": "https://drive.google.com/file/d/1kovHH5kECFZPD4uXkAbX5Fpu2o3Q-g7l/view?usp=sharing",
      "title": "B. INGGRIS KELAS VI SD/MI"
    },
    "-OVRywPb5e8-vxO24j7H": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/IPAS-BS-KLS-VI-Cover.png",
      "kelas": "kelas_6",
      "pdfUrl": "https://drive.google.com/file/d/1am2y9ctbKQ9EnHpUSqN3IyNmeqkEH4Hw/view?usp=sharing",
      "title": "IPAS KELAS VI SD/MI"
    },
    "-OVRywR44-dpK0MQxIt7": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Kepercayaan-BS-KLS-VI-Cover.png",
      "kelas": "kelas_6",
      "pdfUrl": "https://drive.google.com/file/d/1jfwBld3XIz9r6ljQYrxekn-74UXkiNf0/view?usp=sharing",
      "title": "KEPERCAYAAN TUHAN YME KELAS VI SD/MI"
    },
    "-OVRywSYNa3K3b_CGrDK": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Matematika_BS_KLS_VI_Cover.png",
      "kelas": "kelas_6",
      "pdfUrl": "https://drive.google.com/file/d/1yaDUIypw-ezicKgWv4lcYwCac12pSTUD/view?usp=sharing",
      "title": "MATEMATIKA KELAS VI SD/MI"
    },
    "-OVRywUZOyJ4kbRjYJFT": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Matematika_BS_KLS_VI_Vol_1_Lc_Cover.png",
      "kelas": "kelas_6",
      "pdfUrl": "https://drive.google.com/file/d/1bvMLSlbCVYSWH2grlkZL5wsFlk5fseCK/view?usp=sharing",
      "title": "MATEMATIKA VOL 1 KELAS VI SD/MI"
    },
    "-OVRywVu_SqnxlxwI06O": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Matematika_BS_KLS_VI_Vol_2_Lc_Cover.png",
      "kelas": "kelas_6",
      "pdfUrl": "https://drive.google.com/file/d/1N6JY4jeQTdE25pft_F6OyB0bw_ETDu5U/view?usp=sharing",
      "title": "MATEMATIKA VOL 2 KELAS VI SD/MI"
    },
    "-OVRywXBNm7N2YY95N7T": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Islam_BS_KLS_VI_Cover.png",
      "kelas": "kelas_6",
      "pdfUrl": "https://drive.google.com/file/d/1OH7F5571Em06AJ0P9FIiEHW7jcUDhJUt/view?usp=sharing",
      "title": "PAI KELAS VI SD/MI"
    },
    "-OVRywYcFeGjuH8FjbSM": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Pendidikan-Pancasila-BS-KLS-VI-Cover.png",
      "kelas": "kelas_6",
      "pdfUrl": "https://drive.google.com/file/d/1BTS3s-kwhnlgE7AXyGrxgfowTxRdLn9c/view?usp=sharing",
      "title": "PP KELAS VI SD/MI"
    },
    "-OVRyw_CVlv-IhSngMxS": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_6",
      "pdfUrl": "https://drive.google.com/file/d/1RBvt4DOs8M56EiGTGm4tcVw389Q5NpkG/view?usp=sharing",
      "title": "AL-QURAN & HADIS VI KMA-MI"
    },
    "-OVRywaa2ueWwZo2jgAb": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_6",
      "pdfUrl": "https://drive.google.com/file/d/1JsgVSjbJi7lp8QIYaXDzMbg2NgujdWsC/view?usp=sharing",
      "title": "AKIDAH & AKHLAK VI KMA-MI"
    },
    "-OVRywcGh4ZmrfrhIrxG": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_6",
      "pdfUrl": "https://drive.google.com/file/d/1f8ZdHeUFsOEWQsN6WUFKZIG1j9R87jLA/view?usp=sharing",
      "title": "FIKIH VI KMA-MI"
    },
    "-OVRywf5TaDQxI8yzYk7": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_6",
      "pdfUrl": "https://drive.google.com/file/d/1j9bnnq9qGjMNIolP3ACOfD4aCqF-HQUI/view?usp=sharing",
      "title": "BAHASA ARAB VI KMA-MI"
    },
    "-OVRywge8VGH3ueYzLlb": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_6",
      "pdfUrl": "https://drive.google.com/file/d/1jlejFYf0eWaDwSkFF1Hdbhfj_4O-jwH-/view?usp=sharing",
      "title": "SKI VI KMA-MI"
    },
    "-OVRywi2FgtZwUYbgyVC": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_6",
      "pdfUrl": "https://drive.google.com/file/d/1RBvt4DOs8M56EiGTGm4tcVw389Q5NpkG/view?usp=sharing",
      "title": "AL-QURAN & HADIS VI KMA-MI"
    },
    "-OVRywjLRGorl6ydozPG": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_6",
      "pdfUrl": "https://drive.google.com/file/d/1JsgVSjbJi7lp8QIYaXDzMbg2NgujdWsC/view?usp=sharing",
      "title": "AKIDAH & AKHLAK VI KMA-MI"
    },
    "-OVRywn5bCl_QT58U4qY": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_6",
      "pdfUrl": "https://drive.google.com/file/d/1f8ZdHeUFsOEWQsN6WUFKZIG1j9R87jLA/view?usp=sharing",
      "title": "FIKIH VI KMA-MI"
    },
    "-OVRywoqjF6hVUpF60YS": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_6",
      "pdfUrl": "https://drive.google.com/file/d/1j9bnnq9qGjMNIolP3ACOfD4aCqF-HQUI/view?usp=sharing",
      "title": "BAHASA ARAB VI KMA-MI"
    },
    "-OVRywqIOVYImFmjMxzO": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_6",
      "pdfUrl": "https://drive.google.com/file/d/1jlejFYf0eWaDwSkFF1Hdbhfj_4O-jwH-/view?usp=sharing",
      "title": "SKI VI KMA-MI"
    },
    "-OVRywvLuVye3vmdipDZ": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/PJOK_BG_KLS_VI_Cover.png",
      "kelas": "kelas_6",
      "pdfUrl": "https://drive.google.com/file/d/1Bq2tYGtX0EQFcb88uSI1-u6BsVXhj3qz/view?usp=sharing",
      "title": "PJOK KELAS VI SD/MI"
    },
    "-OVRywxk_LEr4FGYazmI": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Kristen_BS_KLS_VI_Cover.png",
      "kelas": "kelas_6",
      "pdfUrl": "https://drive.google.com/file/d/1JQlB5-2Edwm5_iTLP8ZuRsMXg0dXdhM_/view?usp=sharing",
      "title": "AGAMA KRISTEN KELAS VI SD"
    },
    "-OVRywzJDL53Z-LWDQRF": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Katolik_BS_KLS_VI_Cover.png",
      "kelas": "kelas_6",
      "pdfUrl": "https://drive.google.com/file/d/1NANN-ps2Vlni3M60sY73UsHFaV8DMdp4/view?usp=sharing",
      "title": "AGAMA KATOLIK KELAS VI SD"
    },
    "-OVRyx-eZxJNCV2B4cka": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Hindu-BS-KLS-VI-Cover.png",
      "kelas": "kelas_6",
      "pdfUrl": "https://drive.google.com/file/d/1JIGVlZ3nNA1eyUst0qH0pjB053SmeSrJ/view?usp=sharing",
      "title": "AGAMA HINDU KELAS VI SD"
    },
    "-OVRyx10staok3qt9_xv": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Buddha_BS_KLS_VI_Cover.png",
      "kelas": "kelas_6",
      "pdfUrl": "https://drive.google.com/file/d/1PGw5syJCVK4dIyu38zTiTJkPrsLFqncj/view?usp=sharing",
      "title": "AGAMA BUDDHA KELAS VI SD"
    },
    "-OVRyx2Lj0i2Aiu6iWWD": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Khonghucu-BS-KLS-VI-Cover.png",
      "kelas": "kelas_6",
      "pdfUrl": "https://drive.google.com/file/d/1AO8ti3npmxHNDHGvXhmpprSY9aGwPAGf/view?usp=sharing",
      "title": "AGAMA KHONGHUCU KELAS VI SD"
    },
    "-OVRz13171ZgikHEbNaz": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Bahasa-Indonesia-BS-KLS-V-cover.png",
      "kelas": "kelas_5",
      "pdfUrl": "https://drive.google.com/file/d/1ad3tUDCjGD5S-OHFj_9CqxFv08rukE-9/view?usp=sharing",
      "title": "B. INDO KELAS V SD/MI"
    },
    "-OVRz1LKOvFUfSWNx6sd": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Bahasa-Inggris-BS-KLS-V-cover.png",
      "kelas": "kelas_5",
      "pdfUrl": "https://drive.google.com/file/d/1r2ABKHmm56mt3qD6y71oRgEQs3d6_QFr/view?usp=sharing",
      "title": "B. INGGRIS KELAS V SD/MI"
    },
    "-OVRz1MU8mp0WVkzxf-z": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/IPAS-BS-KLS-V-cover.png",
      "kelas": "kelas_5",
      "pdfUrl": "https://drive.google.com/file/d/17ODByh6uzggaL5qQglIYkxBjtSscsFkT/view?usp=sharing",
      "title": "IPAS KELAS V SD/MI"
    },
    "-OVRz1Njx0hAiJCoArx6": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Kepercayaan-BS-KLS-V-cover.png",
      "kelas": "kelas_5",
      "pdfUrl": "https://drive.google.com/file/d/18WEbeKRZne6Dd3E-UQ9wQgSFq6Vkf-rc/view?usp=sharing",
      "title": "KEPERCAYAAN TUHAN YME KELAS V SD/MI"
    },
    "-OVRz1Ohm4zUZeZbIC9o": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Matematika-BS-KLS-V-Cover.png",
      "kelas": "kelas_5",
      "pdfUrl": "https://drive.google.com/file/d/1A6EkhF57zOagBQfN5YnL422sBPlwvYas/view?usp=sharing",
      "title": "MATEMATIKA KELAS V SD/MI"
    },
    "-OVRz1PnrxnpWNXvVuV6": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Matematika-Vol-1-BS-KLS-V-cover.png",
      "kelas": "kelas_5",
      "pdfUrl": "https://drive.google.com/file/d/1MTvfy0BT-YuF0tJ8svbhY3zKv2OLI3rQ/view?usp=sharing",
      "title": "MATEMATIKA VOL 1 KELAS V SD/MI"
    },
    "-OVRz1Qn1YYUdk7S4bWP": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Matematika-Vol-2-BS-KLS-V-cover.png",
      "kelas": "kelas_5",
      "pdfUrl": "https://drive.google.com/file/d/1U-IjAvMmlmBJWrmegajIG30X4wTMQJ0V/view?usp=sharing",
      "title": "MATEMATIKA VOL 2 KELAS V SD/MI"
    },
    "-OVRz1Rs3OwY-EQd0MgY": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Islam-BS-KLS-V-cover.png",
      "kelas": "kelas_5",
      "pdfUrl": "https://drive.google.com/file/d/1JGMN1RCfyOwzyiqhbCfQVxgUA6ojS8-a/view?usp=sharing",
      "title": "PAI KELAS V SD/MI"
    },
    "-OVRz1TDUuSt652XiN93": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Pendidikan-Pancasila-BS-KLS-V-Cover.png",
      "kelas": "kelas_5",
      "pdfUrl": "https://drive.google.com/file/d/1u1pRC-wMre3NzytqUdaBwnn8GnN4rjfo/view?usp=sharing",
      "title": "PP KELAS V SD/MI"
    },
    "-OVRz1UJ6nIbu6VWb4Ie": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_5",
      "pdfUrl": "https://drive.google.com/file/d/1GiMIEZ8PDKoJkqanbY7oDUMjFjfl5JFp/view?usp=sharing",
      "title": "AL-QURAN & HADIS V KMA-MI"
    },
    "-OVRz1VTo69sd10ds5b1": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_5",
      "pdfUrl": "https://drive.google.com/file/d/1Byg_o3jCV8lFgd7TUjVqmknzp68LZbTs/view?usp=sharing",
      "title": "AKIDAH & AKHLAK V KMA-MI"
    },
    "-OVRz1WUNyRcbM9fc3AS": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_5",
      "pdfUrl": "https://drive.google.com/file/d/1gNo3-ygxweEsfEcAf6u-biHc6tSqRTIF/view?usp=sharing",
      "title": "FIKIH V KMA-MI"
    },
    "-OVRz1Xl2AlF-0PcpKaD": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_5",
      "pdfUrl": "https://drive.google.com/file/d/18ODN_hxJaJxGgxES70MBIrlrNyQ9k7Yb/view?usp=sharing",
      "title": "BAHASA ARAB V KMA-MI"
    },
    "-OVRz1ZAtXg0Zk2ApRyJ": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_5",
      "pdfUrl": "https://drive.google.com/file/d/1vr2e3HUMszOAEdchs_bMt1vaNgLeLNBV/view?usp=sharing",
      "title": "SKI V KMA-MI"
    },
    "-OVRz1_EwqPhm-oZgTRX": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_5",
      "pdfUrl": "https://drive.google.com/file/d/1GiMIEZ8PDKoJkqanbY7oDUMjFjfl5JFp/view?usp=sharing",
      "title": "AL-QURAN & HADIS V KMA-MI"
    },
    "-OVRz1aa6_AzufRZmPTs": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_5",
      "pdfUrl": "https://drive.google.com/file/d/1Byg_o3jCV8lFgd7TUjVqmknzp68LZbTs/view?usp=sharing",
      "title": "AKIDAH & AKHLAK V KMA-MI"
    },
    "-OVRz1bupFPv7B7ySQup": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_5",
      "pdfUrl": "https://drive.google.com/file/d/1gNo3-ygxweEsfEcAf6u-biHc6tSqRTIF/view?usp=sharing",
      "title": "FIKIH V KMA-MI"
    },
    "-OVRz1czNd5Pi-HjTuxr": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_5",
      "pdfUrl": "https://drive.google.com/file/d/18ODN_hxJaJxGgxES70MBIrlrNyQ9k7Yb/view?usp=sharing",
      "title": "BAHASA ARAB V KMA-MI"
    },
    "-OVRz1ec0ij42rkY08JW": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_5",
      "pdfUrl": "https://drive.google.com/file/d/1vr2e3HUMszOAEdchs_bMt1vaNgLeLNBV/view?usp=sharing",
      "title": "SKI V KMA-MI"
    },
    "-OVRz1g8P3T9Ek2Uy39O": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/PJOK-BG-KLS-V-Cover.png",
      "kelas": "kelas_5",
      "pdfUrl": "https://drive.google.com/file/d/1VKFN-YqwGxLjKA2qb8jgy2R1gVjvyLt-/view?usp=sharing",
      "title": "PJOK KELAS V SD/MI"
    },
    "-OVRz1hMC8t3M5pGhOnI": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Kristen-BS-KLS-V-cover.png",
      "kelas": "kelas_5",
      "pdfUrl": "https://drive.google.com/file/d/1K3_XpNK8vUNQKcUSTPVZVNrgJlG7fo3a/view?usp=sharing",
      "title": "AGAMA KRISTEN KELAS V SD"
    },
    "-OVRz1iZhbXAZBkXn67R": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Katolik-BS-KLS-V-cover.png",
      "kelas": "kelas_5",
      "pdfUrl": "https://drive.google.com/file/d/1heOxA0Gj8404txUVPQGdvluqJ6j7_0vd/view?usp=sharing",
      "title": "AGAMA KATOLIK KELAS V SD"
    },
    "-OVRz1jd-evgjwoY_nM5": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Hindu-BS-KLS-V-cover.png",
      "kelas": "kelas_5",
      "pdfUrl": "https://drive.google.com/file/d/1i5QjWBbgVb3oXFmTwZcPMHAJnpP7mMzR/view?usp=sharing",
      "title": "AGAMA HINDU KELAS V SD"
    },
    "-OVRz1kuXGEXAJRD_pnk": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Buddha-BS-KLS-V-cover.png",
      "kelas": "kelas_5",
      "pdfUrl": "https://drive.google.com/file/d/14LPxx3wV-rw9WmRFj5ql4dfIhI4ywxfH/view?usp=sharing",
      "title": "AGAMA BUDDHA KELAS V SD"
    },
    "-OVRz1ly8m1NjNHyFZdQ": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Khonghucu-BS-KLS-V-cover.png",
      "kelas": "kelas_5",
      "pdfUrl": "https://drive.google.com/file/d/1ugfANgDGvwG8fDM5OyTFSuLldoHg6u8i/view?usp=sharing",
      "title": "AGAMA KHONGHUCU KELAS V SD"
    },
    "-OVRz7_DGte4zEhz5RmS": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Bahasa-Indonesia-BS-KLS-IV-Cover.png",
      "kelas": "kelas_4",
      "pdfUrl": "https://drive.google.com/file/d/11cc_RI67D_rJOi4XRPgKG6Ckwt4jVtNk/view?usp=sharing",
      "title": "B. INDO KELAS IV SD/MI"
    },
    "-OVRz7qXfdLe-j435tnx": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Bahasa-Inggris-BS-KLS-IV-Cover.png",
      "kelas": "kelas_4",
      "pdfUrl": "https://drive.google.com/file/d/1eKNLws-C2qZa7wnAv6zqjwsYZuxJZl2H/view?usp=sharing",
      "title": "B. INGGRIS KELAS IV SD/MI"
    },
    "-OVRz7sIUAgknl9kdrbe": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/IPAS-BS-KLS-IV-Cover.png",
      "kelas": "kelas_4",
      "pdfUrl": "https://drive.google.com/file/d/1HORJ-UNgGHE8A1cCsq5dFIgMMB3FdmZi/view?usp=sharing",
      "title": "IPAS KELAS IV SD/MI"
    },
    "-OVRz7tci5BndznVisok": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Kepercayaan-BS-KLS-IV-Cover.png",
      "kelas": "kelas_4",
      "pdfUrl": "https://drive.google.com/file/d/1TPEvb5WN4g0AlQDZyhZ-c3J-9VOqqyH6/view?usp=sharing",
      "title": "KEPERCAYAAN TUHAN YME KELAS IV SD/MI"
    },
    "-OVRz7uwGWT3jFHOz8HD": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Matematika-BS-KLS-IV-cover.png",
      "kelas": "kelas_4",
      "pdfUrl": "https://drive.google.com/file/d/1d8GgSxqrevodTUtJGYJnap0o_ga8fKS2/view?usp=sharing",
      "title": "MATEMATIKA KELAS IV SD/MI"
    },
    "-OVRz7wTk3BE9DieLdoq": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Matematika-Vol-1-BS-KLS-IV-Cover.png",
      "kelas": "kelas_4",
      "pdfUrl": "https://drive.google.com/file/d/1wDoGRUcvEaSNYn9p5_k42K7caFDZjtk6/view?usp=sharing",
      "title": "MATEMATIKA VOL 1 KELAS IV SD/MI"
    },
    "-OVRz7xo0rWeEhwAGkgl": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Matematika-Vol-2-BS-KLS-IV-Cover.png",
      "kelas": "kelas_4",
      "pdfUrl": "https://drive.google.com/file/d/1SUBFREAsctjP_uPgvNjNgHl3Ot1ABLds/view?usp=sharing",
      "title": "MATEMATIKA VOL 2 KELAS IV SD/MI"
    },
    "-OVRz7zADdd0iduJCr01": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Islam-BS-KLS-IV-Cover.png",
      "kelas": "kelas_4",
      "pdfUrl": "https://drive.google.com/file/d/1BucaX-F3RfKdZYu91OSdWlNNWsjjL1oD/view?usp=sharing",
      "title": "PAI KELAS IV SD/MI"
    },
    "-OVRz8-RXoygAzHwjbmH": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Pendidikan-Pancasila-BS-KLS-IV-Cover.png",
      "kelas": "kelas_4",
      "pdfUrl": "https://drive.google.com/file/d/1aOBtCm5_o8LOA3Hn7mKDZPK2WRRh1-Pm/view?usp=sharing",
      "title": "PP KELAS IV SD/MI"
    },
    "-OVRz80ty7hWbZ447JB1": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_4",
      "pdfUrl": "https://drive.google.com/file/d/1E2nzBsrUMp5yeHbzlZdIxN1NIehU0xlh/view?usp=sharing",
      "title": "AL-QURAN & HADIS IV KMA-MI"
    },
    "-OVRz82MV3Nl99bjSYBA": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_4",
      "pdfUrl": "https://drive.google.com/file/d/1NAQQ4OC5fAHZNMJsRf56F7He13UHJVec/view?usp=sharing",
      "title": "AKIDAH & AKHLAK IV KMA-MI"
    },
    "-OVRz83mWq4hqnwM4bWE": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_4",
      "pdfUrl": "https://drive.google.com/file/d/1LSl9GNklCv_5yqvGWNq6yMchbJNVcZzS/view?usp=sharing",
      "title": "FIKIH IV KMA-MI"
    },
    "-OVRz85P23TFzlm_JQGI": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_4",
      "pdfUrl": "https://drive.google.com/file/d/1pFeo_EFAKdk8z46QdnZTyNFNArTDJ213/view?usp=sharing",
      "title": "BAHASA ARAB IV KMA-MI"
    },
    "-OVRz8BJVIknhwhxZL6k": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_4",
      "pdfUrl": "https://drive.google.com/file/d/1PhaVpzQ0EJ64EP71J9X0W8HrrRf6n5Bu/view?usp=sharing",
      "title": "SKI IV KMA-MI"
    },
    "-OVRz8CjW0XcxQ92UtIp": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_4",
      "pdfUrl": "https://drive.google.com/file/d/1E2nzBsrUMp5yeHbzlZdIxN1NIehU0xlh/view?usp=sharing",
      "title": "AL-QURAN & HADIS IV KMA-MI"
    },
    "-OVRz8EF8H-IwBu1Ixjz": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_4",
      "pdfUrl": "https://drive.google.com/file/d/1NAQQ4OC5fAHZNMJsRf56F7He13UHJVec/view?usp=sharing",
      "title": "AKIDAH & AKHLAK IV KMA-MI"
    },
    "-OVRz8FZ-DQUf6tkjrwN": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_4",
      "pdfUrl": "https://drive.google.com/file/d/1LSl9GNklCv_5yqvGWNq6yMchbJNVcZzS/view?usp=sharing",
      "title": "FIKIH IV KMA-MI"
    },
    "-OVRz8GqVz6k56bRWW90": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_4",
      "pdfUrl": "https://drive.google.com/file/d/1pFeo_EFAKdk8z46QdnZTyNFNArTDJ213/view?usp=sharing",
      "title": "BAHASA ARAB IV KMA-MI"
    },
    "-OVRz8I7WhviKuLVLek6": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_4",
      "pdfUrl": "https://drive.google.com/file/d/1PhaVpzQ0EJ64EP71J9X0W8HrrRf6n5Bu/view?usp=sharing",
      "title": "SKI IV KMA-MI"
    },
    "-OVRz8J_SUmlgiNtiqFX": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/PJOK-BG-KLS-IV-cover.png",
      "kelas": "kelas_4",
      "pdfUrl": "https://drive.google.com/file/d/1zbcfe6cLaw8Wve2aNRu1vP9Zh2yeiAK5/view?usp=sharing",
      "title": "PJOK KELAS IV SD/MI"
    },
    "-OVRz8Kv8nN31gc51LCe": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Kristen-BS-KLS-IV-Cover.png",
      "kelas": "kelas_4",
      "pdfUrl": "https://drive.google.com/file/d/1Oy128RHW4IRrw2SZWIchzXfijK_G5jfj/view?usp=sharing",
      "title": "AGAMA KRISTEN KELAS IV SD"
    },
    "-OVRz8MIkSV7gC6A69RF": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Katolik-BS-KLS-IV-Cover.png",
      "kelas": "kelas_4",
      "pdfUrl": "https://drive.google.com/file/d/1iBZSJz1AWf2Kwz2phkvHgdgm-LbvS-UQ/view?usp=sharing",
      "title": "AGAMA KATOLIK KELAS IV SD"
    },
    "-OVRz8NYccOfmVdeLqdw": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Hindu-BS-KLS-IV-Cover.png",
      "kelas": "kelas_4",
      "pdfUrl": "https://drive.google.com/file/d/1HMzOCLlnMnKjTP813KRLvS3-Vw1gBWYE/view?usp=sharing",
      "title": "AGAMA HINDU KELAS IV SD"
    },
    "-OVRz8OslnQW7ETveNcc": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Buddha-BS-KLS-IV-Cover.png",
      "kelas": "kelas_4",
      "pdfUrl": "https://drive.google.com/file/d/17odjjqTxMkm2_fQWQrErwhB3SSLGjRNC/view?usp=sharing",
      "title": "AGAMA BUDDHA KELAS IV SD"
    },
    "-OVRz8QF5snyw2esRpjc": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Khonghucu-BS-KLS-IV-Cover.png",
      "kelas": "kelas_4",
      "pdfUrl": "https://drive.google.com/file/d/17d5bFBK52dEGOzcIdRDNWPFsSryugZ2z/view?usp=sharing",
      "title": "AGAMA KHONGHUCU KELAS IV SD"
    },
    "-OVRzC9yV8JaVKouuSao": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Bahasa-Indonesia-BS-KLS-III-Cover.png",
      "kelas": "kelas_3",
      "pdfUrl": "https://drive.google.com/file/d/16VCu1gaN-VeKFct5Rn93CMoxiRKDLcLq/view?usp=sharing",
      "title": "B. INDO KELAS III SD/MI"
    },
    "-OVRzCSGGgZxZNfARQEH": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Inggris_BS_KLS_III_Lc_Cover.png",
      "kelas": "kelas_3",
      "pdfUrl": "https://drive.google.com/file/d/1r2tWIcSAul7kvtasZnST9tO_yQifK8H8/view?usp=sharing",
      "title": "B. INGGRIS KELAS III SD/MI"
    },
    "-OVRzCU5CmCxioxhEV2P": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/IPAS-BS-KLS-III-Cover.png",
      "kelas": "kelas_3",
      "pdfUrl": "https://drive.google.com/file/d/1d35rMX6_cpqf9fJQoLrCTxvVytvagNeN/view?usp=sharing",
      "title": "IPAS KELAS III SD/MI"
    },
    "-OVRzCVCpcOaFfskQ7Sg": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Kepercayaan_BS_KLS_III_Cover.png",
      "kelas": "kelas_3",
      "pdfUrl": "https://drive.google.com/file/d/1PaTPDlS6-HY30g0M-h7Sp4ZGI6gMDDpv/view?usp=sharing",
      "title": "KEPERCAYAAN TUHAN YME KELAS III SD/MI"
    },
    "-OVRzCWHPIB74-QPQKTD": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Matematika_BS_KLS_III_Cover.png",
      "kelas": "kelas_3",
      "pdfUrl": "https://drive.google.com/file/d/1rrsI2njY-eTxroBuWgQWLWIC4t4BSroL/view?usp=sharing",
      "title": "MATEMATIKA KELAS III SD/MI"
    },
    "-OVRzCXQalC65ODPHv2s": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Matematika_BS_KLS_III_Vol_1_Lc_Cover.png",
      "kelas": "kelas_3",
      "pdfUrl": "https://drive.google.com/file/d/1EcoyLYcD625DRAX6JsU-lkgqqnQjIjum/view?usp=sharing",
      "title": "MATEMATIKA VOL 1 KELAS III SD/MI"
    },
    "-OVRzCYZKr_PgiWZPtYe": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Matematika_BS_KLS_III_Vol_2_Lc_Cover.png",
      "kelas": "kelas_3",
      "pdfUrl": "https://drive.google.com/file/d/1zy4jxbazyDibqup1L4d9crIJNR9bVzlq/view?usp=sharing",
      "title": "MATEMATIKA VOL 2 KELAS III SD/MI"
    },
    "-OVRzCZbKoEpnqrQblXC": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Islam_BS_KLS_III_Cover.png",
      "kelas": "kelas_3",
      "pdfUrl": "https://drive.google.com/file/d/1TyBVPTTRDcJpWJAsFXEG4QG_sLVF14pc/view?usp=sharing",
      "title": "PAI KELAS III SD/MI"
    },
    "-OVRzC_fPuS8RdFM7iEk": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Pendidikan-Pancasila-BS-KLS-III-Cover.png",
      "kelas": "kelas_3",
      "pdfUrl": "https://drive.google.com/file/d/1E6whqmceOd5OYzL-oWKTZqBSr9uBMlmd/view?usp=sharing",
      "title": "PP KELAS III SD/MI"
    },
    "-OVRzCarxcsMIMvOZuAo": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_3",
      "pdfUrl": "https://drive.google.com/file/d/1j7JMRyQosgDIrk1pzYL3VbqPfwnU5QKr/view?usp=sharing",
      "title": "AL-QURAN & HADIS III KMA-MI"
    },
    "-OVRzCbuLqDzzCLsaa2Y": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_3",
      "pdfUrl": "https://drive.google.com/file/d/1-vrNRr85lvM-W9uX4X2rPSvZnxXsasvb/view?usp=sharing",
      "title": "AKIDAH & AKHLAK III KMA-MI"
    },
    "-OVRzCcqseWyzYFpYCp1": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_3",
      "pdfUrl": "https://drive.google.com/file/d/19JZjWpKUHY0KovFMkAaH0FgySRMlpBVS/view?usp=sharing",
      "title": "FIKIH III KMA-MI"
    },
    "-OVRzCdrVmOkHXHKyyo7": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_3",
      "pdfUrl": "https://drive.google.com/file/d/187bBL_IILGXVWppvwbTZWWJmDejoCmOL/view?usp=sharing",
      "title": "BAHASA ARAB III KMA-MI"
    },
    "-OVRzCeuc8WmsBZUyee5": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_3",
      "pdfUrl": "https://drive.google.com/file/d/1qIogWdeBcqIUc6hNxa_qjOux6-x5wpFZ/view?usp=sharing",
      "title": "SKI III KMA-MI"
    },
    "-OVRzCg1DSrXvYXZrcZR": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_3",
      "pdfUrl": "https://drive.google.com/file/d/1j7JMRyQosgDIrk1pzYL3VbqPfwnU5QKr/view?usp=sharing",
      "title": "AL-QURAN & HADIS III KMA-MI"
    },
    "-OVRzCgwlVJwTeiKdyC7": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_3",
      "pdfUrl": "https://drive.google.com/file/d/1-vrNRr85lvM-W9uX4X2rPSvZnxXsasvb/view?usp=sharing",
      "title": "AKIDAH & AKHLAK III KMA-MI"
    },
    "-OVRzCiXZ_2Mjwu1ZGpU": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_3",
      "pdfUrl": "https://drive.google.com/file/d/19JZjWpKUHY0KovFMkAaH0FgySRMlpBVS/view?usp=sharing",
      "title": "FIKIH III KMA-MI"
    },
    "-OVRzCjipNCeT6iSnzoM": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_3",
      "pdfUrl": "https://drive.google.com/file/d/187bBL_IILGXVWppvwbTZWWJmDejoCmOL/view?usp=sharing",
      "title": "BAHASA ARAB III KMA-MI"
    },
    "-OVRzCkw7VgAEISOUHan": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_3",
      "pdfUrl": "https://drive.google.com/file/d/1qIogWdeBcqIUc6hNxa_qjOux6-x5wpFZ/view?usp=sharing",
      "title": "SKI III KMA-MI"
    },
    "-OVRzCm601OVGTTLNSmx": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/PJOK_BG_KLS_III_Cover.png",
      "kelas": "kelas_3",
      "pdfUrl": "https://drive.google.com/file/d/1xbTm1Sng_6TlDnhsNCjDhgxSoWmXpcxr/view?usp=sharing",
      "title": "PJOK KELAS III SD/MI"
    },
    "-OVRzCn77RFYyLXcEjz1": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Kristen-BS-KLS-III-Cover.png",
      "kelas": "kelas_3",
      "pdfUrl": "https://drive.google.com/file/d/1Gre8PWbxxWIX23rAaL_b8YGflMtD3PpF/view?usp=sharing",
      "title": "AGAMA KRISTEN KELAS III SD"
    },
    "-OVRzCpFOBVqHTFBF9bJ": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Katolik_BS_KLS_III_Cover.png",
      "kelas": "kelas_3",
      "pdfUrl": "https://drive.google.com/file/d/1rHGlTeALu9FgaTBYhXrYhnNIipjSOfoe/view?usp=sharing",
      "title": "AGAMA KATOLIK KELAS III SD"
    },
    "-OVRzCqXfTHd6eLajGgb": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Hindu-BS-KLS-III-Cover.png",
      "kelas": "kelas_3",
      "pdfUrl": "https://drive.google.com/file/d/1OOEfjXKjqUdXN8fbWGBcL-jau53iEH-l/view?usp=sharing",
      "title": "AGAMA HINDU KELAS III SD"
    },
    "-OVRzCriGro8ndJz73ju": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Buddha_BS_KLS_III_Cover.png",
      "kelas": "kelas_3",
      "pdfUrl": "https://drive.google.com/file/d/1QaAoovIa5gjlX7B2FlMoXSRpw_YpVhzn/view?usp=sharing",
      "title": "AGAMA BUDDHA KELAS III SD"
    },
    "-OVRzCsnaZfXp2hrQP-_": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Khonghucu_BS_KLS_III_Cover.png",
      "kelas": "kelas_3",
      "pdfUrl": "https://drive.google.com/file/d/1Vj2rVRnuRwQd4nGBthQS26qUHswQlw9y/view?usp=sharing",
      "title": "AGAMA KHONGHUCU KELAS III SD"
    },
    "-OVRzIQ3fARBG8laznEo": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Bahasa-Indonesia-BS-KLS-II-cover.png",
      "kelas": "kelas_2",
      "pdfUrl": "https://drive.google.com/file/d/1WFyqMm2HcQWt474dZ4orshV3NPbjyrMY/view?usp=sharing",
      "title": "B. INDO KELAS II SD/MI"
    },
    "-OVRzIgtk9WxjMC0Sv79": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Bahasa-Inggris-BS-KLS-II-cover.png",
      "kelas": "kelas_2",
      "pdfUrl": "https://drive.google.com/file/d/1q8Mnouk3GRdG2k1nWgi8QATG9HsC_yWv/view?usp=sharing",
      "title": "B. INGGRIS KELAS II SD/MI"
    },
    "-OVRzIi8JKI0buikqEr_": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Kepercayaan-BS-KLS-II-cover.png",
      "kelas": "kelas_2",
      "pdfUrl": "https://drive.google.com/file/d/16QY2cr4wzttT3UOQWyNVQx08NhWhoIl0/view?usp=sharing",
      "title": "KEPERCAYAAN TUHAN YME KELAS II SD/MI"
    },
    "-OVRzIjVgsTLITrOEno4": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Matematika-BS-KLS-II-Cover.png",
      "kelas": "kelas_2",
      "pdfUrl": "https://drive.google.com/file/d/1o5tX-aJdc8xD0MHneQoVyYGWANENy8nJ/view?usp=sharing",
      "title": "MATEMATIKA KELAS II SD/MI"
    },
    "-OVRzIkiOr5btAZ3tzFP": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Matematika-Vol-1-BS-KLS-II-cover.png",
      "kelas": "kelas_2",
      "pdfUrl": "https://drive.google.com/file/d/1tvEDboVpa9SaukczSIl9jueF3dN3DTjT/view?usp=sharing",
      "title": "MATEMATIKA VOL 1 KELAS II SD/MI"
    },
    "-OVRzIlm6UchFDC97i3L": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Matematika-Vol-2-BS-KLS-II-cover.png",
      "kelas": "kelas_2",
      "pdfUrl": "https://drive.google.com/file/d/1FP8FPGTsbCdrHWq7kmKO4C_4wEJd4nDb/view?usp=sharing",
      "title": "MATEMATIKA VOL 2 KELAS II SD/MI"
    },
    "-OVRzImzMmjGsslUGJ5M": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Islam-BS-KLS-II-cover.png",
      "kelas": "kelas_2",
      "pdfUrl": "https://drive.google.com/file/d/1VSaiZxrVTFZlf0TwD7V6Hsput3g6SiOy/view?usp=sharing",
      "title": "PAI KELAS II SD/MI"
    },
    "-OVRzIo-TORV6h8_3Xv8": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Pendidikan-Pancasila-BS-KLS-II-Cover.png",
      "kelas": "kelas_2",
      "pdfUrl": "https://drive.google.com/file/d/1YzZp9Nenda7by3CBlieinqB_VAjN09dT/view?usp=sharing",
      "title": "PP KELAS II SD/MI"
    },
    "-OVRzIp5j7n6RokuAdoy": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_2",
      "pdfUrl": "https://drive.google.com/file/d/1Mpw00g3j5XWSLhbDQzZrVX2U_zh4AUf_/view?usp=sharing",
      "title": "AL-QURAN & HADIS II KMA-MI"
    },
    "-OVRzIq8HXyozu_KTVvM": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_2",
      "pdfUrl": "https://drive.google.com/file/d/1tCZuPakgzTCyjI61QacZ2Uy1PbFRJecT/view?usp=sharing",
      "title": "AKIDAH & AKHLAK II KMA-MI"
    },
    "-OVRzIrBq_38fECe3BL-": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_2",
      "pdfUrl": "https://drive.google.com/file/d/1rOozIBqNp8y-Yfxgs5DZikTng-rzPDeA/view?usp=sharing",
      "title": "FIKIH II KMA-MI"
    },
    "-OVRzIsHzgp512mmHf9q": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_2",
      "pdfUrl": "https://drive.google.com/file/d/1dmG47E6rbUHDjkpxV1gQrr358zC8LBYE/view?usp=sharing",
      "title": "BAHASA ARAB II KMA-MI"
    },
    "-OVRzItJDvUQI7F9rmvl": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_2",
      "pdfUrl": "https://drive.google.com/file/d/1Mpw00g3j5XWSLhbDQzZrVX2U_zh4AUf_/view?usp=sharing",
      "title": "AL-QURAN & HADIS II KMA-MI"
    },
    "-OVRzIuV4NBTgDFTMld3": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_2",
      "pdfUrl": "https://drive.google.com/file/d/1tCZuPakgzTCyjI61QacZ2Uy1PbFRJecT/view?usp=sharing",
      "title": "AKIDAH & AKHLAK II KMA-MI"
    },
    "-OVRzIveUeBDkMuhIBkP": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_2",
      "pdfUrl": "https://drive.google.com/file/d/1rOozIBqNp8y-Yfxgs5DZikTng-rzPDeA/view?usp=sharing",
      "title": "FIKIH II KMA-MI"
    },
    "-OVRzIwyDcmUYL0PvRBR": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_2",
      "pdfUrl": "https://drive.google.com/file/d/1dmG47E6rbUHDjkpxV1gQrr358zC8LBYE/view?usp=sharing",
      "title": "BAHASA ARAB II KMA-MI"
    },
    "-OVRzIyDXVK2bgKYtgyn": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/PJOK-BG-KLS-II-Cover.png",
      "kelas": "kelas_2",
      "pdfUrl": "https://drive.google.com/file/d/1LucnLZn6DD0NhCmxKU73K2V-6Vv6skVS/view?usp=sharing",
      "title": "PJOK KELAS II SD/MI"
    },
    "-OVRzIzMaFlV5YAQNgy-": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Kristen-BS-KLS-II-cover.png",
      "kelas": "kelas_2",
      "pdfUrl": "https://drive.google.com/file/d/1YMwUfzLXT3-AnFvpmP5kPHWix5WlFNCO/view?usp=sharing",
      "title": "AGAMA KRISTEN KELAS II SD"
    },
    "-OVRzJ-bw20pGjBW52mC": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Katolik-BS-KLS-II-cover.png",
      "kelas": "kelas_2",
      "pdfUrl": "https://drive.google.com/file/d/1k6DTuooF4ntE2G-WrOZnc77yIM_VUVJu/view?usp=sharing",
      "title": "AGAMA KATOLIK KELAS II SD"
    },
    "-OVRzJ0imjB-lK0M_9wQ": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Hindu-BS-KLS-II-cover.png",
      "kelas": "kelas_2",
      "pdfUrl": "https://drive.google.com/file/d/1habjSFY1ktqi38763BywCTTTf6AHeS6U/view?usp=sharing",
      "title": "AGAMA HINDU KELAS II SD"
    },
    "-OVRzJ1rUVbtst777TXA": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Buddha-BS-KLS-II-cover.png",
      "kelas": "kelas_2",
      "pdfUrl": "https://drive.google.com/file/d/1wOZi1VvPnkAqKWBOgipBcrL43bGHy6gj/view?usp=sharing",
      "title": "AGAMA BUDDHA KELAS II SD"
    },
    "-OVRzJ30rxsK5bq_gKiy": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Khonghucu-BS-KLS-II-cover.png",
      "kelas": "kelas_2",
      "pdfUrl": "https://drive.google.com/file/d/1pi3xf5aPKZlmezEXTRq-XQs3pfmmS-f9/view?usp=sharing",
      "title": "AGAMA KHONGHUCU KELAS II SD"
    },
    "-OVRzOxTU0qRiJbsAPeV": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Bahasa-Indonesia-BS-KLS-I-Cover.png",
      "kelas": "kelas_1",
      "pdfUrl": "https://drive.google.com/file/d/12ZGT2nYLFWicUoOqGaSoaD4DITeKtVFJ/view?usp=sharing",
      "title": "B. INDO KELAS I SD/MI"
    },
    "-OVRzPEhY15eqO_clTVp": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Bahasa-Inggris-BS-KLS-I-Cover.png",
      "kelas": "kelas_1",
      "pdfUrl": "https://drive.google.com/file/d/1g_ZH2UAdbscPtAflLgsFvawtWxOqkzVo/view?usp=sharing",
      "title": "B. INGGRIS KELAS I SD/MI"
    },
    "-OVRzPFzigBoqIuVl6tN": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Kepercayaan-BS-KLS-I-Cover.png",
      "kelas": "kelas_1",
      "pdfUrl": "https://drive.google.com/file/d/1sD5jhVGSa6VJklbQBtQb1kht6tLvkzMB/view?usp=sharing",
      "title": "KEPERCAYAAN TUHAN YME KELAS I SD/MI"
    },
    "-OVRzPHRCja6iaPiysd6": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Matematika-BS-KLS-I-cover.png",
      "kelas": "kelas_1",
      "pdfUrl": "https://drive.google.com/file/d/1jxZ-lj0_1UBZHZMhQjYpsNSDkugB_pD4/view?usp=sharing",
      "title": "MATEMATIKA KELAS I SD/MI"
    },
    "-OVRzPIhjoKnSRgvuR1E": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Matematika-BS-KLS-I-Cover.png",
      "kelas": "kelas_1",
      "pdfUrl": "https://drive.google.com/file/d/1bg25Ei4YbdrfXibMBt8rctsAxGPE353n/view?usp=sharing",
      "title": "MTK LISENSI KELAS I SD/MI"
    },
    "-OVRzPJzFsLcuu6WVMdL": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Islam-BS-KLS-I-Cover.png",
      "kelas": "kelas_1",
      "pdfUrl": "https://drive.google.com/file/d/1gucUDDDy6EM-op_Ui3-epT9vpLoDV-kd/view?usp=sharing",
      "title": "PAI KELAS I SD/MI"
    },
    "-OVRzPLAhE4Rd2Gpcizn": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Pendidikan-Pancasila-BS-KLS-I-Cover.png",
      "kelas": "kelas_1",
      "pdfUrl": "https://drive.google.com/file/d/1FFKhQ3nmWXunvAsyvVYXco7WQ1DSzChy/view?usp=sharing",
      "title": "PP KELAS I SD/MI"
    },
    "-OVRzPMR5x0oJcPl1-9P": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_1",
      "pdfUrl": "https://drive.google.com/file/d/1nJNibUd84p9KWp4J3HmqYwLCYltnq91j/view?usp=sharing",
      "title": "AL-QURAN & HADIS I KMA-MI"
    },
    "-OVRzPNoyBJmurzu0IEH": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_1",
      "pdfUrl": "https://drive.google.com/file/d/1YUEbKkQg-UdyHsTWA9G5XUu768_qPHoT/view?usp=sharing",
      "title": "AKIDAH & AKHLAK I KMA-MI"
    },
    "-OVRzPOy1iNwx4gQ8g0e": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_1",
      "pdfUrl": "https://drive.google.com/file/d/1O_8U5mIdy7_-4pyXIZ46jMgcMpX9ylP7/view?usp=sharing",
      "title": "FIKIH I KMA-MI"
    },
    "-OVRzPQDvm7UMoIvQ7gC": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_1",
      "pdfUrl": "https://drive.google.com/file/d/1L_5SnorN0UECGVVt0Jch4_SG36QYAJUG/view?usp=sharing",
      "title": "BAHASA ARAB I KMA-MI"
    },
    "-OVRzPRSYgzxAV_9WMRa": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_1",
      "pdfUrl": "https://drive.google.com/file/d/1nJNibUd84p9KWp4J3HmqYwLCYltnq91j/view?usp=sharing",
      "title": "AL-QURAN & HADIS I KMA-MI"
    },
    "-OVRzPScIYPqDWm6g1Sa": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_1",
      "pdfUrl": "https://drive.google.com/file/d/1YUEbKkQg-UdyHsTWA9G5XUu768_qPHoT/view?usp=sharing",
      "title": "AKIDAH & AKHLAK I KMA-MI"
    },
    "-OVRzPTqnt_u2mw-Kxt8": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_1",
      "pdfUrl": "https://drive.google.com/file/d/1O_8U5mIdy7_-4pyXIZ46jMgcMpX9ylP7/view?usp=sharing",
      "title": "FIKIH I KMA-MI"
    },
    "-OVRzPZuJJDBq7XCmVww": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_1",
      "pdfUrl": "https://drive.google.com/file/d/1L_5SnorN0UECGVVt0Jch4_SG36QYAJUG/view?usp=sharing",
      "title": "BAHASA ARAB I KMA-MI"
    },
    "-OVRzPaAtQ1-fR0Yioig": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/PJOK-BG-KLS-I-cover.png",
      "kelas": "kelas_1",
      "pdfUrl": "https://drive.google.com/file/d/1yhiOY5M3Ph4L3XD07r_NTdFtfthYIfbn/view?usp=sharing",
      "title": "PJOK KELAS I SD/MI"
    },
    "-OVRzPbNmnk8jAxSysVI": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Kristen-BS-KLS-I-Cover.png",
      "kelas": "kelas_1",
      "pdfUrl": "https://drive.google.com/file/d/1lQtT4xsIKwdPic_lyBYUC_-erUSTC9yp/view?usp=sharing",
      "title": "AGAMA KRISTEN KELAS I SD"
    },
    "-OVRzPcXFfTYhZ_r7oyB": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Katolik-BS-KLS-I-Cover.png",
      "kelas": "kelas_1",
      "pdfUrl": "https://drive.google.com/file/d/1F7lSiBiMq-bfoPZol__JEnLy1Ag4772J/view?usp=sharing",
      "title": "AGAMA KATOLIK KELAS I SD"
    },
    "-OVRzPdeTl9NqS0MLkgG": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Hindu-BS-KLS-I-Cover.png",
      "kelas": "kelas_1",
      "pdfUrl": "https://drive.google.com/file/d/1Z-Q7IolDD0qi4YPQdk-w8RU1L1eB8K1x/view?usp=sharing",
      "title": "AGAMA HINDU KELAS I SD"
    },
    "-OVRzPelIxZIdC95Pt5o": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Buddha-BS-KLS-I-Cover.png",
      "kelas": "kelas_1",
      "pdfUrl": "https://drive.google.com/file/d/1KHliXxLdQ4bBQY2WUB5dR9JNo7JLfZPN/view?usp=sharing",
      "title": "AGAMA BUDDHA KELAS I SD"
    },
    "-OVRzPg3xXs6D3upu7OA": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Khonghucu-BS-KLS-I-Cover.png",
      "kelas": "kelas_1",
      "pdfUrl": "https://drive.google.com/file/d/1DPwLVrtcaaIyWxrfr8lSpf8I-iCjn4ie/view?usp=sharing",
      "title": "AGAMA KHONGHUCU KELAS I SD"
    },
    "-OVRzVeZeW6qT9uRx-Te": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Bahasa-Indonesia-BS-KLS-VIII-cover.png",
      "kelas": "kelas_8",
      "pdfUrl": "https://drive.google.com/file/d/1JY80_c1yfyVqIHSBmnFcsa7KzMmau5ZZ/view?usp=sharing",
      "title": "B. INDO KELAS VIII SMP/MTS"
    },
    "-OVRzVwEN5zHj-EGFNYC": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Bahasa-inggris-BS-KLS-VIII-nsn-Cover.png",
      "kelas": "kelas_8",
      "pdfUrl": "https://drive.google.com/file/d/1hmm7gxpySB7QLqH1ZO4OEqg-s0nN6sxk/view?usp=sharing",
      "title": "B. INGGRIS KELAS VIII SMP/MTS"
    },
    "-OVRzVxx_NVm_cZlgW-z": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Informatika-BS-KLS-VIII-cover.png",
      "kelas": "kelas_8",
      "pdfUrl": "https://drive.google.com/file/d/1ooqSpzyhdwO5_gOhTK18tjiCUT-6tDLU/view?usp=sharing",
      "title": "INFORMATIKA KELAS VIII SMP/MTS"
    },
    "-OVRzVzNRHRvGQvjlUIs": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/IPA-BS-KLS-VIII-cover.png",
      "kelas": "kelas_8",
      "pdfUrl": "https://drive.google.com/file/d/1d1d_zrzpaP_03gcdXXRRtEFvaXjouSWn/view?usp=sharing",
      "title": "IPA KELAS VIII SMP/MTS"
    },
    "-OVRzW-vcSquxzAl1MKL": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/IPS-BS-KLS-VIII-cover.png",
      "kelas": "kelas_8",
      "pdfUrl": "https://drive.google.com/file/d/1AEpb0lodU6RrWDr5xqbd-bRQmtwdvEHU/view?usp=sharing",
      "title": "IPS KELAS VIII SMP/MTS"
    },
    "-OVRzW1R5dM86QFeoUjP": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Kepercayaan-BS-KLS-VIII-cover.png",
      "kelas": "kelas_8",
      "pdfUrl": "https://drive.google.com/file/d/1EG48gXebjxC6T1haJ9LT-zhqGB1_cd0A/view?usp=sharing",
      "title": "KEPERCAYAAN TUHAN YME KELAS VIII SMP/MTS"
    },
    "-OVRzW2y6RE-Xtryla-A": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Matematika-BS-KLS-VIII-cover.png",
      "kelas": "kelas_8",
      "pdfUrl": "https://drive.google.com/file/d/1IP2dY3UzTGXfnKmTV1E7rzLKPITj_vSm/view?usp=sharing",
      "title": "MATEMATIKA KELAS VIII SMP/MTS"
    },
    "-OVRzW4Y-NRtQUgrYzD6": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Matematika-BS-KLS-VIII-Cover.png",
      "kelas": "kelas_8",
      "pdfUrl": "https://drive.google.com/file/d/1Vd6vTaUIeupOFWcj0UP6dds3FwrCYDcA/view?usp=sharing",
      "title": "MATEMATIKA BARU KELAS VIII SMP/MTS"
    },
    "-OVRzW5ui_Km4DjNG1H1": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Islam-BS-KLS-VIII-cover.png",
      "kelas": "kelas_8",
      "pdfUrl": "https://drive.google.com/file/d/16kYbivvV2mWfo_5uP4K6R5pILkmwFbBv/view?usp=sharing",
      "title": "PAI KELAS VIII SMP/MTS"
    },
    "-OVRzW7Exy3qevDPwmV-": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Pendidikan-Pancasila-BS-KLS-VIII-Cover.png",
      "kelas": "kelas_8",
      "pdfUrl": "https://drive.google.com/file/d/1oBLLtFYGbfnB-TEeMHt7MYNl5ClXJIuK/view?usp=sharing",
      "title": "PP KELAS VIII SMP/MTS"
    },
    "-OVRzW93eIOGzRFnBP5-": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_8",
      "pdfUrl": "https://drive.google.com/file/d/1JJSiMTU8xmWD2VOn4qLR83Fhe3KVveVS/view?usp=sharing",
      "title": "AL-QURAN & HADIS VIII KMA-MTS"
    },
    "-OVRzWB6ssxplYymlV4I": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_8",
      "pdfUrl": "https://drive.google.com/file/d/1rjq48Y-vXcVJkvSh6h-Djyk1RgRk-yIZ/view?usp=sharing",
      "title": "AKIDAH & AKHLAK VIII KMA-MTS"
    },
    "-OVRzWCa6bloydieG6yy": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_8",
      "pdfUrl": "https://drive.google.com/file/d/14ifcFq6MpaYcPwQAAbwrBBoZaTkJWzdt/view?usp=sharing",
      "title": "FIKIH VIII KMA-MTS"
    },
    "-OVRzWDjsRvaJEZuMP71": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_8",
      "pdfUrl": "https://drive.google.com/file/d/1h4NsRJSgqTE_pscX4StqzQC8XeupSXPM/view?usp=sharing",
      "title": "BAHASA ARAB VIII KMA-MTS"
    },
    "-OVRzWEyV5NJPpNYQl9P": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_8",
      "pdfUrl": "https://drive.google.com/file/d/19r8AJzomoTRPOOStz7gmP5i10dMhxF18/view?usp=sharing",
      "title": "SKI VIII KMA-MTS"
    },
    "-OVRzWGSpYwbO-KYTzlq": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_8",
      "pdfUrl": "https://drive.google.com/file/d/1JJSiMTU8xmWD2VOn4qLR83Fhe3KVveVS/view?usp=sharing",
      "title": "AL-QURAN & HADIS VIII KMA-MTS"
    },
    "-OVRzWIBpG0GOils3tB7": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_8",
      "pdfUrl": "https://drive.google.com/file/d/1rjq48Y-vXcVJkvSh6h-Djyk1RgRk-yIZ/view?usp=sharing",
      "title": "AKIDAH & AKHLAK VIII KMA-MTS"
    },
    "-OVRzWJdA1D5nsopkmXb": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_8",
      "pdfUrl": "https://drive.google.com/file/d/14ifcFq6MpaYcPwQAAbwrBBoZaTkJWzdt/view?usp=sharing",
      "title": "FIKIH VIII KMA-MTS"
    },
    "-OVRzWLFmcMwW7PH1D0F": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_8",
      "pdfUrl": "https://drive.google.com/file/d/1h4NsRJSgqTE_pscX4StqzQC8XeupSXPM/view?usp=sharing",
      "title": "BAHASA ARAB VIII KMA-MTS"
    },
    "-OVRzWM_EfsBUk3IRuX5": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_8",
      "pdfUrl": "https://drive.google.com/file/d/19r8AJzomoTRPOOStz7gmP5i10dMhxF18/view?usp=sharing",
      "title": "SKI VIII KMA-MTS"
    },
    "-OVRzWOKgK83pC81qXwM": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Kristen-BS-KLS-VIII-cover.png",
      "kelas": "kelas_8",
      "pdfUrl": "https://drive.google.com/file/d/1REDYPzCNR8KfdVexk_q8IkW1ztmSvKrW/view?usp=sharing",
      "title": "AGAMA KRISTEN KELAS VIII SMP"
    },
    "-OVRzWR-ju6NWY98e90Y": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Katolik-BS-KLS-VIII-cover.png",
      "kelas": "kelas_8",
      "pdfUrl": "https://drive.google.com/file/d/1gx8PP9FBia5fR3m5cmoovP6lh4hbaK5j/view?usp=sharing",
      "title": "AGAMA KATOLIK KELAS VIII SMP"
    },
    "-OVRzWS_yCKL3vDBDxh8": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Hindu-BS-KLS-VIII-cover.png",
      "kelas": "kelas_8",
      "pdfUrl": "https://drive.google.com/file/d/1Kd6EVmsJL6G-fm6QSZE8YWO0LLOOIXF0/view?usp=sharing",
      "title": "AGAMA HINDU KELAS VIII SMP"
    },
    "-OVRzWVVB4GOS-3axgck": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Buddha-BS-KLS-VIII-cover.png",
      "kelas": "kelas_8",
      "pdfUrl": "https://drive.google.com/file/d/1hwx5A6llxH7NJXUmtYFtOvpKXJFezwr4/view?usp=sharing",
      "title": "AGAMA BUDDHA KELAS VIII SMP"
    },
    "-OVRzWXHSeKf12GC5xoq": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Khonghucu-BS-KLS-VIII-cover.png",
      "kelas": "kelas_8",
      "pdfUrl": "https://drive.google.com/file/d/1yQFIpR22YGq6y2c8SM1PvmtS6n0dVRh7/view?usp=sharing",
      "title": "AGAMA KHONGHUCU KELAS VIII SMP"
    },
    "-OVRz_-yC4IU37dN08A-": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Bahasa-Indonesia-BS-KLS-IX-Cover.png",
      "kelas": "kelas_9",
      "pdfUrl": "https://drive.google.com/file/d/1Pcp012hQD2sfj9yc0o35G7xEQOCD7Jts/view?usp=sharing",
      "title": "B. INDO KELAS IX SMP/MTS"
    },
    "-OVRz_I2sYNeZrMFY37o": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Inggris_BS_KLS_IX_Cover.png",
      "kelas": "kelas_9",
      "pdfUrl": "https://drive.google.com/file/d/10HEdHnlW7o1lBLHkbH3gqn-ZKK_QbiGf/view?usp=sharing",
      "title": "B. INGGRIS KELAS IX SMP/MTS"
    },
    "-OVRz_JYJcJucdvSy0IU": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Informatika-BS-KLS-IX-Cover.png",
      "kelas": "kelas_9",
      "pdfUrl": "https://drive.google.com/file/d/1GdFfSCINfQeDy7yeZ1ewa2kS63yE3f91/view?usp=sharing",
      "title": "INFORMATIKA KELAS IX SMP/MTS"
    },
    "-OVRz_KjOy3ScmKvJcFI": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/IPA-BS-KLS-IX-Cover.png",
      "kelas": "kelas_9",
      "pdfUrl": "https://drive.google.com/file/d/1gBXSnvjfTMp0pZMB1UDecD3eJvNCLgqH/view?usp=sharing",
      "title": "IPA KELAS IX SMP/MTS"
    },
    "-OVRz_Lt8JJ33NoOvSiP": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/IPS-BS-KLS-IX-Cover.png",
      "kelas": "kelas_9",
      "pdfUrl": "https://drive.google.com/file/d/1AvMAcpZNVZTSQdyu3HHIXxuiPwa5eBKJ/view?usp=sharing",
      "title": "IPS KELAS IX SMP/MTS"
    },
    "-OVRz_N1r91fgMzSZcYq": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Kepercayaan-BS-KLS-IX-Cover.png",
      "kelas": "kelas_9",
      "pdfUrl": "https://drive.google.com/file/d/1aX_rmJgGvDDriIVyU7duwAamIRMyrsnU/view?usp=sharing",
      "title": "KEPERCAYAAN TUHAN YME KELAS IX SMP/MTS"
    },
    "-OVRz_NyM9pMOdrjMkJh": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Matematika_BS_KLS_IX_Cover.png",
      "kelas": "kelas_9",
      "pdfUrl": "https://drive.google.com/file/d/1jlftVGrt1YhrUa3k0J5PaY6Mq7ossgbL/view?usp=sharing",
      "title": "MATEMATIKA KELAS IX SMP/MTS"
    },
    "-OVRz_P3HdJdACbHr8mo": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Matematika_BS_KLS_IX_Lc_Cover.png",
      "kelas": "kelas_9",
      "pdfUrl": "https://drive.google.com/file/d/1RO40Rp_uk2pYu5c25RWw3bZrcVZbhXyb/view?usp=sharing",
      "title": "MATEMATIKA LISENSI KELAS IX SMP/MTS"
    },
    "-OVRz_QKaToQUXcufRUG": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Islam_BS_KLS_IX_Cover.png",
      "kelas": "kelas_9",
      "pdfUrl": "https://drive.google.com/file/d/19TuNGvoQ0vL_DiXNRPlnXN7P3L9-tEVs/view?usp=sharing",
      "title": "PAI KELAS IX SMP/MTS"
    },
    "-OVRz_RVoRvXC5MlZ19_": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/Pendidikan-Pancasila-BS-KLS-IX-Cover.png",
      "kelas": "kelas_9",
      "pdfUrl": "https://drive.google.com/file/d/1TQq7PzeTtdZidi5aHkr1YrCNCvodEr1Z/view?usp=sharing",
      "title": "PP KELAS IX SMP/MTS"
    },
    "-OVRz_Sez6MHkhqP7n-G": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_9",
      "pdfUrl": "https://drive.google.com/file/d/15ocHff_NnlzOEdEVM5-DgNnrhCtIn5ws/view?usp=sharing",
      "title": "AL-QURAN & HADIS IX KMA-MTS"
    },
    "-OVRz_Tmga-bUjNxv2Lq": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_9",
      "pdfUrl": "https://drive.google.com/file/d/1kmBozrkB_cX1pRmFU-wZsgZsuvRe1Y2h/view?usp=sharing",
      "title": "AKIDAH & AKHLAK IX KMA-MTS"
    },
    "-OVRz_UnQAqO4P1J-ISk": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_9",
      "pdfUrl": "https://drive.google.com/file/d/1Eqvek2BYBLGZuQdt-0S12vzCpjr0w82k/view?usp=sharing",
      "title": "FIKIH IX KMA-MTS"
    },
    "-OVRz_VnRRoN3YHTjrqp": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_9",
      "pdfUrl": "https://drive.google.com/file/d/1I0DHY6NllaSAw17zaKbzLgkVhTcppbap/view?usp=sharing",
      "title": "BAHASA ARAB IX KMA-MTS"
    },
    "-OVRz_WttIRHcLOXSlUU": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_9",
      "pdfUrl": "https://drive.google.com/file/d/1wzm35VcspFlDcp6wy5pU8ThHgqaJ3ZlF/view?usp=sharing",
      "title": "SKI IX KMA-MTS"
    },
    "-OVRz_Y0lOL1lGwkGsoU": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_9",
      "pdfUrl": "https://drive.google.com/file/d/15ocHff_NnlzOEdEVM5-DgNnrhCtIn5ws/view?usp=sharing",
      "title": "AL-QURAN & HADIS IX KMA-MTS"
    },
    "-OVRz_Z0qUpxzIJCIluf": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_9",
      "pdfUrl": "https://drive.google.com/file/d/1kmBozrkB_cX1pRmFU-wZsgZsuvRe1Y2h/view?usp=sharing",
      "title": "AKIDAH & AKHLAK IX KMA-MTS"
    },
    "-OVRz__M8DGZtKUDUWUI": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_9",
      "pdfUrl": "https://drive.google.com/file/d/1Eqvek2BYBLGZuQdt-0S12vzCpjr0w82k/view?usp=sharing",
      "title": "FIKIH IX KMA-MTS"
    },
    "-OVRz_aVGnzsw5Wo0RD-": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_9",
      "pdfUrl": "https://drive.google.com/file/d/1I0DHY6NllaSAw17zaKbzLgkVhTcppbap/view?usp=sharing",
      "title": "BAHASA ARAB IX KMA-MTS"
    },
    "-OVRz_bf5iLMNl5JkfKF": {
      "imgUrl": "https://bupin-het-images.pages.dev/optimized/bukuhet.png",
      "kelas": "kelas_9",
      "pdfUrl": "https://drive.google.com/file/d/1wzm35VcspFlDcp6wy5pU8ThHgqaJ3ZlF/view?usp=sharing",
      "title": "SKI IX KMA-MTS"
    },
    "-OVRz_cpRbZiqtuspaFv": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Kristen-BS-KLS-IX-Cover.png",
      "kelas": "kelas_9",
      "pdfUrl": "https://drive.google.com/file/d/1KWF_svsWH49bRHmH3Qd_6WwRMs0P6y_1/view?usp=sharing",
      "title": "AGAMA KRISTEN KELAS IX SMP"
    },
    "-OVRz_e1Mo94H_gjY0k9": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Katolik-BS-KLS-IX-Cover.png",
      "kelas": "kelas_9",
      "pdfUrl": "https://drive.google.com/file/d/1ekmOo0zbE2JVPevqMy1MqF-D1MEeB2vU/view?usp=sharing",
      "title": "AGAMA KATOLIK KELAS IX SMP"
    },
    "-OVRz_fKoiOLBqMw_YXb": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Hindu-BS-KLS-IX-Cover.png",
      "kelas": "kelas_9",
      "pdfUrl": "https://drive.google.com/file/d/1zcWe3aU-mnZl55A6BkATtu26L-AN9IyX/view?usp=sharing",
      "title": "AGAMA HINDU KELAS IX SMP"
    },
    "-OVRz_gUwqG-v9sM0OaE": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Buddha-BS-KLS-IX-Cover.png",
      "kelas": "kelas_9",
      "pdfUrl": "https://drive.google.com/file/d/1ax6_jLulePtk6XEa-Vm3N6jdTT-vYjPw/view?usp=sharing",
      "title": "AGAMA BUDDHA KELAS IX SMP"
    },
    "-OVRz_haofgvc94_5I8D": {
      "imgUrl": "https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Khonghucu-BS-KLS-IX-Cover.png",
      "kelas": "kelas_9",
      "pdfUrl": "https://drive.google.com/file/d/1stbRgurvpLlrzSUqFibBqvU_raO9ihFh/view?usp=sharing",
      "title": "AGAMA KHONGHUCU KELAS IX SMP"
    }
  };


    for (var book in booksData.values) {
      final imgUrl = book['imgUrl'];
      final pdfUrl = book['pdfUrl'];
      final title = book['title'];
      final kelas = book['kelas']!.toUpperCase().replaceAll("_", "-");


      // Download image
      // await downloadFile(imgUrl??"", "$title-image.png");
      
      // Download PDF
      await downloadFile(pdfUrl??"", "$kelas-$title.pdf");
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text("Download Files"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            DownloadService().downloadAll(); // Start downloading
          },
          child: Text("Download Books"),
        ),
      ),
    ),
  ));
}
