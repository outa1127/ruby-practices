# frozen_string_literal: true

require_relative 'item'

class Line
  OWNER_INDEX = 0
  GROUP_INDEX = 1
  OTHERS_INDEX = 2
  EXEC_PERMISSION_INDEX = 2

  attr_reader :files

  def initialize(files)
    @files = files

    @items = @files.map do |file|
      Item.new(file)
    end
  end

  def formatting_long
    lines = []
    block_sizes = @items.map(&:calculate_blocks)
    lines << "total #{block_sizes.sum}"

    @items.each do |item|
      permission = permission_file_type(item.file_type.to_sym) +
                   formatting_exec_permission(item.exec_permission, item.sticky?, item.set_uid?, item.set_gid?)

      lines << [
        permission,
        item.count_link.to_s.rjust(2),
        item.owner_name,
        " #{item.group_name}",
        " #{item.file_size.to_s.rjust(4)}",
        " #{formatting_last_updated_time(item.last_updated_time)}",
        item.name
      ].join(' ')
    end

    lines
  end

  def formatting_row(width)
    formatted_row = @files.map do |file|
      file.ljust(width + 2)
    end
    formatted_row.join
  end

  private

  def permission_file_type(file_type)
    type_list = {
      fifo: 'p',
      characterSpecial: 'c',
      directory: 'd',
      blockSpecial: 'b',
      file: '-',
      link: 'l',
      socket: 's'
    }
    type_list[file_type]
  end

  def formatting_exec_permission(exec_permission, sticky_flag, set_user_id_flag, set_group_id_flag)
    permission_list = ['---', '--x', '-w-', '-wx', 'r--', 'r-x', 'rw-', 'rwx']
    perms = exec_permission.each_char.map { |d| permission_list[d.to_i].dup }
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

  def formatting_last_updated_time(last_updated_time)
    last_updated_time.strftime('%-m %d %H:%M')
  end
end
