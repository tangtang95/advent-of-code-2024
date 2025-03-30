const std = @import("std");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    var args = std.process.args();
    _ = args.skip();
    const filepath = args.next().?;
    const file = try std.fs.cwd().openFile(filepath, .{});
    defer file.close();

    var matrix: [1024][1024]u8 = undefined;
    const reader = file.reader();
    var buffer = std.ArrayList(u8).init(alloc);
    defer buffer.deinit();

    var i: usize = 0;
    var width: usize = undefined;
    while (reader.streamUntilDelimiter(buffer.writer(), '\n', null)) : (i += 1) {
        defer buffer.clearRetainingCapacity();
        width = buffer.items.len;
        @memcpy(matrix[i][0..buffer.items.len], buffer.items[0..buffer.items.len]);
    } else |_| {}
    const height = i;
    std.debug.print("width: {}, height: {}", .{width, height});
}

