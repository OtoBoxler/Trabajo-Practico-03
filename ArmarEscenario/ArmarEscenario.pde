import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
AudioPlayer SonidoTanque;
AudioPlayer audio;
PImage tanque, bala, fondo, rehen, persona, enemigo;
float EnemigoX = 0, EnemigoVel = 2;
int direccion = 1, puntaje;
float tanqueX, tanqueY;
ArrayList<Bala> balas = new ArrayList<Bala>();

void setup() {
  size(800, 500);
  minim = new Minim (this);
  audio = minim.loadFile("audio.mp3", 2048);
  audio.loop();
  SonidoTanque = minim.loadFile("SonidoTanque.mp3", 2048);
  SonidoTanque.loop();
  enemigo = loadImage("enemigo.png");
  tanque = loadImage("tanque.png");
  bala = loadImage("bala.png");
  fondo = loadImage("fondo.jpg");
  rehen = loadImage("reen.png");
  persona = loadImage("personaje.png");
  tanqueX = width / 2;
  tanqueY = 400;
}
void draw() {
  background(255);
  image(fondo, 400, 250);
  imageMode(CENTER);
  image(tanque, tanqueX, tanqueY);
  image(rehen, 780, height/2);
  image(persona, 40, height/2*0.65);
  puntaje();
  if (keyPressed) {
    if (key == 'a' || key == 'A') {
      tanqueX -= 5;
    } else if (key == 'd' || key == 'D') {
      tanqueX += 5;
    }
  }

  // Dibujar y mover las balas
  for (int i = balas.size() - 1; i >= 0; i--) {
    Bala b = balas.get(i);
    b.mostrar();
    b.mover();

    // Detectar colisión con el enemigo
    if (b.y < 50 + enemigo.height / 2 && b.x > EnemigoX - enemigo.width / 2 && b.x < EnemigoX + enemigo.width / 2) {
      // Si hay colisión, suma 1 al puntaje y elimina la bala
      balas.remove(i);
      // Incrementa el puntaje
      puntaje++;
      // Reinicia la posición del enemigo
      EnemigoX = random(enemigo.width / 2, width - enemigo.width / 2);
    }

    // Si la bala sale de la pantalla, eliminarla
    if (b.y < 0) {
      balas.remove(i);
    }
  }

  // Dibujar enemigo
  image(enemigo, EnemigoX, 50);
  EnemigoX += EnemigoVel * direccion;
  if (EnemigoX >= width - enemigo.width / 2 || EnemigoX <= enemigo.width / 2) {
    direccion *= -1;
  }
  tanqueX = constrain(tanqueX, tanque.width / 2, width - tanque.width / 2);
}
void keyPressed() {
  if (key == ' ') {
    balas.add(new Bala(tanqueX, tanqueY));
  }
  if (key == 'p' || key == 'P') {
    // Reproduce el archivo de audio
    audio.play();
    SonidoTanque.play();
  }
}

class Bala {
  float x;
  float y;
  float velocidad;

  Bala(float x, float y) {
    this.x = x;
    this.y = y;
    this.velocidad = 10;
  }

  void mostrar() {
    imageMode(CENTER);
    image(bala, x, y);
  }

  void mover() {
    y -= velocidad;
  }
}
void puntaje() {
  fill(0);
  textSize(20);
  textAlign(RIGHT);
  text("Puntaje: " + puntaje, width - 20, 30);
}
