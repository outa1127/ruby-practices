# frozen_string_literal: true

require 'optparse'
require 'etc'

def formatting_contents(dir_contents)
  cols = 3
  rows = dir_contents.length >= 1 ? (dir_contents.size.to_f / cols).ceil : 0 # 5
  sliced_contents = dir_contents.each_slice(rows).to_a

  indexed_contents = Array.new(rows) do |row|
    Array.new(cols) do |col|
      sliced_contents[col][row]
    end
  end

  formatted_contents = indexed_contents.map do |index_content|
    index_content.compact.map do |element|
      element.ljust(15)
    end.join
  end
  puts formatted_contents
end

flags = 0
reverse_sort = false

def l_option
  total_block_size = 0
  calculation_block_size(total_block_size, Dir.glob('*'))
  contents = Dir.glob('*')
  contents.each do |content|
    file_detail =  File.stat(content)
    sickey_flag = file_detail.sticky?
    set_user_id_flag = file_detail.setuid?
    set_group_id_flag = file_detail.setgid?

    print permission_file_type(file_detail.ftype)
    print print_permission(file_detail.mode.to_s(8).rjust(6, '0')[3..], sickey_flag, set_user_id_flag, set_group_id_flag)
    print " #{file_detail.nlink}"
    print " #{Etc.getpwuid(file_detail.uid).name}"
    print " #{Etc.getgrgid(file_detail.gid).name}"
    print " #{file_detail.size.to_s.rjust(4, ' ')}"
    print " #{formatting_last_update_date(file_detail.mtime)}"
    print " #{content}"
    puts
  end
end

def calculation_block_size(total_block_size, contents)
  contents.each do |content|
    content_block_size = File.stat(content).blocks
    total_block_size += content_block_size
  end
  puts "total #{total_block_size}"
end

def permission_file_type(file)
  file_type = {
    'fifo' => 'p',
    'characterSpecial' => 'c',
    'directory' => 'd',
    'blockSpecial' => 'b',
    'file' => '-',
    'link' => 'l',
    'socket' => 's'
  }
  file_type[file]
end

def print_permission(permission, sickey_flag, set_user_id_flag, set_group_id_flag)
  owner_index = 0
  group_index = 1
  others_index = 2
  exec_permission_index = 2

  permission_array = ['---', '--x', '-w-', '-wx', 'r--', 'r-x', 'rw-', 'rwx']
  perms = permission.each_char.map { |d| permission_array[d.to_i].dup }
  if sickey_flag
    perms[others_index][exec_permission_index] = perms[others_index][exec_permission_index] == 'x' ? 't' : 'T'
  end
  if set_user_id_flag
    perms[owner_index][exec_permission_index] = perms[owner_index][exec_permission_index] == 'x' ? 's' : 'S'
  end
  if set_group_id_flag
    perms[group_index][exec_permission_index] = perms[group_index][exec_permission_index] == 'x' ? 's' : 'S'
  end
  perms.join
end

def formatting_last_update_date(last_updated_time)
  last_updated_time.strftime('%-m %d %H:%M')
end

OptionParser.new do |opt|
  opt.on('-a') { flags |= File::FNM_DOTMATCH }
  opt.on('-r') { reverse_sort = true }
  opt.on('-l') { l_option }
  opt.parse!(ARGV)
end

sorted_contents = Dir.glob('*', flags).sort
sorted_contents.reverse! if reverse_sort

# formatting_contents(sorted_contents)
