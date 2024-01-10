const std = @import("std");
const mem = std.mem;
const print = std.debug.print;
const parseInt = std.fmt.parseInt;
const expectEquals = std.testing.expectEqual;

fn isDigit(c: u8) bool {
    return c >= '0' and c <= '9';
}
fn isWhiteSpace(c: u8) bool {
    return c == ' ';
}

const Type = enum { red, green, blue };
const ReadValueResults = struct { value: u32, type: Type };

fn readValue(s: []const u8) !ReadValueResults {
    var i: usize = 0;
    while (i < s.len and isWhiteSpace(s[i])) {
        i += 1;
    }

    var j: usize = i;
    while (j < s.len and isDigit(s[j])) {
        j += 1;
    }
    var value = try parseInt(u32, s[i..j], 10);

    var t: Type = undefined;
    while (j < s.len and isWhiteSpace(s[j])) {
        j += 1;
    }
    switch (s[j]) {
        'r' => t = Type.red,
        'g' => t = Type.green,
        'b' => t = Type.blue,
        else => unreachable,
    }

    return .{ .value = value, .type = t };
}

pub fn processLine2(line: []const u8) !?u32 {
    var tokens = mem.splitAny(u8, line, ":;");

    // get id
    var game = tokens.next().?;
    _ = game;

    // values
    var minr: u32 = 0;
    var ming: u32 = 0;
    var minb: u32 = 0;
    while (tokens.next()) |row| {
        var valueit = mem.splitSequence(u8, row, ", ");
        while (valueit.next()) |val| {
            var r = try readValue(val);
            switch (r.type) {
                Type.red => minr = @max(minr, r.value),
                Type.green => ming = @max(ming, r.value),
                Type.blue => minb = @max(minb, r.value),
            }
        }
    }
    return minr * ming * minb;
}

pub fn processLine(line: []const u8) !?u32 {
    var tokens = mem.splitAny(u8, line, ":;");

    // get id
    var game = tokens.next().?;
    var i = game.len;
    while (i > 0) {
        if (!isDigit(game[i - 1])) break;
        i -= 1;
    }
    var id = try parseInt(u32, game[i..], 10);

    // values
    var valid = true;
    while (tokens.next()) |row| {
        var valueit = mem.splitSequence(u8, row, ", ");
        while (valueit.next()) |val| {
            var r = try readValue(val);
            switch (r.type) {
                Type.red => valid = r.value <= 12,
                Type.green => valid = r.value <= 13,
                Type.blue => valid = r.value <= 14,
            }
            if (!valid) break;
        }
        if (!valid) break;
    }

    if (!valid) {
        return null;
    }
    return id;
}

pub fn main() !void {
    var content = @embedFile("./data.txt");
    var it = mem.tokenizeScalar(u8, content, '\n');
    var res: u32 = 0;
    while (it.next()) |line| {
        if (try processLine2(line)) |r| {
            res += r;
        }
    }
    print("{}", .{res});
}

test "1" {
    var line: []const u8 = "Game 89: 11 red, 1 blue, 2 green; 6 blue, 5 green, 4 red; 15 red, 4 green, 5 blue; 11 red, 3 blue, 10 green; 6 blue, 13 green, 12 red";
    try expectEquals(try processLine(line), null);
}

test "2" {
    var line = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green";
    try expectEquals(try processLine2(line), 48);
}
