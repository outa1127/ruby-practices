# frozen_string_literal: true

require 'etc'

# Iremクラスでは各ファイルのサイズや作成日等を返す

class Item
  attr_reader :name

  def initialize(name)
    @name = name

    @stat = File.stat(name)
  end

  def calculate_blocks
    File.stat(name).blocks
  end

  def file_type
    @stat.ftype
  end

  def exec_permission
    @stat.mode.to_s(8).rjust(6, '0')[3..]
  end

  def sticky?
    @stat.sticky?
  end

  def set_uid?
    @stat.setuid?
  end

  def set_gid?
    @stat.setgid?
  end

  def count_link
    @stat.nlink
  end

  def owner_name
    Etc.getpwuid(@stat.uid).name
  end

  def group_name
    Etc.getgrgid(@stat.gid).name
  end

  def file_size
    @stat.size
  end

  def last_updated_time
    @stat.mtime
  end
end
