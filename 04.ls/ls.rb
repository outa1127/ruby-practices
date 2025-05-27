# frozen_string_literal: true

require 'optparse'
require 'etc'

OWNER_INDEX = 0
GROUP_INDEX = 1
OTHERS_INDEX = 2
EXEC_PERMISSION_INDEX = 2

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

def formatting_detaild_contents(contents)
  calculation_block_size(contents)

  contents.each do |content|
    file_detail = File.stat(content)
    permission =  permission_file_type(file_detail.ftype.to_sym) +
                  exec_permission(file_detail.mode.to_s(8).rjust(6, '0')[3..], file_detail.sticky?, file_detail.setuid?, file_detail.setgid?)
    puts [
      permission,
      file_detail.nlink.to_s.rjust(2, ' '),
      Etc.getpwuid(file_detail.uid).name,
      Etc.getgrgid(file_detail.gid).name,
      file_detail.size.to_s.rjust(4, ' '),
      formatting_last_update_date(file_detail.mtime),
      content
    ].join(' ')
  end
end

def calculation_block_size(contents)
  block_sizes = contents.map { |content| File.stat(content).blocks }
  total_block_size = block_sizes.sum
  puts "total #{total_block_size}"
end

def permission_file_type(file)
  file_type = {
    fifo: 'p',
    characterSpecial: 'c',
    directory: 'd',
    blockSpecial: 'b',
    file: '-',
    link: 'l',
    socket: 's'
  }
  file_type[file]
end

def exec_permission(permission, sticky_flag, set_user_id_flag, set_group_id_flag)
  permission_array = ['---', '--x', '-w-', '-wx', 'r--', 'r-x', 'rw-', 'rwx']
  perms = permission.each_char.map { |d| permission_array[d.to_i].dup }
  special_perms = [
    [sticky_flag, OWNER_INDEX, 't', 'T'],
    [set_user_id_flag, OTHERS_INDEX, 's', 'S'],
    [set_group_id_flag, GROUP_INDEX, 's', 'S']
  ]
  special_perms.each do |flag, target_index, exec_char, noexec_char|
    next unless flag

    perms[target_index][EXEC_PERMISSION_INDEX] = perms[target_index][EXEC_PERMISSION_INDEX] == 'x' ? exec_char : noexec_char
  end

  perms.join
end

def formatting_last_update_date(last_updated_time)
  last_updated_time.strftime('%-m %d %H:%M')
end

flags = 0
reverse_sort = false
detaild_contents_flag = false

OptionParser.new do |opt|
  opt.on('-a') { flags |= File::FNM_DOTMATCH }
  opt.on('-r') { reverse_sort = true }
  opt.on('-l') { detaild_contents_flag = true }
  opt.parse!(ARGV)
end

sorted_contents = Dir.glob('*', flags).sort
sorted_contents.reverse! if reverse_sort

if detaild_contents_flag
  formatting_detaild_contents(sorted_contents)
else
  formatting_contents(sorted_contents)
end
