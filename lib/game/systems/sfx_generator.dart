import 'dart:math';
import 'dart:typed_data';

class SfxGenerator {
  static const int sampleRate = 22050;
  
  static Float32List generateShoot() {
    final duration = 0.1;
    final samples = (sampleRate * duration).toInt();
    final data = Float32List(samples);
    
    for (int i = 0; i < samples; i++) {
      final t = i / sampleRate;
      final freq = 800 - (t * 6000);
      final envelope = 1.0 - (i / samples);
      data[i] = (sin(2 * pi * freq * t) * envelope * 0.5).clamp(-1.0, 1.0);
    }
    
    return data;
  }
  
  static Float32List generateExplosion() {
    final duration = 0.3;
    final samples = (sampleRate * duration).toInt();
    final data = Float32List(samples);
    final random = Random(42);
    
    for (int i = 0; i < samples; i++) {
      final t = i / sampleRate;
      final envelope = 1.0 - (i / samples);
      final noise = random.nextDouble() * 2 - 1;
      final freq = 100 + (t * 200);
      data[i] = (noise * sin(2 * pi * freq * t) * envelope * 0.6).clamp(-1.0, 1.0);
    }
    
    return data;
  }
  
  static Float32List generateHit() {
    final duration = 0.05;
    final samples = (sampleRate * duration).toInt();
    final data = Float32List(samples);
    
    for (int i = 0; i < samples; i++) {
      final t = i / sampleRate;
      final envelope = 1.0 - (i / samples);
      final freq = 1200 - (t * 10000);
      data[i] = (sin(2 * pi * freq * t) * envelope * 0.4).clamp(-1.0, 1.0);
    }
    
    return data;
  }
  
  static Float32List generatePowerUp() {
    final duration = 0.2;
    final samples = (sampleRate * duration).toInt();
    final data = Float32List(samples);
    
    for (int i = 0; i < samples; i++) {
      final t = i / sampleRate;
      final envelope = 1.0 - (i / samples);
      final freq = 400 + (t * 2000);
      data[i] = (sin(2 * pi * freq * t) * envelope * 0.4).clamp(-1.0, 1.0);
    }
    
    return data;
  }
  
  static Float32List generateGameOver() {
    final duration = 0.5;
    final samples = (sampleRate * duration).toInt();
    final data = Float32List(samples);
    
    for (int i = 0; i < samples; i++) {
      final t = i / sampleRate;
      final envelope = 1.0 - (i / samples);
      final freq = 600 - (t * 800);
      data[i] = (sin(2 * pi * freq * t) * envelope * 0.5).clamp(-1.0, 1.0);
    }
    
    return data;
  }
  
  static Float32List generateVictory() {
    final duration = 0.4;
    final samples = (sampleRate * duration).toInt();
    final data = Float32List(samples);
    
    for (int i = 0; i < samples; i++) {
      final t = i / sampleRate;
      final envelope = 1.0 - (i / samples);
      final freq = 500 + (t * 1500);
      data[i] = (sin(2 * pi * freq * t) * envelope * 0.4).clamp(-1.0, 1.0);
    }
    
    return data;
  }
  
  static Float32List generateMove() {
    final duration = 0.08;
    final samples = (sampleRate * duration).toInt();
    final data = Float32List(samples);
    
    for (int i = 0; i < samples; i++) {
      final t = i / sampleRate;
      final envelope = 1.0 - (i / samples);
      final freq = 150;
      data[i] = (sin(2 * pi * freq * t) * envelope * 0.2).clamp(-1.0, 1.0);
    }
    
    return data;
  }
}