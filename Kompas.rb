module Script_Kompas
  Tujuan = [nil, nil]
  
  def self.ganti_tujuan(x, y)
    Tujuan[0] = x
    Tujuan[1] = y
  end
end

class Window_MenuCommand < Window_Command
  def add_original_commands
    add_command("-> Kompas <-", :kompas)
  end
end

class Scene_Menu < Scene_MenuBase
  alias create_command_window_ScriptKompas create_command_window
  def create_command_window
    create_command_window_ScriptKompas
    @command_window.set_handler(:kompas, method(:buka_kompas))
  end
  
  def buka_kompas
    SceneManager.call(Scene_Kompas)
  end
end

class Scene_Kompas < Scene_MenuBase
  def start
    super
    buat_tampilan_kompas
  end
  
  def buat_tampilan_kompas
    @kotak = Sprite.new
    @kotak.bitmap = buat_sketsa_kompas
  end
  
  def buat_sketsa_kompas
    gambar = Bitmap.new(300, 300)
    
    gambar.fill_rect(0, 0, 300, 300, Color.new(255, 0, 0))
    gambar.clear_rect(2, 2, 296, 296)
    
    start = [$game_player.x, $game_player.y]
    tujuan = Script_Kompas::Tujuan
    
    if [*start, *tujuan].any? { |i| i.nil? }
      gambar.draw_text(20, 20, 260, 24, "Tidak bisa membuat kompas")
      return gambar
    end
    
    jx = tujuan[0] - start[0]
    jy = tujuan[1] - start[1]
    mx = my = 0
    gx = gy = 0
    warna = Color.new(255, 0, 0)
    
    if [jx, jy].any? { |i| i == 0 }
      if jx == 0 && jy == 0
        gambar.fill_rect(145, 145, 10, 10, warna)
        return gambar
      elsif jx == 0 && jy > 0
        gambar.fill_rect(145, 150, 10, 130, warna)
        return gambar
      elsif jx == 0 && jy < 0
        gambar.fill_rect(145, 20, 10, 130, warna)
        return gambar
      elsif jy == 0 && jx > 0
        gambar.fill_rect(150, 145, 130, 10, warna)
        return gambar
      elsif jy == 0 && jx < 0
        gambar.fill_rect(20, 145, 130, 10, warna)
        return gambar
      end
    elsif jx.abs == jy.abs
      if jx > 0 && jy < 0
        gx = 1
        gy = -1
        mx = 150
        my = 140
      elsif jx > 0 && jy > 0
        gx = 1
        gy = 1
        mx = 150
        my = 150
      elsif jx < 0 && jy > 0
        gx = -1
        gy = 1
        mx = 140
        my = 150
      else
        gx = -1
        gy = -1
        mx = 140
        my = 140
      end
    elsif jx.abs > jy.abs
      gx = 1
      gy = jy.abs.to_f / jx.abs.to_f
      if jx > 0 && jy < 0
        gx *= 1
        gy *= -1
        mx = 150
        my = 140
      elsif jx > 0 && jy > 0
        gx *= 1
        gy *= 1
        mx = 150
        my = 150
      elsif jx < 0 && jy > 0
        gx *= -1
        gy *= 1
        mx = 140
        my = 150
      else
        gx *= -1
        gy *= -1
        mx = 140
        my = 140
      end
    elsif jy.abs > jx.abs
      gx = jx.abs.to_f / jy.abs.to_f
      gy = 1
      if jx > 0 && jy < 0
        gx *= 1
        gy *= -1
        mx = 150
        my = 140
      elsif jx > 0 && jy > 0
        gx *= 1
        gy *= 1
        mx = 150
        my = 150
      elsif jx < 0 && jy > 0
        gx *= -1
        gy *= 1
        mx = 140
        my = 150
      else
        gx *= -1
        gy *= -1
        mx = 140
        my = 140
      end
    else
      gambar.draw_text(20, 20, 200, 24, "Tidak bisa membuat kompas")
      return gambar
    end
    
    13.times do
      gambar.fill_rect(mx, my, 10, 10, warna)
      mx += gx * 10
      my += gy * 10
    end
    
    return gambar
  end
  
  def update
    super
    return_scene if Input.trigger?(:B)
  end
end

class Game_Interpreter
  def ganti_tujuan_ScriptKompas(x, y)
    Script_Kompas.ganti_tujuan(x, y)
  end
end