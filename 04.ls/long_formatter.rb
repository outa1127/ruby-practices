# frozen_string_literal: true

require_relative 'item'

class LongFormatter
  OWNER_INDEX = 0
  GROUP_INDEX = 1
  OTHERS_INDEX = 2
  EXEC_PERMISSION_INDEX = 2
  TYPE_LIST = {
    fifo: 'p',
    characterSpecial: 'c',
    directory: 'd',
    blockSpecial: 'b',
    file: '-',
    link: 'l',
    socket: 's'
  }.freeze
  PERMISSION_LIST = ['---', '--x', '-w-', '-wx', 'r--', 'r-x', 'rw-', 'rwx'].freeze

  def initialize(items)
    # @items = items
    @items = items.map do |item|
      Item.new(item)
    end
  end

  def format
    output_total_block_size
    to_long_format
  end

  def output_total_block_size
    puts "total #{@items.sum(&:calculate_blocks)}"
  end

  def to_long_format
    lines = []
    @items.each do |item|
      permission = TYPE_LIST[item.file_type.to_sym] +
                   format_exec_permission(item.exec_permission, item.sticky?, item.set_uid?, item.set_gid?)
      lines << [
        permission,
        item.count_link.to_s.rjust(2),
        item.owner_name,
        " #{item.group_name}",
        " #{item.file_size.to_s.rjust(4)}",
        " #{format_last_updated_time(item.last_updated_time)}",
        item.name
      ].join(' ')
    end
    puts lines
  end

  private

  def format_exec_permission(exec_permission, sticky_flag, set_user_id_flag, set_group_id_flag)
    perms = exec_permission.each_char.map { |d| PERMISSION_LIST[d.to_i].dup }
    special_perms = [
      [set_user_id_flag, OWNER_INDEX, 's', 'S'],
      [set_group_id_flag, GROUP_INDEX, 's', 'S'],
      [sticky_flag, OTHERS_INDEX, 't', 'T']
    ]
    special_perms.each do |flag, target_index, exec_char, noexec_char|
      next unless flag

      perms[target_index][EXEC_PERMISSION_INDEX] = perms[target_index][EXEC_PERMISSION_INDEX] == 'x' ? exec_char : noexec_char
    end
    perms.join
  end

  def format_last_updated_time(last_updated_time)
    last_updated_time.strftime('%-m %d %H:%M')
  end
end
