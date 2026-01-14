const std = @import("std");
const fs = std.fs;

// TODO
// add optional cmd line flags
// add multithread support

pub fn main() !void {
    // TODO add cmd line args to pass file name
    // var file: fs.File = try fs.cwd().openFile("file.dat", .{});
    var file: fs.File = try fs.openSelfExe(.{});
    defer file.close();

    var buf = std.mem.zeroes([4096]u8);
    var reader = file.reader(&buf);

    // TODO figure out proper way to read pieces of the file wihtout skipping first piece
    const n = try reader.interface.readSliceShort(&buf);
    std.debug.print("{d} bytes\n", .{n});

    // TODO check if adjacent output lines are identical and omit replicas
    var line_byte_count: u32 = 0;
    var bytes_in_line: u8 = 0;
    var bytes_in_sequence: u8 = 0;

    var i: usize = 0;
    while (i < n) : (i += 1) {
        if (bytes_in_line == 0) {
            std.debug.print("{X:0>7} ", .{line_byte_count});
        }
        std.debug.print("{X:0>2}", .{buf[i]});

        bytes_in_line += 1;
        bytes_in_sequence += 1;

        if (bytes_in_sequence == 2) {
            bytes_in_sequence = 0;
            std.debug.print(" ", .{});
        }
        if (bytes_in_line == 16) {
            bytes_in_line = 0;
            line_byte_count += 16;
            std.debug.print("\n", .{});
        }
    }
}
