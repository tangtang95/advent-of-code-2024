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

    const buffer = try file.readToEndAlloc(alloc, 1024 * 1024);
    var parser = Parser{ .buffer = buffer };
    var sum: i32 = 0;
    while (true) {
        const mul = parser.parse() catch |err| {
            switch (err) {
                ParserError.EndOfBuffer => {
                    break;
                },
                else => {
                    continue;
                },
            }
        };
        sum += mul;
    }

    std.debug.print("Sum of multiplication is: {}", .{sum});
}

const ParserError = error{ EndOfBuffer, WrongChar };

const Parser = struct {
    buffer: []u8,
    idx: usize = 0,
    mul_enable: bool = true,

    fn peek(self: *Parser) ?u8 {
        if (self.idx >= self.buffer.len) {
            return null;
        }

        return self.buffer[self.idx];
    }

    fn next(self: *Parser) ?u8 {
        if (self.idx >= self.buffer.len) {
            return null;
        }

        const byte = self.buffer[self.idx];
        self.idx += 1;
        return byte;
    }

    fn parse(self: *Parser) !i32 {
        const byte = self.peek();
        if (byte) |b| {
            if (b == 'm') {
                return self.parse_mul();
            } else if (b == 'd') {
                return self.parse_dos();
            } else {
                _ = self.next();
                return 0;
            }
        }
        return ParserError.EndOfBuffer;
    }

    fn parse_dos(self: *Parser) !i32 {
        try self.char('d');
        try self.char('o');
        const byte = self.peek();
        if (byte) |b| {
            if (b == '(') {
                try self.char('(');
                try self.char(')');
                self.mul_enable = true;
            } else if (b == 'n') {
                try self.char('n');
                try self.char('\'');
                try self.char('t');
                try self.char('(');
                try self.char(')');
                self.mul_enable = false;
            }
        }
        return 0;
    }

    fn parse_mul(self: *Parser) !i32 {
        try self.char('m');
        try self.char('u');
        try self.char('l');
        try self.char('(');
        const left = try self.number();
        try self.char(',');
        const right = try self.number();
        try self.char(')');

        if (self.mul_enable) {
            return left * right;
        } else {
            return 0;
        }
    }

    fn char(self: *Parser, comptime c: u8) !void {
        const byte = self.peek();
        if (byte) |b| {
            if (b == c) {
                _ = self.next();
                return;
            } else {
                return ParserError.WrongChar;
            }
        }
        return ParserError.EndOfBuffer;
    }

    fn number(self: *Parser) !i32 {
        var number_bytes: [20]u8 = undefined;
        var i: usize = 0;
        while (i < 20) : (i += 1) {
            const byte = self.peek();
            if (byte) |b| {
                if (std.ascii.isDigit(b)) {
                    number_bytes[i] = b;
                    _ = self.next();
                } else {
                    break;
                }
            } else {
                break;
            }
        }
        return std.fmt.parseInt(i32, number_bytes[0..i], 10);
    }
};
