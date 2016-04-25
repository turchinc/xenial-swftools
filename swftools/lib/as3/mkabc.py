#!/usr/bin/python
#
# mkops.py
#
# Generate opcodes.h, opcodes.h
#
# Copyright (c) 2008 Matthias Kramm <kramm@quiss.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA */

import re

fi = open("code.c", "rb")
foc = open("opcodes.c", "wb")
foh = open("opcodes.h", "wb")

foh.write("#ifndef __opcodes_h__\n")
foh.write("#define __opcodes_h__\n")
foh.write("#include \"abc.h\"\n")
foh.write("#include \"pool.h\"\n")
foh.write("#include \"code.h\"\n")

foc.write("#include \"opcodes.h\"\n")

R = re.compile('{(0x..),\s*"([^"]*)"\s*,\s*"([^"]*)"[^}]*}\s*')

for line in fi.readlines():
    line = line.strip()
    m = R.match(line)
    if m:
        op,name,params = m.group(1),m.group(2),m.group(3)

        iterations=1
        if "2" in params or "s" in params:
            iterations=2

        for iteration in range(iterations):
            if iteration==1:
                name=name+"2"
            params = params.strip()
            paramstr = ""
            seen = {}
            names = []

            for c in params:
                paramstr += ", "
                if c == "2":
                    if iteration==0:
                        type,pname="char*","name"
                    else:
                        type,pname="multiname_t*","name"
                elif c == "s":
                    if iteration==0:
                        type,pname="char*","name"
                    else:
                        type,pname="string_t*","s"
                elif c == "N":
                    type,pname="namespace_t*","ns"
                elif c in "nubs":
                    type,pname="int","v"
                elif c == "m":
                    type,pname="abc_method_t*","m"
                elif c == "i":
                    type,pname="abc_method_body_t*","m"
                elif c == "c":
                    type,pname="abc_class_t*","m"
                elif c == "j":
                    type,pname="code_t*","label"
                elif c == "S":
                    type,pname="lookupswitch_t*","l"
                elif c == "D":
                    type,pname="void*","debuginfo"
                elif c == "r":
                    type,pname="int","reg"
                elif c == "f":
                    type,pname="double","f"
                elif c == "I":
                    type,pname="int","i"
                elif c == "U":
                    type,pname="unsigned int","u"
                else:
                    raise "Unknown type "+c
                paramstr += type
                paramstr += " "
                if pname in seen:
                    seen[pname]+=1
                    pname += str(seen[pname])
                else:
                    seen[pname]=1
                paramstr += pname
                names += [pname]

            foh.write("code_t* abc_%s(code_t*prev%s);\n" % (name, paramstr))

            foc.write("code_t* abc_%s(code_t*prev%s)\n" % (name, paramstr))
            foc.write("{\n")
            foc.write("    code_t*self = add_opcode(prev, %s);\n" % op)
            i = 0
            for pname,c in zip(names,params):
                if(c == "2"):
                    if iteration==0:
                     foc.write("    self->data[%d] = multiname_fromstring(%s);\n" % (i,pname));
                    else:
                     foc.write("    self->data[%d] = multiname_clone(%s);\n" % (i,pname));
                elif(c in "nur"):
                    foc.write("    self->data[%d] = (void*)(ptroff_t)%s;\n" % (i,pname))
                elif(c in "IU"):
                    foc.write("    self->data[%d] = (void*)(ptroff_t)%s;\n" % (i,pname))
                elif(c in "N"):
                    foc.write("    self->data[%d] = namespace_clone(%s);\n" % (i,pname))
                elif(c in "f"):
                    foc.write("    double*fp = malloc(sizeof(double));\n")
                    foc.write("    *fp = %s;\n" % (pname))
                    foc.write("    self->data[%d] = fp;\n" % (i))
                elif(c == "b"):
                    foc.write("    self->data[%d] = (void*)(ptroff_t)%s;\n" % (i,pname))
                elif(c == "s"):
                    if iteration==0:
                        foc.write("    self->data[%d] = string_new4(%s);\n" % (i,pname))
                    else:
                        foc.write("    self->data[%d] = string_dup3(%s);\n" % (i,pname))
                elif(c == "m"):
                    foc.write("    self->data[%d] = %s;\n" % (i,pname))
                elif(c == "c"):
                    foc.write("    self->data[%d] = %s;\n" % (i,pname))
                elif(c == "i"):
                    foc.write("    self->data[%d] = %s;\n" % (i,pname))
                elif(c == "j"):
                    foc.write("    self->data[%d] = 0; //placeholder\n" % i)
                    foc.write("    self->branch = %s;\n" % pname)
                elif(c == "S"):
                    foc.write("    self->data[%d] = %s;\n" % (i,pname))
                elif(c == "D"):
                    foc.write("    /* FIXME: write debuginfo %s */\n" % pname)
                else:
                    raise "Unknown type "+c
                i = i+1
            foc.write("    return self;\n")
            foc.write("}\n")

            foh.write("#define "+name+"(")
            foh.write(",".join(["method"]+names))
            foh.write(") (method->code = abc_"+name+"(")
            foh.write(",".join(["method->code"]+names))
            foh.write("))\n")

            foh.write("#define OPCODE_"+name.upper()+" "+op+"\n")

foh.write("#endif\n")

foh.close()
foc.close()
fi.close()
#{0x75, "convert_d", ""},

