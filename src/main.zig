const std = @import("std");
const fs = std.fs;

// TODO
// add optional cmd line flags
// add multithread support
// check if adjacent output lines are identical and omit replicas

pub fn main() !void {
    // TODO add cmd line args to pass file name
    var file: fs.File = try fs.cwd().openFile("file.dat", .{});
    // var file: fs.File = try fs.openSelfExe(.{});
    defer file.close();

    var reader_buffer = std.mem.zeroes([6]u8);
    var line_buffer = std.mem.zeroes([4]u8);
    var reader = file.reader(&reader_buffer);

    var line_byte_count: u32 = 0;
    var bytes_in_line: u8 = 0;
    var bytes_in_sequence: u8 = 0;

    // TODO refactor code to print a whole line all at once
    while (true) {
        const n = try reader.interface.readSliceShort(&line_buffer);
        var i: usize = 0;
        while (i < n) : (i += 1) {
            if (bytes_in_line == 0) {
                std.debug.print("{X:0>7} ", .{line_byte_count});
            }
            std.debug.print("{X:0>2}", .{line_buffer[i]});
            // // print byte as ascii if it's a regular printable character
            // if (line_buffer[i] >= '!' and line_buffer[i] <= '~') {
            //     std.debug.print("{c}", .{line_buffer[i]});
            // }
            // else {
            //     std.debug.print(".", .{});
            // }

            bytes_in_line += 1;
            bytes_in_sequence += 1;

            if (bytes_in_sequence == 2) {
                bytes_in_sequence = 0;
                std.debug.print(" ", .{});
            }
            if (bytes_in_line == 8) {
                std.debug.print(" ", .{});
            }
            if (bytes_in_line == 16) {
                bytes_in_line = 0;
                line_byte_count += 16;
                std.debug.print("\n", .{});
            }
        }

        const eof = reader.atEnd();
        if (eof) {
            break;
        }
    }
}
