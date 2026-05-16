; ModuleID = '/home/users/sislam3/SBAC-PAD/results/underflow/rounding/instrumented_device.bc'
source_filename = "tests/basic_tests/underflow/rounding.cu"
target datalayout = "e-p6:32:32-i64:64-i128:128-i256:256-v16:16-v32:32-n16:32:64"
target triple = "nvptx64-nvidia-cuda"

%struct.__cuda_builtin_threadIdx_t = type { i8 }

@threadIdx = extern_weak dso_local addrspace(1) global %struct.__cuda_builtin_threadIdx_t, align 1
@.str = private unnamed_addr constant [11 x i8] c"__CUDA_FTZ\00", align 1
@fp_invalid_counter = addrspace(1) global i64 0, align 8
@fp_divbyzero_counter = addrspace(1) global i64 0, align 8
@fp_overflow_counter = addrspace(1) global i64 0, align 8
@fp_underflow_counter = addrspace(1) global i64 0, align 8
@fp_total_counter = addrspace(1) global i64 0, align 8
@fp_subnormal_counter = addrspace(1) global i64 0, align 8

; Function Attrs: convergent noinline nounwind optnone
define dso_local noundef zeroext i1 @_Z12is_subnormalf(float noundef %x) #0 !dbg !963 {
entry:
  %__a.addr.i = alloca float, align 4
  %x.addr = alloca float, align 4
  store float %x, ptr %x.addr, align 4
    #dbg_declare(ptr %x.addr, !964, !DIExpression(), !965)
  %0 = load float, ptr %x.addr, align 4, !dbg !966
  %cmp = fcmp contract une float %0, 0.000000e+00, !dbg !967
  br i1 %cmp, label %land.rhs, label %land.end, !dbg !968

land.rhs:                                         ; preds = %entry
  %1 = load float, ptr %x.addr, align 4, !dbg !969
  store float %1, ptr %__a.addr.i, align 4
    #dbg_declare(ptr %__a.addr.i, !970, !DIExpression(), !971)
  %2 = load float, ptr %__a.addr.i, align 4, !dbg !973
  %3 = call float @llvm.nvvm.fabs.f32(float %2), !dbg !974
  %cmp1 = fcmp contract olt float %3, 0x3810000000000000, !dbg !975
  br label %land.end

land.end:                                         ; preds = %land.rhs, %entry
  %4 = phi i1 [ false, %entry ], [ %cmp1, %land.rhs ], !dbg !976
  ret i1 %4, !dbg !977
}

; Function Attrs: convergent noinline norecurse nounwind optnone
define dso_local ptx_kernel void @_Z26testUnderflow_RoundNearestPfPi(ptr noundef %result, ptr noundef %is_denormal) #1 !dbg !978 {
entry:
  %__a.addr.i50 = alloca float, align 4
  %__b.addr.i51 = alloca float, align 4
  %__c.addr.i = alloca float, align 4
  %__a.addr.i47 = alloca float, align 4
  %__b.addr.i48 = alloca float, align 4
  %__a.addr.i44 = alloca float, align 4
  %__b.addr.i45 = alloca float, align 4
  %__a.addr.i41 = alloca float, align 4
  %__b.addr.i42 = alloca float, align 4
  %__a.addr.i = alloca float, align 4
  %__b.addr.i = alloca float, align 4
  %result.addr = alloca ptr, align 8
  %is_denormal.addr = alloca ptr, align 8
  %idx = alloca i32, align 4
  %tiny = alloca float, align 4
  %a = alloca float, align 4
  %b = alloca float, align 4
  store ptr %result, ptr %result.addr, align 8
    #dbg_declare(ptr %result.addr, !981, !DIExpression(), !982)
  store ptr %is_denormal, ptr %is_denormal.addr, align 8
    #dbg_declare(ptr %is_denormal.addr, !983, !DIExpression(), !984)
    #dbg_declare(ptr %idx, !985, !DIExpression(), !986)
  %0 = call noundef i32 @llvm.nvvm.read.ptx.sreg.tid.x(), !dbg !987
  store i32 %0, ptr %idx, align 4, !dbg !986
    #dbg_declare(ptr %tiny, !990, !DIExpression(), !991)
  store float 0x3810000000000000, ptr %tiny, align 4, !dbg !991
  %1 = load i32, ptr %idx, align 4, !dbg !992
  %cmp = icmp eq i32 %1, 0, !dbg !994
  br i1 %cmp, label %if.then, label %if.end, !dbg !994

if.then:                                          ; preds = %entry
  %2 = load float, ptr %tiny, align 4, !dbg !995
  store float %2, ptr %__a.addr.i, align 4
    #dbg_declare(ptr %__a.addr.i, !997, !DIExpression(), !1000)
  store float 2.000000e+00, ptr %__b.addr.i, align 4
    #dbg_declare(ptr %__b.addr.i, !1002, !DIExpression(), !1003)
  %3 = load float, ptr %__a.addr.i, align 4, !dbg !1004
  %4 = load float, ptr %__b.addr.i, align 4, !dbg !1005
  %5 = call float @llvm.nvvm.div.rn.f(float %3, float %4), !dbg !1006
  %6 = load ptr, ptr %result.addr, align 8, !dbg !1007
  %arrayidx = getelementptr inbounds float, ptr %6, i64 0, !dbg !1007
  store float %5, ptr %arrayidx, align 4, !dbg !1008
  %7 = load ptr, ptr %result.addr, align 8, !dbg !1009
  %arrayidx2 = getelementptr inbounds float, ptr %7, i64 0, !dbg !1009
  %8 = load float, ptr %arrayidx2, align 4, !dbg !1009
  %call3 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %8) #4, !dbg !1010
  %9 = zext i1 %call3 to i64, !dbg !1010
  %cond = select i1 %call3, i32 1, i32 0, !dbg !1010
  %10 = load ptr, ptr %is_denormal.addr, align 8, !dbg !1011
  %arrayidx4 = getelementptr inbounds i32, ptr %10, i64 0, !dbg !1011
  store i32 %cond, ptr %arrayidx4, align 4, !dbg !1012
  br label %if.end, !dbg !1013

if.end:                                           ; preds = %if.then, %entry
  %11 = load i32, ptr %idx, align 4, !dbg !1014
  %cmp5 = icmp eq i32 %11, 1, !dbg !1016
  br i1 %cmp5, label %if.then6, label %if.end13, !dbg !1016

if.then6:                                         ; preds = %if.end
  %12 = load float, ptr %tiny, align 4, !dbg !1017
  store float %12, ptr %__a.addr.i44, align 4
    #dbg_declare(ptr %__a.addr.i44, !1019, !DIExpression(), !1021)
  store float 5.000000e-01, ptr %__b.addr.i45, align 4
    #dbg_declare(ptr %__b.addr.i45, !1023, !DIExpression(), !1024)
  %13 = load float, ptr %__a.addr.i44, align 4, !dbg !1025
  %14 = load float, ptr %__b.addr.i45, align 4, !dbg !1026
  %15 = call float @llvm.nvvm.mul.rn.f(float %13, float %14), !dbg !1027
  %16 = load ptr, ptr %result.addr, align 8, !dbg !1028
  %arrayidx8 = getelementptr inbounds float, ptr %16, i64 1, !dbg !1028
  store float %15, ptr %arrayidx8, align 4, !dbg !1029
  %17 = load ptr, ptr %result.addr, align 8, !dbg !1030
  %arrayidx9 = getelementptr inbounds float, ptr %17, i64 1, !dbg !1030
  %18 = load float, ptr %arrayidx9, align 4, !dbg !1030
  %call10 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %18) #4, !dbg !1031
  %19 = zext i1 %call10 to i64, !dbg !1031
  %cond11 = select i1 %call10, i32 1, i32 0, !dbg !1031
  %20 = load ptr, ptr %is_denormal.addr, align 8, !dbg !1032
  %arrayidx12 = getelementptr inbounds i32, ptr %20, i64 1, !dbg !1032
  store i32 %cond11, ptr %arrayidx12, align 4, !dbg !1033
  br label %if.end13, !dbg !1034

if.end13:                                         ; preds = %if.then6, %if.end
  %21 = load i32, ptr %idx, align 4, !dbg !1035
  %cmp14 = icmp eq i32 %21, 2, !dbg !1037
  br i1 %cmp14, label %if.then15, label %if.end22, !dbg !1037

if.then15:                                        ; preds = %if.end13
  %22 = load float, ptr %tiny, align 4, !dbg !1038
  store float %22, ptr %__a.addr.i41, align 4
    #dbg_declare(ptr %__a.addr.i41, !1019, !DIExpression(), !1040)
  store float 0x3BC79CA100000000, ptr %__b.addr.i42, align 4
    #dbg_declare(ptr %__b.addr.i42, !1023, !DIExpression(), !1042)
  %23 = load float, ptr %__a.addr.i41, align 4, !dbg !1043
  %24 = load float, ptr %__b.addr.i42, align 4, !dbg !1044
  %25 = call float @llvm.nvvm.mul.rn.f(float %23, float %24), !dbg !1045
  %26 = load ptr, ptr %result.addr, align 8, !dbg !1046
  %arrayidx17 = getelementptr inbounds float, ptr %26, i64 2, !dbg !1046
  store float %25, ptr %arrayidx17, align 4, !dbg !1047
  %27 = load ptr, ptr %result.addr, align 8, !dbg !1048
  %arrayidx18 = getelementptr inbounds float, ptr %27, i64 2, !dbg !1048
  %28 = load float, ptr %arrayidx18, align 4, !dbg !1048
  %call19 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %28) #4, !dbg !1049
  %29 = zext i1 %call19 to i64, !dbg !1049
  %cond20 = select i1 %call19, i32 1, i32 0, !dbg !1049
  %30 = load ptr, ptr %is_denormal.addr, align 8, !dbg !1050
  %arrayidx21 = getelementptr inbounds i32, ptr %30, i64 2, !dbg !1050
  store i32 %cond20, ptr %arrayidx21, align 4, !dbg !1051
  br label %if.end22, !dbg !1052

if.end22:                                         ; preds = %if.then15, %if.end13
  %31 = load i32, ptr %idx, align 4, !dbg !1053
  %cmp23 = icmp eq i32 %31, 3, !dbg !1055
  br i1 %cmp23, label %if.then24, label %if.end31, !dbg !1055

if.then24:                                        ; preds = %if.end22
    #dbg_declare(ptr %a, !1056, !DIExpression(), !1058)
  %32 = load float, ptr %tiny, align 4, !dbg !1059
  %33 = bitcast float %32 to i32, !dbg !1060
  %34 = bitcast float %32 to i32, !dbg !1060
  %35 = and i32 %34, 2139095040, !dbg !1060
  %36 = icmp eq i32 %35, 2139095040, !dbg !1060
  %37 = and i32 %34, 8388607, !dbg !1060
  %38 = icmp ne i32 %37, 0, !dbg !1060
  %is_nan = and i1 %36, %38, !dbg !1060
  %39 = and i32 %33, 4194304, !dbg !1060
  %40 = icmp eq i32 %39, 0, !dbg !1060
  %is_snan = and i1 %is_nan, %40, !dbg !1060
  %41 = or i1 %is_snan, false, !dbg !1060
  %42 = bitcast float %32 to i32, !dbg !1060
  %43 = and i32 %42, 2147483647, !dbg !1060
  %is_zero = icmp eq i32 %43, 0, !dbg !1060
  %44 = and i1 %is_zero, false, !dbg !1060
  %45 = bitcast float %32 to i32, !dbg !1060
  %46 = and i32 %45, 2139095040, !dbg !1060
  %47 = icmp eq i32 %46, 2139095040, !dbg !1060
  %48 = and i32 %45, 8388607, !dbg !1060
  %49 = icmp eq i32 %48, 0, !dbg !1060
  %is_inf = and i1 %47, %49, !dbg !1060
  %50 = and i1 %is_inf, false, !dbg !1060
  %51 = or i1 %44, %50, !dbg !1060
  %52 = or i1 %41, %51, !dbg !1060
  br i1 %52, label %53, label %55, !dbg !1060

53:                                               ; preds = %if.then24
  %54 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1060
  br label %55, !dbg !1060

55:                                               ; preds = %if.then24, %53
  %mul = fmul contract float %32, 0x3FF0000020000000, !dbg !1060
  %56 = bitcast float %32 to i32, !dbg !1058
  %57 = and i32 %56, 2139095040, !dbg !1058
  %is_finite = icmp ne i32 %57, 2139095040, !dbg !1058
  %58 = and i1 true, %is_finite, !dbg !1058
  %59 = and i1 %58, true, !dbg !1058
  %60 = bitcast float %mul to i32, !dbg !1058
  %61 = and i32 %60, 2139095040, !dbg !1058
  %62 = icmp eq i32 %61, 2139095040, !dbg !1058
  %63 = and i32 %60, 8388607, !dbg !1058
  %64 = icmp eq i32 %63, 0, !dbg !1058
  %is_inf1 = and i1 %62, %64, !dbg !1058
  %65 = bitcast float %mul to i32, !dbg !1058
  %66 = and i32 %65, 2147483647, !dbg !1058
  %is_maxfinite = icmp eq i32 %66, 2139095039, !dbg !1058
  %67 = bitcast float %mul to i32, !dbg !1058
  %68 = and i32 %67, -2147483648, !dbg !1058
  %69 = icmp eq i32 %68, 0, !dbg !1058
  %70 = icmp ne i32 %68, 0, !dbg !1058
  %is_pos_inf = and i1 %is_inf1, %69, !dbg !1058
  %is_neg_inf = and i1 %is_inf1, %70, !dbg !1058
  %is_pos_max = and i1 %is_maxfinite, %69, !dbg !1058
  %is_neg_max = and i1 %is_maxfinite, %70, !dbg !1058
  %overflow_cond = and i1 %59, %is_inf1, !dbg !1058
  br i1 %overflow_cond, label %71, label %73, !dbg !1058

71:                                               ; preds = %55
  %72 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1058
  br label %73, !dbg !1058

73:                                               ; preds = %55, %71
  %74 = bitcast float %32 to i32, !dbg !1058
  %75 = and i32 %74, 2139095040, !dbg !1058
  %76 = icmp eq i32 %75, 0, !dbg !1058
  %77 = and i32 %74, 8388607, !dbg !1058
  %78 = icmp ne i32 %77, 0, !dbg !1058
  %is_subnormal = and i1 %76, %78, !dbg !1058
  %79 = xor i1 %is_subnormal, true, !dbg !1058
  %80 = and i1 true, %79, !dbg !1058
  %81 = and i1 %80, true, !dbg !1058
  %82 = bitcast float %mul to i32, !dbg !1058
  %83 = and i32 %82, 2139095040, !dbg !1058
  %84 = icmp eq i32 %83, 0, !dbg !1058
  %85 = and i32 %82, 8388607, !dbg !1058
  %86 = icmp ne i32 %85, 0, !dbg !1058
  %is_subnormal2 = and i1 %84, %86, !dbg !1058
  %87 = bitcast float %mul to i32, !dbg !1058
  %88 = and i32 %87, 2147483647, !dbg !1058
  %is_zero3 = icmp eq i32 %88, 0, !dbg !1058
  %89 = bitcast float %32 to i32, !dbg !1058
  %90 = and i32 %89, 2147483647, !dbg !1058
  %is_zero4 = icmp eq i32 %90, 0, !dbg !1058
  %91 = xor i1 %is_zero4, true, !dbg !1058
  %92 = and i1 %91, true, !dbg !1058
  %93 = and i1 %is_zero3, %92, !dbg !1058
  %is_tiny = or i1 %is_subnormal2, %93, !dbg !1058
  %underflow_cond = and i1 %81, %is_tiny, !dbg !1058
  br i1 %underflow_cond, label %94, label %96, !dbg !1058

94:                                               ; preds = %73
  %95 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1058
  br label %96, !dbg !1058

96:                                               ; preds = %73, %94
  store float %mul, ptr %a, align 4, !dbg !1058
    #dbg_declare(ptr %b, !1061, !DIExpression(), !1062)
  %97 = load float, ptr %tiny, align 4, !dbg !1063
  store float %97, ptr %b, align 4, !dbg !1062
  %98 = load float, ptr %a, align 4, !dbg !1064
  %99 = load float, ptr %b, align 4, !dbg !1065
  store float %98, ptr %__a.addr.i47, align 4
    #dbg_declare(ptr %__a.addr.i47, !1066, !DIExpression(), !1068)
  store float %99, ptr %__b.addr.i48, align 4
    #dbg_declare(ptr %__b.addr.i48, !1070, !DIExpression(), !1071)
  %100 = load float, ptr %__a.addr.i47, align 4, !dbg !1072
  %101 = load float, ptr %__b.addr.i48, align 4, !dbg !1073
  %102 = call float asm "sub.rn.f32 $0, $1, $2;", "=f,f,f"(float %100, float %101) #5, !dbg !1074, !srcloc !1075
  %103 = load ptr, ptr %result.addr, align 8, !dbg !1076
  %arrayidx26 = getelementptr inbounds float, ptr %103, i64 3, !dbg !1076
  store float %102, ptr %arrayidx26, align 4, !dbg !1077
  %104 = load ptr, ptr %result.addr, align 8, !dbg !1078
  %arrayidx27 = getelementptr inbounds float, ptr %104, i64 3, !dbg !1078
  %105 = load float, ptr %arrayidx27, align 4, !dbg !1078
  %call28 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %105) #4, !dbg !1079
  %106 = zext i1 %call28 to i64, !dbg !1079
  %cond29 = select i1 %call28, i32 1, i32 0, !dbg !1079
  %107 = load ptr, ptr %is_denormal.addr, align 8, !dbg !1080
  %arrayidx30 = getelementptr inbounds i32, ptr %107, i64 3, !dbg !1080
  store i32 %cond29, ptr %arrayidx30, align 4, !dbg !1081
  br label %if.end31, !dbg !1082

if.end31:                                         ; preds = %96, %if.end22
  %108 = load i32, ptr %idx, align 4, !dbg !1083
  %cmp32 = icmp eq i32 %108, 4, !dbg !1085
  br i1 %cmp32, label %if.then33, label %if.end40, !dbg !1085

if.then33:                                        ; preds = %if.end31
  %109 = load float, ptr %tiny, align 4, !dbg !1086
  store float %109, ptr %__a.addr.i50, align 4
    #dbg_declare(ptr %__a.addr.i50, !1088, !DIExpression(), !1090)
  store float 2.500000e-01, ptr %__b.addr.i51, align 4
    #dbg_declare(ptr %__b.addr.i51, !1092, !DIExpression(), !1093)
  store float 0.000000e+00, ptr %__c.addr.i, align 4
    #dbg_declare(ptr %__c.addr.i, !1094, !DIExpression(), !1095)
  %110 = load float, ptr %__a.addr.i50, align 4, !dbg !1096
  %111 = load float, ptr %__b.addr.i51, align 4, !dbg !1097
  %112 = load float, ptr %__c.addr.i, align 4, !dbg !1098
  %113 = bitcast float %110 to i32, !dbg !1099
  %114 = bitcast float %110 to i32, !dbg !1099
  %115 = and i32 %114, 2139095040, !dbg !1099
  %116 = icmp eq i32 %115, 2139095040, !dbg !1099
  %117 = and i32 %114, 8388607, !dbg !1099
  %118 = icmp ne i32 %117, 0, !dbg !1099
  %is_nan5 = and i1 %116, %118, !dbg !1099
  %119 = and i32 %113, 4194304, !dbg !1099
  %120 = icmp eq i32 %119, 0, !dbg !1099
  %is_snan6 = and i1 %is_nan5, %120, !dbg !1099
  %121 = bitcast float %111 to i32, !dbg !1099
  %122 = bitcast float %111 to i32, !dbg !1099
  %123 = and i32 %122, 2139095040, !dbg !1099
  %124 = icmp eq i32 %123, 2139095040, !dbg !1099
  %125 = and i32 %122, 8388607, !dbg !1099
  %126 = icmp ne i32 %125, 0, !dbg !1099
  %is_nan7 = and i1 %124, %126, !dbg !1099
  %127 = and i32 %121, 4194304, !dbg !1099
  %128 = icmp eq i32 %127, 0, !dbg !1099
  %is_snan8 = and i1 %is_nan7, %128, !dbg !1099
  %129 = or i1 %is_snan6, %is_snan8, !dbg !1099
  %130 = bitcast float %112 to i32, !dbg !1099
  %131 = bitcast float %112 to i32, !dbg !1099
  %132 = and i32 %131, 2139095040, !dbg !1099
  %133 = icmp eq i32 %132, 2139095040, !dbg !1099
  %134 = and i32 %131, 8388607, !dbg !1099
  %135 = icmp ne i32 %134, 0, !dbg !1099
  %is_nan9 = and i1 %133, %135, !dbg !1099
  %136 = and i32 %130, 4194304, !dbg !1099
  %137 = icmp eq i32 %136, 0, !dbg !1099
  %is_snan10 = and i1 %is_nan9, %137, !dbg !1099
  %138 = or i1 %129, %is_snan10, !dbg !1099
  %139 = bitcast float %110 to i32, !dbg !1099
  %140 = and i32 %139, 2147483647, !dbg !1099
  %is_zero11 = icmp eq i32 %140, 0, !dbg !1099
  %141 = bitcast float %111 to i32, !dbg !1099
  %142 = and i32 %141, 2139095040, !dbg !1099
  %143 = icmp eq i32 %142, 2139095040, !dbg !1099
  %144 = and i32 %141, 8388607, !dbg !1099
  %145 = icmp eq i32 %144, 0, !dbg !1099
  %is_inf12 = and i1 %143, %145, !dbg !1099
  %146 = and i1 %is_zero11, %is_inf12, !dbg !1099
  %147 = bitcast float %110 to i32, !dbg !1099
  %148 = and i32 %147, 2139095040, !dbg !1099
  %149 = icmp eq i32 %148, 2139095040, !dbg !1099
  %150 = and i32 %147, 8388607, !dbg !1099
  %151 = icmp eq i32 %150, 0, !dbg !1099
  %is_inf13 = and i1 %149, %151, !dbg !1099
  %152 = bitcast float %111 to i32, !dbg !1099
  %153 = and i32 %152, 2147483647, !dbg !1099
  %is_zero14 = icmp eq i32 %153, 0, !dbg !1099
  %154 = and i1 %is_inf13, %is_zero14, !dbg !1099
  %155 = or i1 %146, %154, !dbg !1099
  %156 = or i1 %138, %155, !dbg !1099
  br i1 %156, label %157, label %159, !dbg !1099

157:                                              ; preds = %if.then33
  %158 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1099
  br label %159, !dbg !1099

159:                                              ; preds = %if.then33, %157
  %160 = call float @llvm.nvvm.fma.rn.f(float %110, float %111, float %112), !dbg !1099
  %161 = bitcast float %110 to i32, !dbg !1100
  %162 = and i32 %161, 2139095040, !dbg !1100
  %is_finite15 = icmp ne i32 %162, 2139095040, !dbg !1100
  %163 = and i1 true, %is_finite15, !dbg !1100
  %164 = bitcast float %111 to i32, !dbg !1100
  %165 = and i32 %164, 2139095040, !dbg !1100
  %is_finite16 = icmp ne i32 %165, 2139095040, !dbg !1100
  %166 = and i1 %163, %is_finite16, !dbg !1100
  %167 = bitcast float %160 to i32, !dbg !1100
  %168 = and i32 %167, 2139095040, !dbg !1100
  %169 = icmp eq i32 %168, 2139095040, !dbg !1100
  %170 = and i32 %167, 8388607, !dbg !1100
  %171 = icmp eq i32 %170, 0, !dbg !1100
  %is_inf17 = and i1 %169, %171, !dbg !1100
  %172 = bitcast float %160 to i32, !dbg !1100
  %173 = and i32 %172, 2147483647, !dbg !1100
  %is_maxfinite18 = icmp eq i32 %173, 2139095039, !dbg !1100
  %174 = bitcast float %160 to i32, !dbg !1100
  %175 = and i32 %174, -2147483648, !dbg !1100
  %176 = icmp eq i32 %175, 0, !dbg !1100
  %177 = icmp ne i32 %175, 0, !dbg !1100
  %is_pos_inf19 = and i1 %is_inf17, %176, !dbg !1100
  %is_neg_inf20 = and i1 %is_inf17, %177, !dbg !1100
  %is_pos_max21 = and i1 %is_maxfinite18, %176, !dbg !1100
  %is_neg_max22 = and i1 %is_maxfinite18, %177, !dbg !1100
  %overflow_cond23 = and i1 %166, %is_inf17, !dbg !1100
  br i1 %overflow_cond23, label %178, label %180, !dbg !1100

178:                                              ; preds = %159
  %179 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1100
  br label %180, !dbg !1100

180:                                              ; preds = %159, %178
  %181 = bitcast float %110 to i32, !dbg !1100
  %182 = and i32 %181, 2139095040, !dbg !1100
  %183 = icmp eq i32 %182, 0, !dbg !1100
  %184 = and i32 %181, 8388607, !dbg !1100
  %185 = icmp ne i32 %184, 0, !dbg !1100
  %is_subnormal24 = and i1 %183, %185, !dbg !1100
  %186 = xor i1 %is_subnormal24, true, !dbg !1100
  %187 = and i1 true, %186, !dbg !1100
  %188 = bitcast float %111 to i32, !dbg !1100
  %189 = and i32 %188, 2139095040, !dbg !1100
  %190 = icmp eq i32 %189, 0, !dbg !1100
  %191 = and i32 %188, 8388607, !dbg !1100
  %192 = icmp ne i32 %191, 0, !dbg !1100
  %is_subnormal25 = and i1 %190, %192, !dbg !1100
  %193 = xor i1 %is_subnormal25, true, !dbg !1100
  %194 = and i1 %187, %193, !dbg !1100
  %195 = bitcast float %112 to i32, !dbg !1100
  %196 = and i32 %195, 2139095040, !dbg !1100
  %197 = icmp eq i32 %196, 0, !dbg !1100
  %198 = and i32 %195, 8388607, !dbg !1100
  %199 = icmp ne i32 %198, 0, !dbg !1100
  %is_subnormal26 = and i1 %197, %199, !dbg !1100
  %200 = xor i1 %is_subnormal26, true, !dbg !1100
  %201 = and i1 %194, %200, !dbg !1100
  %202 = bitcast float %160 to i32, !dbg !1100
  %203 = and i32 %202, 2139095040, !dbg !1100
  %204 = icmp eq i32 %203, 0, !dbg !1100
  %205 = and i32 %202, 8388607, !dbg !1100
  %206 = icmp ne i32 %205, 0, !dbg !1100
  %is_subnormal27 = and i1 %204, %206, !dbg !1100
  %is_tiny28 = or i1 %is_subnormal27, false, !dbg !1100
  %underflow_cond29 = and i1 %201, %is_tiny28, !dbg !1100
  br i1 %underflow_cond29, label %207, label %209, !dbg !1100

207:                                              ; preds = %180
  %208 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1100
  br label %209, !dbg !1100

209:                                              ; preds = %180, %207
  %210 = load ptr, ptr %result.addr, align 8, !dbg !1100
  %arrayidx35 = getelementptr inbounds float, ptr %210, i64 4, !dbg !1100
  store float %160, ptr %arrayidx35, align 4, !dbg !1101
  %211 = load ptr, ptr %result.addr, align 8, !dbg !1102
  %arrayidx36 = getelementptr inbounds float, ptr %211, i64 4, !dbg !1102
  %212 = load float, ptr %arrayidx36, align 4, !dbg !1102
  %call37 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %212) #4, !dbg !1103
  %213 = zext i1 %call37 to i64, !dbg !1103
  %cond38 = select i1 %call37, i32 1, i32 0, !dbg !1103
  %214 = load ptr, ptr %is_denormal.addr, align 8, !dbg !1104
  %arrayidx39 = getelementptr inbounds i32, ptr %214, i64 4, !dbg !1104
  store i32 %cond38, ptr %arrayidx39, align 4, !dbg !1105
  br label %if.end40, !dbg !1106

if.end40:                                         ; preds = %209, %if.end31
  ret void, !dbg !1107
}

; Function Attrs: convergent noinline norecurse nounwind optnone
define dso_local ptx_kernel void @_Z23testUnderflow_RoundZeroPfPi(ptr noundef %result, ptr noundef %is_denormal) #1 !dbg !1108 {
entry:
  %__a.addr.i26 = alloca float, align 4
  %__b.addr.i27 = alloca float, align 4
  %__a.addr.i23 = alloca float, align 4
  %__b.addr.i24 = alloca float, align 4
  %__a.addr.i = alloca float, align 4
  %__b.addr.i = alloca float, align 4
  %result.addr = alloca ptr, align 8
  %is_denormal.addr = alloca ptr, align 8
  %idx = alloca i32, align 4
  %tiny = alloca float, align 4
  store ptr %result, ptr %result.addr, align 8
    #dbg_declare(ptr %result.addr, !1109, !DIExpression(), !1110)
  store ptr %is_denormal, ptr %is_denormal.addr, align 8
    #dbg_declare(ptr %is_denormal.addr, !1111, !DIExpression(), !1112)
    #dbg_declare(ptr %idx, !1113, !DIExpression(), !1114)
  %0 = call noundef i32 @llvm.nvvm.read.ptx.sreg.tid.x(), !dbg !1115
  store i32 %0, ptr %idx, align 4, !dbg !1114
    #dbg_declare(ptr %tiny, !1117, !DIExpression(), !1118)
  store float 0x3810000000000000, ptr %tiny, align 4, !dbg !1118
  %1 = load i32, ptr %idx, align 4, !dbg !1119
  %cmp = icmp eq i32 %1, 0, !dbg !1121
  br i1 %cmp, label %if.then, label %if.end, !dbg !1121

if.then:                                          ; preds = %entry
  %2 = load float, ptr %tiny, align 4, !dbg !1122
  store float %2, ptr %__a.addr.i, align 4
    #dbg_declare(ptr %__a.addr.i, !1124, !DIExpression(), !1126)
  store float 2.000000e+00, ptr %__b.addr.i, align 4
    #dbg_declare(ptr %__b.addr.i, !1128, !DIExpression(), !1129)
  %3 = load float, ptr %__a.addr.i, align 4, !dbg !1130
  %4 = load float, ptr %__b.addr.i, align 4, !dbg !1131
  %5 = call float @llvm.nvvm.div.rz.f(float %3, float %4), !dbg !1132
  %6 = load ptr, ptr %result.addr, align 8, !dbg !1133
  %arrayidx = getelementptr inbounds float, ptr %6, i64 0, !dbg !1133
  store float %5, ptr %arrayidx, align 4, !dbg !1134
  %7 = load ptr, ptr %result.addr, align 8, !dbg !1135
  %arrayidx2 = getelementptr inbounds float, ptr %7, i64 0, !dbg !1135
  %8 = load float, ptr %arrayidx2, align 4, !dbg !1135
  %call3 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %8) #4, !dbg !1136
  %9 = zext i1 %call3 to i64, !dbg !1136
  %cond = select i1 %call3, i32 1, i32 0, !dbg !1136
  %10 = load ptr, ptr %is_denormal.addr, align 8, !dbg !1137
  %arrayidx4 = getelementptr inbounds i32, ptr %10, i64 0, !dbg !1137
  store i32 %cond, ptr %arrayidx4, align 4, !dbg !1138
  br label %if.end, !dbg !1139

if.end:                                           ; preds = %if.then, %entry
  %11 = load i32, ptr %idx, align 4, !dbg !1140
  %cmp5 = icmp eq i32 %11, 1, !dbg !1142
  br i1 %cmp5, label %if.then6, label %if.end13, !dbg !1142

if.then6:                                         ; preds = %if.end
  %12 = load float, ptr %tiny, align 4, !dbg !1143
  store float %12, ptr %__a.addr.i26, align 4
    #dbg_declare(ptr %__a.addr.i26, !1145, !DIExpression(), !1147)
  store float 5.000000e-01, ptr %__b.addr.i27, align 4
    #dbg_declare(ptr %__b.addr.i27, !1149, !DIExpression(), !1150)
  %13 = load float, ptr %__a.addr.i26, align 4, !dbg !1151
  %14 = load float, ptr %__b.addr.i27, align 4, !dbg !1152
  %15 = call float @llvm.nvvm.mul.rz.f(float %13, float %14), !dbg !1153
  %16 = load ptr, ptr %result.addr, align 8, !dbg !1154
  %arrayidx8 = getelementptr inbounds float, ptr %16, i64 1, !dbg !1154
  store float %15, ptr %arrayidx8, align 4, !dbg !1155
  %17 = load ptr, ptr %result.addr, align 8, !dbg !1156
  %arrayidx9 = getelementptr inbounds float, ptr %17, i64 1, !dbg !1156
  %18 = load float, ptr %arrayidx9, align 4, !dbg !1156
  %call10 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %18) #4, !dbg !1157
  %19 = zext i1 %call10 to i64, !dbg !1157
  %cond11 = select i1 %call10, i32 1, i32 0, !dbg !1157
  %20 = load ptr, ptr %is_denormal.addr, align 8, !dbg !1158
  %arrayidx12 = getelementptr inbounds i32, ptr %20, i64 1, !dbg !1158
  store i32 %cond11, ptr %arrayidx12, align 4, !dbg !1159
  br label %if.end13, !dbg !1160

if.end13:                                         ; preds = %if.then6, %if.end
  %21 = load i32, ptr %idx, align 4, !dbg !1161
  %cmp14 = icmp eq i32 %21, 2, !dbg !1163
  br i1 %cmp14, label %if.then15, label %if.end22, !dbg !1163

if.then15:                                        ; preds = %if.end13
  %22 = load float, ptr %tiny, align 4, !dbg !1164
  store float %22, ptr %__a.addr.i23, align 4
    #dbg_declare(ptr %__a.addr.i23, !1145, !DIExpression(), !1166)
  store float 0x39B4484C00000000, ptr %__b.addr.i24, align 4
    #dbg_declare(ptr %__b.addr.i24, !1149, !DIExpression(), !1168)
  %23 = load float, ptr %__a.addr.i23, align 4, !dbg !1169
  %24 = load float, ptr %__b.addr.i24, align 4, !dbg !1170
  %25 = call float @llvm.nvvm.mul.rz.f(float %23, float %24), !dbg !1171
  %26 = load ptr, ptr %result.addr, align 8, !dbg !1172
  %arrayidx17 = getelementptr inbounds float, ptr %26, i64 2, !dbg !1172
  store float %25, ptr %arrayidx17, align 4, !dbg !1173
  %27 = load ptr, ptr %result.addr, align 8, !dbg !1174
  %arrayidx18 = getelementptr inbounds float, ptr %27, i64 2, !dbg !1174
  %28 = load float, ptr %arrayidx18, align 4, !dbg !1174
  %call19 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %28) #4, !dbg !1175
  %29 = zext i1 %call19 to i64, !dbg !1175
  %cond20 = select i1 %call19, i32 1, i32 0, !dbg !1175
  %30 = load ptr, ptr %is_denormal.addr, align 8, !dbg !1176
  %arrayidx21 = getelementptr inbounds i32, ptr %30, i64 2, !dbg !1176
  store i32 %cond20, ptr %arrayidx21, align 4, !dbg !1177
  br label %if.end22, !dbg !1178

if.end22:                                         ; preds = %if.then15, %if.end13
  ret void, !dbg !1179
}

; Function Attrs: convergent noinline norecurse nounwind optnone
define dso_local ptx_kernel void @_Z21testUnderflow_RoundUpPfPi(ptr noundef %result, ptr noundef %is_denormal) #1 !dbg !1180 {
entry:
  %__a.addr.i26 = alloca float, align 4
  %__b.addr.i27 = alloca float, align 4
  %__a.addr.i23 = alloca float, align 4
  %__b.addr.i24 = alloca float, align 4
  %__a.addr.i = alloca float, align 4
  %__b.addr.i = alloca float, align 4
  %result.addr = alloca ptr, align 8
  %is_denormal.addr = alloca ptr, align 8
  %idx = alloca i32, align 4
  %tiny = alloca float, align 4
  store ptr %result, ptr %result.addr, align 8
    #dbg_declare(ptr %result.addr, !1181, !DIExpression(), !1182)
  store ptr %is_denormal, ptr %is_denormal.addr, align 8
    #dbg_declare(ptr %is_denormal.addr, !1183, !DIExpression(), !1184)
    #dbg_declare(ptr %idx, !1185, !DIExpression(), !1186)
  %0 = call noundef i32 @llvm.nvvm.read.ptx.sreg.tid.x(), !dbg !1187
  store i32 %0, ptr %idx, align 4, !dbg !1186
    #dbg_declare(ptr %tiny, !1189, !DIExpression(), !1190)
  store float 0x3810000000000000, ptr %tiny, align 4, !dbg !1190
  %1 = load i32, ptr %idx, align 4, !dbg !1191
  %cmp = icmp eq i32 %1, 0, !dbg !1193
  br i1 %cmp, label %if.then, label %if.end, !dbg !1193

if.then:                                          ; preds = %entry
  %2 = load float, ptr %tiny, align 4, !dbg !1194
  store float %2, ptr %__a.addr.i, align 4
    #dbg_declare(ptr %__a.addr.i, !1196, !DIExpression(), !1198)
  store float 2.000000e+00, ptr %__b.addr.i, align 4
    #dbg_declare(ptr %__b.addr.i, !1200, !DIExpression(), !1201)
  %3 = load float, ptr %__a.addr.i, align 4, !dbg !1202
  %4 = load float, ptr %__b.addr.i, align 4, !dbg !1203
  %5 = call float @llvm.nvvm.div.rp.f(float %3, float %4), !dbg !1204
  %6 = load ptr, ptr %result.addr, align 8, !dbg !1205
  %arrayidx = getelementptr inbounds float, ptr %6, i64 0, !dbg !1205
  store float %5, ptr %arrayidx, align 4, !dbg !1206
  %7 = load ptr, ptr %result.addr, align 8, !dbg !1207
  %arrayidx2 = getelementptr inbounds float, ptr %7, i64 0, !dbg !1207
  %8 = load float, ptr %arrayidx2, align 4, !dbg !1207
  %call3 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %8) #4, !dbg !1208
  %9 = zext i1 %call3 to i64, !dbg !1208
  %cond = select i1 %call3, i32 1, i32 0, !dbg !1208
  %10 = load ptr, ptr %is_denormal.addr, align 8, !dbg !1209
  %arrayidx4 = getelementptr inbounds i32, ptr %10, i64 0, !dbg !1209
  store i32 %cond, ptr %arrayidx4, align 4, !dbg !1210
  br label %if.end, !dbg !1211

if.end:                                           ; preds = %if.then, %entry
  %11 = load i32, ptr %idx, align 4, !dbg !1212
  %cmp5 = icmp eq i32 %11, 1, !dbg !1214
  br i1 %cmp5, label %if.then6, label %if.end13, !dbg !1214

if.then6:                                         ; preds = %if.end
  %12 = load float, ptr %tiny, align 4, !dbg !1215
  store float %12, ptr %__a.addr.i26, align 4
    #dbg_declare(ptr %__a.addr.i26, !1217, !DIExpression(), !1219)
  store float 5.000000e-01, ptr %__b.addr.i27, align 4
    #dbg_declare(ptr %__b.addr.i27, !1221, !DIExpression(), !1222)
  %13 = load float, ptr %__a.addr.i26, align 4, !dbg !1223
  %14 = load float, ptr %__b.addr.i27, align 4, !dbg !1224
  %15 = call float @llvm.nvvm.mul.rp.f(float %13, float %14), !dbg !1225
  %16 = load ptr, ptr %result.addr, align 8, !dbg !1226
  %arrayidx8 = getelementptr inbounds float, ptr %16, i64 1, !dbg !1226
  store float %15, ptr %arrayidx8, align 4, !dbg !1227
  %17 = load ptr, ptr %result.addr, align 8, !dbg !1228
  %arrayidx9 = getelementptr inbounds float, ptr %17, i64 1, !dbg !1228
  %18 = load float, ptr %arrayidx9, align 4, !dbg !1228
  %call10 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %18) #4, !dbg !1229
  %19 = zext i1 %call10 to i64, !dbg !1229
  %cond11 = select i1 %call10, i32 1, i32 0, !dbg !1229
  %20 = load ptr, ptr %is_denormal.addr, align 8, !dbg !1230
  %arrayidx12 = getelementptr inbounds i32, ptr %20, i64 1, !dbg !1230
  store i32 %cond11, ptr %arrayidx12, align 4, !dbg !1231
  br label %if.end13, !dbg !1232

if.end13:                                         ; preds = %if.then6, %if.end
  %21 = load i32, ptr %idx, align 4, !dbg !1233
  %cmp14 = icmp eq i32 %21, 2, !dbg !1235
  br i1 %cmp14, label %if.then15, label %if.end22, !dbg !1235

if.then15:                                        ; preds = %if.end13
  %22 = load float, ptr %tiny, align 4, !dbg !1236
  %fneg = fneg contract float %22, !dbg !1238
  store float %fneg, ptr %__a.addr.i23, align 4
    #dbg_declare(ptr %__a.addr.i23, !1217, !DIExpression(), !1239)
  store float 5.000000e-01, ptr %__b.addr.i24, align 4
    #dbg_declare(ptr %__b.addr.i24, !1221, !DIExpression(), !1241)
  %23 = load float, ptr %__a.addr.i23, align 4, !dbg !1242
  %24 = load float, ptr %__b.addr.i24, align 4, !dbg !1243
  %25 = call float @llvm.nvvm.mul.rp.f(float %23, float %24), !dbg !1244
  %26 = load ptr, ptr %result.addr, align 8, !dbg !1245
  %arrayidx17 = getelementptr inbounds float, ptr %26, i64 2, !dbg !1245
  store float %25, ptr %arrayidx17, align 4, !dbg !1246
  %27 = load ptr, ptr %result.addr, align 8, !dbg !1247
  %arrayidx18 = getelementptr inbounds float, ptr %27, i64 2, !dbg !1247
  %28 = load float, ptr %arrayidx18, align 4, !dbg !1247
  %call19 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %28) #4, !dbg !1248
  %29 = zext i1 %call19 to i64, !dbg !1248
  %cond20 = select i1 %call19, i32 1, i32 0, !dbg !1248
  %30 = load ptr, ptr %is_denormal.addr, align 8, !dbg !1249
  %arrayidx21 = getelementptr inbounds i32, ptr %30, i64 2, !dbg !1249
  store i32 %cond20, ptr %arrayidx21, align 4, !dbg !1250
  br label %if.end22, !dbg !1251

if.end22:                                         ; preds = %if.then15, %if.end13
  ret void, !dbg !1252
}

; Function Attrs: convergent noinline norecurse nounwind optnone
define dso_local ptx_kernel void @_Z23testUnderflow_RoundDownPfPi(ptr noundef %result, ptr noundef %is_denormal) #1 !dbg !1253 {
entry:
  %__a.addr.i27 = alloca float, align 4
  %__b.addr.i28 = alloca float, align 4
  %__a.addr.i24 = alloca float, align 4
  %__b.addr.i25 = alloca float, align 4
  %__a.addr.i = alloca float, align 4
  %__b.addr.i = alloca float, align 4
  %result.addr = alloca ptr, align 8
  %is_denormal.addr = alloca ptr, align 8
  %idx = alloca i32, align 4
  %tiny = alloca float, align 4
  store ptr %result, ptr %result.addr, align 8
    #dbg_declare(ptr %result.addr, !1254, !DIExpression(), !1255)
  store ptr %is_denormal, ptr %is_denormal.addr, align 8
    #dbg_declare(ptr %is_denormal.addr, !1256, !DIExpression(), !1257)
    #dbg_declare(ptr %idx, !1258, !DIExpression(), !1259)
  %0 = call noundef i32 @llvm.nvvm.read.ptx.sreg.tid.x(), !dbg !1260
  store i32 %0, ptr %idx, align 4, !dbg !1259
    #dbg_declare(ptr %tiny, !1262, !DIExpression(), !1263)
  store float 0x3810000000000000, ptr %tiny, align 4, !dbg !1263
  %1 = load i32, ptr %idx, align 4, !dbg !1264
  %cmp = icmp eq i32 %1, 0, !dbg !1266
  br i1 %cmp, label %if.then, label %if.end, !dbg !1266

if.then:                                          ; preds = %entry
  %2 = load float, ptr %tiny, align 4, !dbg !1267
  store float %2, ptr %__a.addr.i, align 4
    #dbg_declare(ptr %__a.addr.i, !1269, !DIExpression(), !1271)
  store float 2.000000e+00, ptr %__b.addr.i, align 4
    #dbg_declare(ptr %__b.addr.i, !1273, !DIExpression(), !1274)
  %3 = load float, ptr %__a.addr.i, align 4, !dbg !1275
  %4 = load float, ptr %__b.addr.i, align 4, !dbg !1276
  %5 = call float @llvm.nvvm.div.rm.f(float %3, float %4), !dbg !1277
  %6 = load ptr, ptr %result.addr, align 8, !dbg !1278
  %arrayidx = getelementptr inbounds float, ptr %6, i64 0, !dbg !1278
  store float %5, ptr %arrayidx, align 4, !dbg !1279
  %7 = load ptr, ptr %result.addr, align 8, !dbg !1280
  %arrayidx2 = getelementptr inbounds float, ptr %7, i64 0, !dbg !1280
  %8 = load float, ptr %arrayidx2, align 4, !dbg !1280
  %call3 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %8) #4, !dbg !1281
  %9 = zext i1 %call3 to i64, !dbg !1281
  %cond = select i1 %call3, i32 1, i32 0, !dbg !1281
  %10 = load ptr, ptr %is_denormal.addr, align 8, !dbg !1282
  %arrayidx4 = getelementptr inbounds i32, ptr %10, i64 0, !dbg !1282
  store i32 %cond, ptr %arrayidx4, align 4, !dbg !1283
  br label %if.end, !dbg !1284

if.end:                                           ; preds = %if.then, %entry
  %11 = load i32, ptr %idx, align 4, !dbg !1285
  %cmp5 = icmp eq i32 %11, 1, !dbg !1287
  br i1 %cmp5, label %if.then6, label %if.end13, !dbg !1287

if.then6:                                         ; preds = %if.end
  %12 = load float, ptr %tiny, align 4, !dbg !1288
  %fneg = fneg contract float %12, !dbg !1290
  store float %fneg, ptr %__a.addr.i27, align 4
    #dbg_declare(ptr %__a.addr.i27, !1291, !DIExpression(), !1293)
  store float 5.000000e-01, ptr %__b.addr.i28, align 4
    #dbg_declare(ptr %__b.addr.i28, !1295, !DIExpression(), !1296)
  %13 = load float, ptr %__a.addr.i27, align 4, !dbg !1297
  %14 = load float, ptr %__b.addr.i28, align 4, !dbg !1298
  %15 = call float @llvm.nvvm.mul.rm.f(float %13, float %14), !dbg !1299
  %16 = load ptr, ptr %result.addr, align 8, !dbg !1300
  %arrayidx8 = getelementptr inbounds float, ptr %16, i64 1, !dbg !1300
  store float %15, ptr %arrayidx8, align 4, !dbg !1301
  %17 = load ptr, ptr %result.addr, align 8, !dbg !1302
  %arrayidx9 = getelementptr inbounds float, ptr %17, i64 1, !dbg !1302
  %18 = load float, ptr %arrayidx9, align 4, !dbg !1302
  %call10 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %18) #4, !dbg !1303
  %19 = zext i1 %call10 to i64, !dbg !1303
  %cond11 = select i1 %call10, i32 1, i32 0, !dbg !1303
  %20 = load ptr, ptr %is_denormal.addr, align 8, !dbg !1304
  %arrayidx12 = getelementptr inbounds i32, ptr %20, i64 1, !dbg !1304
  store i32 %cond11, ptr %arrayidx12, align 4, !dbg !1305
  br label %if.end13, !dbg !1306

if.end13:                                         ; preds = %if.then6, %if.end
  %21 = load i32, ptr %idx, align 4, !dbg !1307
  %cmp14 = icmp eq i32 %21, 2, !dbg !1309
  br i1 %cmp14, label %if.then15, label %if.end23, !dbg !1309

if.then15:                                        ; preds = %if.end13
  %22 = load float, ptr %tiny, align 4, !dbg !1310
  %fneg16 = fneg contract float %22, !dbg !1312
  store float %fneg16, ptr %__a.addr.i24, align 4
    #dbg_declare(ptr %__a.addr.i24, !1291, !DIExpression(), !1313)
  store float 2.500000e-01, ptr %__b.addr.i25, align 4
    #dbg_declare(ptr %__b.addr.i25, !1295, !DIExpression(), !1315)
  %23 = load float, ptr %__a.addr.i24, align 4, !dbg !1316
  %24 = load float, ptr %__b.addr.i25, align 4, !dbg !1317
  %25 = call float @llvm.nvvm.mul.rm.f(float %23, float %24), !dbg !1318
  %26 = load ptr, ptr %result.addr, align 8, !dbg !1319
  %arrayidx18 = getelementptr inbounds float, ptr %26, i64 2, !dbg !1319
  store float %25, ptr %arrayidx18, align 4, !dbg !1320
  %27 = load ptr, ptr %result.addr, align 8, !dbg !1321
  %arrayidx19 = getelementptr inbounds float, ptr %27, i64 2, !dbg !1321
  %28 = load float, ptr %arrayidx19, align 4, !dbg !1321
  %call20 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %28) #4, !dbg !1322
  %29 = zext i1 %call20 to i64, !dbg !1322
  %cond21 = select i1 %call20, i32 1, i32 0, !dbg !1322
  %30 = load ptr, ptr %is_denormal.addr, align 8, !dbg !1323
  %arrayidx22 = getelementptr inbounds i32, ptr %30, i64 2, !dbg !1323
  store i32 %cond21, ptr %arrayidx22, align 4, !dbg !1324
  br label %if.end23, !dbg !1325

if.end23:                                         ; preds = %if.then15, %if.end13
  ret void, !dbg !1326
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare noundef range(i32 0, 1024) i32 @llvm.nvvm.read.ptx.sreg.tid.x() #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.fabs.ftz.f32(float) #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.fabs.f32(float) #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.fma.rn.ftz.f(float, float, float) #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.fma.rn.f(float, float, float) #2

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(none)
declare float @llvm.nvvm.div.rn.ftz.f(float, float) #3

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(none)
declare float @llvm.nvvm.div.rn.f(float, float) #3

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(none)
declare float @llvm.nvvm.div.rz.ftz.f(float, float) #3

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(none)
declare float @llvm.nvvm.div.rz.f(float, float) #3

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(none)
declare float @llvm.nvvm.div.rm.ftz.f(float, float) #3

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(none)
declare float @llvm.nvvm.div.rm.f(float, float) #3

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(none)
declare float @llvm.nvvm.div.rp.ftz.f(float, float) #3

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(none)
declare float @llvm.nvvm.div.rp.f(float, float) #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.mul.rm.ftz.f(float, float) #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.mul.rm.f(float, float) #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.mul.rp.ftz.f(float, float) #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.mul.rp.f(float, float) #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.mul.rn.ftz.f(float, float) #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.mul.rn.f(float, float) #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.mul.rz.ftz.f(float, float) #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.mul.rz.f(float, float) #2

attributes #0 = { convergent noinline nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_80" "target-features"="+ptx87,+sm_80" }
attributes #1 = { convergent noinline norecurse nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_80" "target-features"="+ptx87,+sm_80" "uniform-work-group-size"="true" }
attributes #2 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #3 = { nocallback nofree nosync nounwind willreturn memory(none) }
attributes #4 = { convergent nounwind }
attributes #5 = { nounwind memory(none) }

!llvm.module.flags = !{!0, !1, !2, !3, !4, !5}
!llvm.dbg.cu = !{!6}
!llvm.ident = !{!960, !961}
!nvvmir.version = !{!962}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 12, i32 8]}
!1 = !{i32 7, !"Dwarf Version", i32 2}
!2 = !{i32 2, !"Debug Info Version", i32 3}
!3 = !{i32 1, !"wchar_size", i32 4}
!4 = !{i32 4, !"nvvm-reflect-ftz", i32 0}
!5 = !{i32 7, !"frame-pointer", i32 2}
!6 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !7, producer: "clang version 22.1.5 (https://github.com/llvm/llvm-project.git 5ea218a153f4d2f815b8244eab3e4b4ba5e00e6c)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !8, retainedTypes: !33, imports: !97, splitDebugInlining: false, nameTableKind: None)
!7 = !DIFile(filename: "tests/basic_tests/underflow/rounding.cu", directory: "/home/users/sislam3/SBAC-PAD")
!8 = !{!9}
!9 = distinct !DICompositeType(tag: DW_TAG_enumeration_type, name: "sm_selector", scope: !11, file: !10, line: 84, baseType: !14, size: 64, flags: DIFlagEnumClass, elements: !16, identifier: "_ZTSN2nv6target6detail11sm_selectorE")
!10 = !DIFile(filename: "/storage/packages/cuda/12.8.1/include/nv/target", directory: "")
!11 = !DINamespace(name: "detail", scope: !12)
!12 = !DINamespace(name: "target", scope: !13)
!13 = !DINamespace(name: "nv", scope: null)
!14 = !DIDerivedType(tag: DW_TAG_typedef, name: "base_int_t", scope: !11, file: !10, line: 47, baseType: !15)
!15 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!16 = !{!17, !18, !19, !20, !21, !22, !23, !24, !25, !26, !27, !28, !29, !30, !31, !32}
!17 = !DIEnumerator(name: "sm_35", value: 35, isUnsigned: true)
!18 = !DIEnumerator(name: "sm_37", value: 37, isUnsigned: true)
!19 = !DIEnumerator(name: "sm_50", value: 50, isUnsigned: true)
!20 = !DIEnumerator(name: "sm_52", value: 52, isUnsigned: true)
!21 = !DIEnumerator(name: "sm_53", value: 53, isUnsigned: true)
!22 = !DIEnumerator(name: "sm_60", value: 60, isUnsigned: true)
!23 = !DIEnumerator(name: "sm_61", value: 61, isUnsigned: true)
!24 = !DIEnumerator(name: "sm_62", value: 62, isUnsigned: true)
!25 = !DIEnumerator(name: "sm_70", value: 70, isUnsigned: true)
!26 = !DIEnumerator(name: "sm_72", value: 72, isUnsigned: true)
!27 = !DIEnumerator(name: "sm_75", value: 75, isUnsigned: true)
!28 = !DIEnumerator(name: "sm_80", value: 80, isUnsigned: true)
!29 = !DIEnumerator(name: "sm_86", value: 86, isUnsigned: true)
!30 = !DIEnumerator(name: "sm_87", value: 87, isUnsigned: true)
!31 = !DIEnumerator(name: "sm_89", value: 89, isUnsigned: true)
!32 = !DIEnumerator(name: "sm_90", value: 90, isUnsigned: true)
!33 = !{!34, !41, !66}
!34 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "target_description", scope: !11, file: !10, line: 74, size: 64, flags: DIFlagTypePassByValue | DIFlagNonTrivial, elements: !35, identifier: "_ZTSN2nv6target6detail18target_descriptionE")
!35 = !{!36, !37}
!36 = !DIDerivedType(tag: DW_TAG_member, name: "targets", scope: !34, file: !10, line: 76, baseType: !14, size: 64)
!37 = !DISubprogram(name: "target_description", linkageName: "_ZN2nv6target6detail18target_descriptionC4Ey", scope: !34, file: !10, line: 78, type: !38, scopeLine: 78, flags: DIFlagPrototyped, spFlags: 0)
!38 = !DISubroutineType(types: !39)
!39 = !{null, !40, !14}
!40 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !34, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!41 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "dim3", file: !42, line: 426, size: 96, flags: DIFlagTypePassByValue | DIFlagNonTrivial, elements: !43, identifier: "_ZTS4dim3")
!42 = !DIFile(filename: "/storage/packages/cuda/12.8.1/include/vector_types.h", directory: "")
!43 = !{!44, !46, !47, !48, !52, !61}
!44 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !41, file: !42, line: 428, baseType: !45, size: 32)
!45 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!46 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !41, file: !42, line: 428, baseType: !45, size: 32, offset: 32)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !41, file: !42, line: 428, baseType: !45, size: 32, offset: 64)
!48 = !DISubprogram(name: "dim3", linkageName: "_ZN4dim3C4Ejjj", scope: !41, file: !42, line: 431, type: !49, scopeLine: 431, flags: DIFlagPrototyped, spFlags: 0)
!49 = !DISubroutineType(types: !50)
!50 = !{null, !51, !45, !45, !45}
!51 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !41, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!52 = !DISubprogram(name: "dim3", linkageName: "_ZN4dim3C4E5uint3", scope: !41, file: !42, line: 432, type: !53, scopeLine: 432, flags: DIFlagPrototyped, spFlags: 0)
!53 = !DISubroutineType(types: !54)
!54 = !{null, !51, !55}
!55 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint3", file: !42, line: 388, baseType: !56)
!56 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "uint3", file: !42, line: 196, size: 96, flags: DIFlagTypePassByValue, elements: !57, identifier: "_ZTS5uint3")
!57 = !{!58, !59, !60}
!58 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !56, file: !42, line: 198, baseType: !45, size: 32)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !56, file: !42, line: 198, baseType: !45, size: 32, offset: 32)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !56, file: !42, line: 198, baseType: !45, size: 32, offset: 64)
!61 = !DISubprogram(name: "operator uint3", linkageName: "_ZNK4dim3cv5uint3Ev", scope: !41, file: !42, line: 433, type: !62, scopeLine: 433, flags: DIFlagPrototyped, spFlags: 0)
!62 = !DISubroutineType(types: !63)
!63 = !{!55, !64}
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !65, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!65 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !41)
!66 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__cuda_builtin_threadIdx_t", file: !67, line: 52, size: 8, flags: DIFlagTypePassByReference, elements: !68, identifier: "_ZTS26__cuda_builtin_threadIdx_t")
!67 = !DIFile(filename: "/storage/users/sislam3/opt/llvm-22/lib/clang/22/include/__clang_cuda_builtin_vars.h", directory: "")
!68 = !{!69, !72, !73, !74, !79, !82, !86, !90, !93}
!69 = !DISubprogram(name: "__fetch_builtin_x", linkageName: "_ZN26__cuda_builtin_threadIdx_t17__fetch_builtin_xEv", scope: !66, file: !67, line: 53, type: !70, scopeLine: 53, flags: DIFlagPrototyped | DIFlagStaticMember, spFlags: 0)
!70 = !DISubroutineType(types: !71)
!71 = !{!45}
!72 = !DISubprogram(name: "__fetch_builtin_y", linkageName: "_ZN26__cuda_builtin_threadIdx_t17__fetch_builtin_yEv", scope: !66, file: !67, line: 54, type: !70, scopeLine: 54, flags: DIFlagPrototyped | DIFlagStaticMember, spFlags: 0)
!73 = !DISubprogram(name: "__fetch_builtin_z", linkageName: "_ZN26__cuda_builtin_threadIdx_t17__fetch_builtin_zEv", scope: !66, file: !67, line: 55, type: !70, scopeLine: 55, flags: DIFlagPrototyped | DIFlagStaticMember, spFlags: 0)
!74 = !DISubprogram(name: "operator dim3", linkageName: "_ZNK26__cuda_builtin_threadIdx_tcv4dim3Ev", scope: !66, file: !67, line: 58, type: !75, scopeLine: 58, flags: DIFlagPrototyped, spFlags: 0)
!75 = !DISubroutineType(types: !76)
!76 = !{!41, !77}
!77 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !78, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!78 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !66)
!79 = !DISubprogram(name: "operator uint3", linkageName: "_ZNK26__cuda_builtin_threadIdx_tcv5uint3Ev", scope: !66, file: !67, line: 59, type: !80, scopeLine: 59, flags: DIFlagPrototyped, spFlags: 0)
!80 = !DISubroutineType(types: !81)
!81 = !{!56, !77}
!82 = !DISubprogram(name: "__cuda_builtin_threadIdx_t", linkageName: "_ZN26__cuda_builtin_threadIdx_tC4Ev", scope: !66, file: !67, line: 62, type: !83, scopeLine: 62, flags: DIFlagPrivate | DIFlagPrototyped, spFlags: DISPFlagDeleted)
!83 = !DISubroutineType(types: !84)
!84 = !{null, !85}
!85 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !66, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!86 = !DISubprogram(name: "__cuda_builtin_threadIdx_t", linkageName: "_ZN26__cuda_builtin_threadIdx_tC4ERKS_", scope: !66, file: !67, line: 62, type: !87, scopeLine: 62, flags: DIFlagPrivate | DIFlagPrototyped, spFlags: DISPFlagDeleted)
!87 = !DISubroutineType(types: !88)
!88 = !{null, !85, !89}
!89 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !78, size: 64)
!90 = !DISubprogram(name: "operator=", linkageName: "_ZNK26__cuda_builtin_threadIdx_taSERKS_", scope: !66, file: !67, line: 62, type: !91, scopeLine: 62, flags: DIFlagPrivate | DIFlagPrototyped, spFlags: DISPFlagDeleted)
!91 = !DISubroutineType(types: !92)
!92 = !{null, !77, !89}
!93 = !DISubprogram(name: "operator&", linkageName: "_ZNK26__cuda_builtin_threadIdx_tadEv", scope: !66, file: !67, line: 62, type: !94, scopeLine: 62, flags: DIFlagPrivate | DIFlagPrototyped, spFlags: DISPFlagDeleted)
!94 = !DISubroutineType(types: !95)
!95 = !{!96, !77}
!96 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !66, size: 64)
!97 = !{!98, !105, !110, !112, !114, !116, !118, !122, !124, !126, !128, !130, !132, !134, !136, !138, !140, !142, !144, !146, !148, !150, !154, !156, !158, !160, !164, !169, !171, !173, !178, !182, !184, !186, !188, !190, !192, !194, !196, !198, !203, !207, !209, !214, !218, !220, !222, !224, !226, !228, !232, !234, !236, !241, !249, !253, !255, !257, !259, !261, !265, !267, !269, !273, !275, !277, !279, !281, !283, !285, !287, !289, !291, !295, !301, !303, !305, !309, !311, !313, !315, !317, !319, !321, !323, !327, !331, !333, !335, !340, !342, !344, !346, !348, !350, !352, !355, !357, !359, !361, !366, !368, !370, !372, !374, !376, !378, !380, !382, !384, !386, !388, !392, !394, !396, !398, !400, !402, !404, !406, !408, !410, !412, !414, !416, !418, !420, !422, !426, !428, !432, !434, !436, !438, !440, !442, !444, !446, !448, !450, !454, !456, !460, !462, !464, !466, !470, !472, !476, !478, !480, !482, !484, !486, !488, !490, !492, !494, !496, !498, !500, !504, !506, !510, !512, !514, !516, !518, !520, !524, !526, !528, !530, !532, !534, !536, !540, !544, !546, !548, !550, !552, !556, !558, !562, !564, !566, !568, !570, !572, !574, !578, !580, !584, !586, !588, !592, !594, !596, !598, !600, !602, !604, !608, !612, !618, !622, !630, !635, !637, !639, !643, !647, !657, !659, !663, !667, !671, !676, !678, !682, !686, !690, !698, !702, !706, !708, !712, !716, !720, !726, !730, !734, !736, !744, !748, !755, !757, !759, !763, !767, !771, !775, !779, !783, !784, !785, !786, !788, !789, !790, !791, !792, !793, !794, !796, !797, !798, !799, !800, !801, !802, !803, !808, !809, !810, !811, !812, !813, !814, !815, !816, !817, !818, !819, !820, !821, !822, !823, !824, !825, !826, !827, !828, !829, !830, !831, !832, !836, !838, !840, !842, !844, !846, !848, !850, !852, !854, !856, !858, !860, !862, !864, !866, !868, !871, !873, !875, !877, !879, !881, !883, !885, !887, !889, !891, !893, !895, !897, !899, !901, !903, !905, !907, !909, !911, !913, !915, !917, !919, !921, !923, !925, !927, !929, !931, !933, !935, !937, !939, !941, !943, !945, !946, !947, !951, !953, !955}
!98 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !100, file: !101, line: 200)
!99 = !DINamespace(name: "std", scope: null)
!100 = !DISubprogram(name: "abs", linkageName: "_ZL3absi", scope: !101, file: !101, line: 30, type: !102, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!101 = !DIFile(filename: "/storage/users/sislam3/opt/llvm-22/lib/clang/22/include/__clang_cuda_math_forward_declares.h", directory: "")
!102 = !DISubroutineType(types: !103)
!103 = !{!104, !104}
!104 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!105 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !106, file: !101, line: 201)
!106 = !DISubprogram(name: "acos", linkageName: "_ZL4acosf", scope: !101, file: !101, line: 32, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!107 = !DISubroutineType(types: !108)
!108 = !{!109, !109}
!109 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!110 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !111, file: !101, line: 202)
!111 = !DISubprogram(name: "acosh", linkageName: "_ZL5acoshf", scope: !101, file: !101, line: 34, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!112 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !113, file: !101, line: 203)
!113 = !DISubprogram(name: "asin", linkageName: "_ZL4asinf", scope: !101, file: !101, line: 36, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!114 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !115, file: !101, line: 204)
!115 = !DISubprogram(name: "asinh", linkageName: "_ZL5asinhf", scope: !101, file: !101, line: 38, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!116 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !117, file: !101, line: 205)
!117 = !DISubprogram(name: "atan", linkageName: "_ZL4atanf", scope: !101, file: !101, line: 42, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!118 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !119, file: !101, line: 206)
!119 = !DISubprogram(name: "atan2", linkageName: "_ZL5atan2ff", scope: !101, file: !101, line: 40, type: !120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!120 = !DISubroutineType(types: !121)
!121 = !{!109, !109, !109}
!122 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !123, file: !101, line: 207)
!123 = !DISubprogram(name: "atanh", linkageName: "_ZL5atanhf", scope: !101, file: !101, line: 44, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!124 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !125, file: !101, line: 208)
!125 = !DISubprogram(name: "cbrt", linkageName: "_ZL4cbrtf", scope: !101, file: !101, line: 46, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!126 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !127, file: !101, line: 209)
!127 = !DISubprogram(name: "ceil", linkageName: "_ZL4ceilf", scope: !101, file: !101, line: 48, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!128 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !129, file: !101, line: 210)
!129 = !DISubprogram(name: "copysign", linkageName: "_ZL8copysignff", scope: !101, file: !101, line: 50, type: !120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!130 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !131, file: !101, line: 211)
!131 = !DISubprogram(name: "cos", linkageName: "_ZL3cosf", scope: !101, file: !101, line: 52, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!132 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !133, file: !101, line: 212)
!133 = !DISubprogram(name: "cosh", linkageName: "_ZL4coshf", scope: !101, file: !101, line: 54, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!134 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !135, file: !101, line: 213)
!135 = !DISubprogram(name: "erf", linkageName: "_ZL3erff", scope: !101, file: !101, line: 58, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!136 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !137, file: !101, line: 214)
!137 = !DISubprogram(name: "erfc", linkageName: "_ZL4erfcf", scope: !101, file: !101, line: 56, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!138 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !139, file: !101, line: 215)
!139 = !DISubprogram(name: "exp", linkageName: "_ZL3expf", scope: !101, file: !101, line: 62, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!140 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !141, file: !101, line: 216)
!141 = !DISubprogram(name: "exp2", linkageName: "_ZL4exp2f", scope: !101, file: !101, line: 60, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!142 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !143, file: !101, line: 217)
!143 = !DISubprogram(name: "expm1", linkageName: "_ZL5expm1f", scope: !101, file: !101, line: 64, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!144 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !145, file: !101, line: 218)
!145 = !DISubprogram(name: "fabs", linkageName: "_ZL4fabsf", scope: !101, file: !101, line: 66, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!146 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !147, file: !101, line: 219)
!147 = !DISubprogram(name: "fdim", linkageName: "_ZL4fdimff", scope: !101, file: !101, line: 68, type: !120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!148 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !149, file: !101, line: 220)
!149 = !DISubprogram(name: "floor", linkageName: "_ZL5floorf", scope: !101, file: !101, line: 70, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!150 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !151, file: !101, line: 221)
!151 = !DISubprogram(name: "fma", linkageName: "_ZL3fmafff", scope: !101, file: !101, line: 72, type: !152, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!152 = !DISubroutineType(types: !153)
!153 = !{!109, !109, !109, !109}
!154 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !155, file: !101, line: 222)
!155 = !DISubprogram(name: "fmax", linkageName: "_ZL4fmaxff", scope: !101, file: !101, line: 74, type: !120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!156 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !157, file: !101, line: 223)
!157 = !DISubprogram(name: "fmin", linkageName: "_ZL4fminff", scope: !101, file: !101, line: 76, type: !120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!158 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !159, file: !101, line: 224)
!159 = !DISubprogram(name: "fmod", linkageName: "_ZL4fmodff", scope: !101, file: !101, line: 78, type: !120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!160 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !161, file: !101, line: 225)
!161 = !DISubprogram(name: "fpclassify", linkageName: "_ZL10fpclassifyf", scope: !101, file: !101, line: 80, type: !162, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!162 = !DISubroutineType(types: !163)
!163 = !{!104, !109}
!164 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !165, file: !101, line: 226)
!165 = !DISubprogram(name: "frexp", linkageName: "_ZL5frexpfPi", scope: !101, file: !101, line: 82, type: !166, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!166 = !DISubroutineType(types: !167)
!167 = !{!109, !109, !168}
!168 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !104, size: 64)
!169 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !170, file: !101, line: 227)
!170 = !DISubprogram(name: "hypot", linkageName: "_ZL5hypotff", scope: !101, file: !101, line: 84, type: !120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!171 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !172, file: !101, line: 228)
!172 = !DISubprogram(name: "ilogb", linkageName: "_ZL5ilogbf", scope: !101, file: !101, line: 86, type: !162, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!173 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !174, file: !101, line: 229)
!174 = !DISubprogram(name: "isfinite", linkageName: "_ZL8isfinitef", scope: !101, file: !101, line: 91, type: !175, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!175 = !DISubroutineType(types: !176)
!176 = !{!177, !109}
!177 = !DIBasicType(name: "bool", size: 8, encoding: DW_ATE_boolean)
!178 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !179, file: !101, line: 230)
!179 = !DISubprogram(name: "isgreater", linkageName: "_ZL9isgreaterff", scope: !101, file: !101, line: 95, type: !180, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!180 = !DISubroutineType(types: !181)
!181 = !{!177, !109, !109}
!182 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !183, file: !101, line: 231)
!183 = !DISubprogram(name: "isgreaterequal", linkageName: "_ZL14isgreaterequalff", scope: !101, file: !101, line: 94, type: !180, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!184 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !185, file: !101, line: 232)
!185 = !DISubprogram(name: "isinf", linkageName: "_ZL5isinff", scope: !101, file: !101, line: 100, type: !175, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!186 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !187, file: !101, line: 233)
!187 = !DISubprogram(name: "isless", linkageName: "_ZL6islessff", scope: !101, file: !101, line: 104, type: !180, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!188 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !189, file: !101, line: 234)
!189 = !DISubprogram(name: "islessequal", linkageName: "_ZL11islessequalff", scope: !101, file: !101, line: 103, type: !180, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!190 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !191, file: !101, line: 235)
!191 = !DISubprogram(name: "islessgreater", linkageName: "_ZL13islessgreaterff", scope: !101, file: !101, line: 106, type: !180, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!192 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !193, file: !101, line: 236)
!193 = !DISubprogram(name: "isnan", linkageName: "_ZL5isnanf", scope: !101, file: !101, line: 111, type: !175, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!194 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !195, file: !101, line: 237)
!195 = !DISubprogram(name: "isnormal", linkageName: "_ZL8isnormalf", scope: !101, file: !101, line: 113, type: !175, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!196 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !197, file: !101, line: 238)
!197 = !DISubprogram(name: "isunordered", linkageName: "_ZL11isunorderedff", scope: !101, file: !101, line: 115, type: !180, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!198 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !199, file: !101, line: 239)
!199 = !DISubprogram(name: "labs", linkageName: "_ZL4labsl", scope: !101, file: !101, line: 116, type: !200, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!200 = !DISubroutineType(types: !201)
!201 = !{!202, !202}
!202 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!203 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !204, file: !101, line: 240)
!204 = !DISubprogram(name: "ldexp", linkageName: "_ZL5ldexpfi", scope: !101, file: !101, line: 118, type: !205, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!205 = !DISubroutineType(types: !206)
!206 = !{!109, !109, !104}
!207 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !208, file: !101, line: 241)
!208 = !DISubprogram(name: "lgamma", linkageName: "_ZL6lgammaf", scope: !101, file: !101, line: 120, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!209 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !210, file: !101, line: 242)
!210 = !DISubprogram(name: "llabs", linkageName: "_ZL5llabsx", scope: !101, file: !101, line: 121, type: !211, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!211 = !DISubroutineType(types: !212)
!212 = !{!213, !213}
!213 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!214 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !215, file: !101, line: 243)
!215 = !DISubprogram(name: "llrint", linkageName: "_ZL6llrintf", scope: !101, file: !101, line: 123, type: !216, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!216 = !DISubroutineType(types: !217)
!217 = !{!213, !109}
!218 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !219, file: !101, line: 244)
!219 = !DISubprogram(name: "log", linkageName: "_ZL3logf", scope: !101, file: !101, line: 133, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!220 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !221, file: !101, line: 245)
!221 = !DISubprogram(name: "log10", linkageName: "_ZL5log10f", scope: !101, file: !101, line: 125, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!222 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !223, file: !101, line: 246)
!223 = !DISubprogram(name: "log1p", linkageName: "_ZL5log1pf", scope: !101, file: !101, line: 127, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!224 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !225, file: !101, line: 247)
!225 = !DISubprogram(name: "log2", linkageName: "_ZL4log2f", scope: !101, file: !101, line: 129, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!226 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !227, file: !101, line: 248)
!227 = !DISubprogram(name: "logb", linkageName: "_ZL4logbf", scope: !101, file: !101, line: 131, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!228 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !229, file: !101, line: 249)
!229 = !DISubprogram(name: "lrint", linkageName: "_ZL5lrintf", scope: !101, file: !101, line: 135, type: !230, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!230 = !DISubroutineType(types: !231)
!231 = !{!202, !109}
!232 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !233, file: !101, line: 250)
!233 = !DISubprogram(name: "lround", linkageName: "_ZL6lroundf", scope: !101, file: !101, line: 137, type: !230, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!234 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !235, file: !101, line: 251)
!235 = !DISubprogram(name: "llround", linkageName: "_ZL7llroundf", scope: !101, file: !101, line: 138, type: !216, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!236 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !237, file: !101, line: 252)
!237 = !DISubprogram(name: "modf", linkageName: "_ZL4modffPf", scope: !101, file: !101, line: 140, type: !238, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!238 = !DISubroutineType(types: !239)
!239 = !{!109, !109, !240}
!240 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !109, size: 64)
!241 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !242, file: !101, line: 253)
!242 = !DISubprogram(name: "nan", linkageName: "_ZL3nanPKc", scope: !101, file: !101, line: 141, type: !243, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!243 = !DISubroutineType(types: !244)
!244 = !{!245, !246}
!245 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!246 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !247, size: 64)
!247 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !248)
!248 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!249 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !250, file: !101, line: 254)
!250 = !DISubprogram(name: "nanf", linkageName: "_ZL4nanfPKc", scope: !101, file: !101, line: 142, type: !251, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!251 = !DISubroutineType(types: !252)
!252 = !{!109, !246}
!253 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !254, file: !101, line: 255)
!254 = !DISubprogram(name: "nearbyint", linkageName: "_ZL9nearbyintf", scope: !101, file: !101, line: 144, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!255 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !256, file: !101, line: 256)
!256 = !DISubprogram(name: "nextafter", linkageName: "_ZL9nextafterff", scope: !101, file: !101, line: 146, type: !120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!257 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !258, file: !101, line: 257)
!258 = !DISubprogram(name: "pow", linkageName: "_ZL3powfi", scope: !101, file: !101, line: 150, type: !205, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!259 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !260, file: !101, line: 258)
!260 = !DISubprogram(name: "remainder", linkageName: "_ZL9remainderff", scope: !101, file: !101, line: 152, type: !120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!261 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !262, file: !101, line: 259)
!262 = !DISubprogram(name: "remquo", linkageName: "_ZL6remquoffPi", scope: !101, file: !101, line: 154, type: !263, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!263 = !DISubroutineType(types: !264)
!264 = !{!109, !109, !109, !168}
!265 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !266, file: !101, line: 260)
!266 = !DISubprogram(name: "rint", linkageName: "_ZL4rintf", scope: !101, file: !101, line: 156, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!267 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !268, file: !101, line: 261)
!268 = !DISubprogram(name: "round", linkageName: "_ZL5roundf", scope: !101, file: !101, line: 158, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!269 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !270, file: !101, line: 262)
!270 = !DISubprogram(name: "scalbln", linkageName: "_ZL7scalblnfl", scope: !101, file: !101, line: 160, type: !271, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!271 = !DISubroutineType(types: !272)
!272 = !{!109, !109, !202}
!273 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !274, file: !101, line: 263)
!274 = !DISubprogram(name: "scalbn", linkageName: "_ZL6scalbnfi", scope: !101, file: !101, line: 162, type: !205, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!275 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !276, file: !101, line: 264)
!276 = !DISubprogram(name: "signbit", linkageName: "_ZL7signbitf", scope: !101, file: !101, line: 167, type: !175, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!277 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !278, file: !101, line: 265)
!278 = !DISubprogram(name: "sin", linkageName: "_ZL3sinf", scope: !101, file: !101, line: 169, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!279 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !280, file: !101, line: 266)
!280 = !DISubprogram(name: "sinh", linkageName: "_ZL4sinhf", scope: !101, file: !101, line: 171, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!281 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !282, file: !101, line: 267)
!282 = !DISubprogram(name: "sqrt", linkageName: "_ZL4sqrtf", scope: !101, file: !101, line: 173, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!283 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !284, file: !101, line: 268)
!284 = !DISubprogram(name: "tan", linkageName: "_ZL3tanf", scope: !101, file: !101, line: 175, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!285 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !286, file: !101, line: 269)
!286 = !DISubprogram(name: "tanh", linkageName: "_ZL4tanhf", scope: !101, file: !101, line: 177, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!287 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !288, file: !101, line: 270)
!288 = !DISubprogram(name: "tgamma", linkageName: "_ZL6tgammaf", scope: !101, file: !101, line: 179, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!289 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !290, file: !101, line: 271)
!290 = !DISubprogram(name: "trunc", linkageName: "_ZL5truncf", scope: !101, file: !101, line: 181, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!291 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !292, file: !294, line: 52)
!292 = !DISubprogram(name: "abs", scope: !293, file: !293, line: 837, type: !102, flags: DIFlagPrototyped, spFlags: 0)
!293 = !DIFile(filename: "/usr/include/stdlib.h", directory: "")
!294 = !DIFile(filename: "/opt/rh/gcc-toolset-13/root/usr/lib/gcc/x86_64-redhat-linux/13/../../../../include/c++/13/bits/std_abs.h", directory: "")
!295 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !296, file: !300, line: 85)
!296 = !DISubprogram(name: "acos", scope: !297, file: !297, line: 53, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!297 = !DIFile(filename: "/usr/include/bits/mathcalls.h", directory: "")
!298 = !DISubroutineType(types: !299)
!299 = !{!245, !245}
!300 = !DIFile(filename: "/opt/rh/gcc-toolset-13/root/usr/lib/gcc/x86_64-redhat-linux/13/../../../../include/c++/13/cmath", directory: "")
!301 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !302, file: !300, line: 104)
!302 = !DISubprogram(name: "asin", scope: !297, file: !297, line: 55, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!303 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !304, file: !300, line: 123)
!304 = !DISubprogram(name: "atan", scope: !297, file: !297, line: 57, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!305 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !306, file: !300, line: 142)
!306 = !DISubprogram(name: "atan2", scope: !297, file: !297, line: 59, type: !307, flags: DIFlagPrototyped, spFlags: 0)
!307 = !DISubroutineType(types: !308)
!308 = !{!245, !245, !245}
!309 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !310, file: !300, line: 154)
!310 = !DISubprogram(name: "ceil", scope: !297, file: !297, line: 159, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!311 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !312, file: !300, line: 173)
!312 = !DISubprogram(name: "cos", scope: !297, file: !297, line: 62, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!313 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !314, file: !300, line: 192)
!314 = !DISubprogram(name: "cosh", scope: !297, file: !297, line: 71, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!315 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !316, file: !300, line: 211)
!316 = !DISubprogram(name: "exp", scope: !297, file: !297, line: 95, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!317 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !318, file: !300, line: 230)
!318 = !DISubprogram(name: "fabs", scope: !297, file: !297, line: 162, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!319 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !320, file: !300, line: 249)
!320 = !DISubprogram(name: "floor", scope: !297, file: !297, line: 165, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!321 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !322, file: !300, line: 268)
!322 = !DISubprogram(name: "fmod", scope: !297, file: !297, line: 168, type: !307, flags: DIFlagPrototyped, spFlags: 0)
!323 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !324, file: !300, line: 280)
!324 = !DISubprogram(name: "frexp", scope: !297, file: !297, line: 98, type: !325, flags: DIFlagPrototyped, spFlags: 0)
!325 = !DISubroutineType(types: !326)
!326 = !{!245, !245, !168}
!327 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !328, file: !300, line: 299)
!328 = !DISubprogram(name: "ldexp", scope: !297, file: !297, line: 101, type: !329, flags: DIFlagPrototyped, spFlags: 0)
!329 = !DISubroutineType(types: !330)
!330 = !{!245, !245, !104}
!331 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !332, file: !300, line: 318)
!332 = !DISubprogram(name: "log", scope: !297, file: !297, line: 104, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!333 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !334, file: !300, line: 337)
!334 = !DISubprogram(name: "log10", scope: !297, file: !297, line: 107, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!335 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !336, file: !300, line: 356)
!336 = !DISubprogram(name: "modf", scope: !297, file: !297, line: 110, type: !337, flags: DIFlagPrototyped, spFlags: 0)
!337 = !DISubroutineType(types: !338)
!338 = !{!245, !245, !339}
!339 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !245, size: 64)
!340 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !341, file: !300, line: 368)
!341 = !DISubprogram(name: "pow", scope: !297, file: !297, line: 140, type: !307, flags: DIFlagPrototyped, spFlags: 0)
!342 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !343, file: !300, line: 396)
!343 = !DISubprogram(name: "sin", scope: !297, file: !297, line: 64, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!344 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !345, file: !300, line: 415)
!345 = !DISubprogram(name: "sinh", scope: !297, file: !297, line: 73, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!346 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !347, file: !300, line: 434)
!347 = !DISubprogram(name: "sqrt", scope: !297, file: !297, line: 143, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!348 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !349, file: !300, line: 453)
!349 = !DISubprogram(name: "tan", scope: !297, file: !297, line: 66, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!350 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !351, file: !300, line: 472)
!351 = !DISubprogram(name: "tanh", scope: !297, file: !297, line: 75, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!352 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !353, file: !300, line: 1881)
!353 = !DIDerivedType(tag: DW_TAG_typedef, name: "double_t", file: !354, line: 150, baseType: !245)
!354 = !DIFile(filename: "/usr/include/math.h", directory: "")
!355 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !356, file: !300, line: 1882)
!356 = !DIDerivedType(tag: DW_TAG_typedef, name: "float_t", file: !354, line: 149, baseType: !109)
!357 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !358, file: !300, line: 1885)
!358 = !DISubprogram(name: "acosh", scope: !297, file: !297, line: 85, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!359 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !360, file: !300, line: 1886)
!360 = !DISubprogram(name: "acoshf", scope: !297, file: !297, line: 85, type: !107, flags: DIFlagPrototyped, spFlags: 0)
!361 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !362, file: !300, line: 1887)
!362 = !DISubprogram(name: "acoshl", scope: !297, file: !297, line: 85, type: !363, flags: DIFlagPrototyped, spFlags: 0)
!363 = !DISubroutineType(types: !364)
!364 = !{!365, !365}
!365 = !DIBasicType(name: "long double", size: 64, encoding: DW_ATE_float)
!366 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !367, file: !300, line: 1889)
!367 = !DISubprogram(name: "asinh", scope: !297, file: !297, line: 87, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!368 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !369, file: !300, line: 1890)
!369 = !DISubprogram(name: "asinhf", scope: !297, file: !297, line: 87, type: !107, flags: DIFlagPrototyped, spFlags: 0)
!370 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !371, file: !300, line: 1891)
!371 = !DISubprogram(name: "asinhl", scope: !297, file: !297, line: 87, type: !363, flags: DIFlagPrototyped, spFlags: 0)
!372 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !373, file: !300, line: 1893)
!373 = !DISubprogram(name: "atanh", scope: !297, file: !297, line: 89, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!374 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !375, file: !300, line: 1894)
!375 = !DISubprogram(name: "atanhf", scope: !297, file: !297, line: 89, type: !107, flags: DIFlagPrototyped, spFlags: 0)
!376 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !377, file: !300, line: 1895)
!377 = !DISubprogram(name: "atanhl", scope: !297, file: !297, line: 89, type: !363, flags: DIFlagPrototyped, spFlags: 0)
!378 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !379, file: !300, line: 1897)
!379 = !DISubprogram(name: "cbrt", scope: !297, file: !297, line: 152, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!380 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !381, file: !300, line: 1898)
!381 = !DISubprogram(name: "cbrtf", scope: !297, file: !297, line: 152, type: !107, flags: DIFlagPrototyped, spFlags: 0)
!382 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !383, file: !300, line: 1899)
!383 = !DISubprogram(name: "cbrtl", scope: !297, file: !297, line: 152, type: !363, flags: DIFlagPrototyped, spFlags: 0)
!384 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !385, file: !300, line: 1901)
!385 = !DISubprogram(name: "copysign", scope: !297, file: !297, line: 196, type: !307, flags: DIFlagPrototyped, spFlags: 0)
!386 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !387, file: !300, line: 1902)
!387 = !DISubprogram(name: "copysignf", scope: !297, file: !297, line: 196, type: !120, flags: DIFlagPrototyped, spFlags: 0)
!388 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !389, file: !300, line: 1903)
!389 = !DISubprogram(name: "copysignl", scope: !297, file: !297, line: 196, type: !390, flags: DIFlagPrototyped, spFlags: 0)
!390 = !DISubroutineType(types: !391)
!391 = !{!365, !365, !365}
!392 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !393, file: !300, line: 1905)
!393 = !DISubprogram(name: "erf", scope: !297, file: !297, line: 228, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!394 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !395, file: !300, line: 1906)
!395 = !DISubprogram(name: "erff", scope: !297, file: !297, line: 228, type: !107, flags: DIFlagPrototyped, spFlags: 0)
!396 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !397, file: !300, line: 1907)
!397 = !DISubprogram(name: "erfl", scope: !297, file: !297, line: 228, type: !363, flags: DIFlagPrototyped, spFlags: 0)
!398 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !399, file: !300, line: 1909)
!399 = !DISubprogram(name: "erfc", scope: !297, file: !297, line: 229, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!400 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !401, file: !300, line: 1910)
!401 = !DISubprogram(name: "erfcf", scope: !297, file: !297, line: 229, type: !107, flags: DIFlagPrototyped, spFlags: 0)
!402 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !403, file: !300, line: 1911)
!403 = !DISubprogram(name: "erfcl", scope: !297, file: !297, line: 229, type: !363, flags: DIFlagPrototyped, spFlags: 0)
!404 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !405, file: !300, line: 1913)
!405 = !DISubprogram(name: "exp2", scope: !297, file: !297, line: 130, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!406 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !407, file: !300, line: 1914)
!407 = !DISubprogram(name: "exp2f", scope: !297, file: !297, line: 130, type: !107, flags: DIFlagPrototyped, spFlags: 0)
!408 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !409, file: !300, line: 1915)
!409 = !DISubprogram(name: "exp2l", scope: !297, file: !297, line: 130, type: !363, flags: DIFlagPrototyped, spFlags: 0)
!410 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !411, file: !300, line: 1917)
!411 = !DISubprogram(name: "expm1", scope: !297, file: !297, line: 119, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!412 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !413, file: !300, line: 1918)
!413 = !DISubprogram(name: "expm1f", scope: !297, file: !297, line: 119, type: !107, flags: DIFlagPrototyped, spFlags: 0)
!414 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !415, file: !300, line: 1919)
!415 = !DISubprogram(name: "expm1l", scope: !297, file: !297, line: 119, type: !363, flags: DIFlagPrototyped, spFlags: 0)
!416 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !417, file: !300, line: 1921)
!417 = !DISubprogram(name: "fdim", scope: !297, file: !297, line: 326, type: !307, flags: DIFlagPrototyped, spFlags: 0)
!418 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !419, file: !300, line: 1922)
!419 = !DISubprogram(name: "fdimf", scope: !297, file: !297, line: 326, type: !120, flags: DIFlagPrototyped, spFlags: 0)
!420 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !421, file: !300, line: 1923)
!421 = !DISubprogram(name: "fdiml", scope: !297, file: !297, line: 326, type: !390, flags: DIFlagPrototyped, spFlags: 0)
!422 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !423, file: !300, line: 1925)
!423 = !DISubprogram(name: "fma", scope: !297, file: !297, line: 335, type: !424, flags: DIFlagPrototyped, spFlags: 0)
!424 = !DISubroutineType(types: !425)
!425 = !{!245, !245, !245, !245}
!426 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !427, file: !300, line: 1926)
!427 = !DISubprogram(name: "fmaf", scope: !297, file: !297, line: 335, type: !152, flags: DIFlagPrototyped, spFlags: 0)
!428 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !429, file: !300, line: 1927)
!429 = !DISubprogram(name: "fmal", scope: !297, file: !297, line: 335, type: !430, flags: DIFlagPrototyped, spFlags: 0)
!430 = !DISubroutineType(types: !431)
!431 = !{!365, !365, !365, !365}
!432 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !433, file: !300, line: 1929)
!433 = !DISubprogram(name: "fmax", scope: !297, file: !297, line: 329, type: !307, flags: DIFlagPrototyped, spFlags: 0)
!434 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !435, file: !300, line: 1930)
!435 = !DISubprogram(name: "fmaxf", scope: !297, file: !297, line: 329, type: !120, flags: DIFlagPrototyped, spFlags: 0)
!436 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !437, file: !300, line: 1931)
!437 = !DISubprogram(name: "fmaxl", scope: !297, file: !297, line: 329, type: !390, flags: DIFlagPrototyped, spFlags: 0)
!438 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !439, file: !300, line: 1933)
!439 = !DISubprogram(name: "fmin", scope: !297, file: !297, line: 332, type: !307, flags: DIFlagPrototyped, spFlags: 0)
!440 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !441, file: !300, line: 1934)
!441 = !DISubprogram(name: "fminf", scope: !297, file: !297, line: 332, type: !120, flags: DIFlagPrototyped, spFlags: 0)
!442 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !443, file: !300, line: 1935)
!443 = !DISubprogram(name: "fminl", scope: !297, file: !297, line: 332, type: !390, flags: DIFlagPrototyped, spFlags: 0)
!444 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !445, file: !300, line: 1937)
!445 = !DISubprogram(name: "hypot", scope: !297, file: !297, line: 147, type: !307, flags: DIFlagPrototyped, spFlags: 0)
!446 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !447, file: !300, line: 1938)
!447 = !DISubprogram(name: "hypotf", scope: !297, file: !297, line: 147, type: !120, flags: DIFlagPrototyped, spFlags: 0)
!448 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !449, file: !300, line: 1939)
!449 = !DISubprogram(name: "hypotl", scope: !297, file: !297, line: 147, type: !390, flags: DIFlagPrototyped, spFlags: 0)
!450 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !451, file: !300, line: 1941)
!451 = !DISubprogram(name: "ilogb", scope: !297, file: !297, line: 280, type: !452, flags: DIFlagPrototyped, spFlags: 0)
!452 = !DISubroutineType(types: !453)
!453 = !{!104, !245}
!454 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !455, file: !300, line: 1942)
!455 = !DISubprogram(name: "ilogbf", scope: !297, file: !297, line: 280, type: !162, flags: DIFlagPrototyped, spFlags: 0)
!456 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !457, file: !300, line: 1943)
!457 = !DISubprogram(name: "ilogbl", scope: !297, file: !297, line: 280, type: !458, flags: DIFlagPrototyped, spFlags: 0)
!458 = !DISubroutineType(types: !459)
!459 = !{!104, !365}
!460 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !461, file: !300, line: 1945)
!461 = !DISubprogram(name: "lgamma", scope: !297, file: !297, line: 230, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!462 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !463, file: !300, line: 1946)
!463 = !DISubprogram(name: "lgammaf", scope: !297, file: !297, line: 230, type: !107, flags: DIFlagPrototyped, spFlags: 0)
!464 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !465, file: !300, line: 1947)
!465 = !DISubprogram(name: "lgammal", scope: !297, file: !297, line: 230, type: !363, flags: DIFlagPrototyped, spFlags: 0)
!466 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !467, file: !300, line: 1950)
!467 = !DISubprogram(name: "llrint", scope: !297, file: !297, line: 316, type: !468, flags: DIFlagPrototyped, spFlags: 0)
!468 = !DISubroutineType(types: !469)
!469 = !{!213, !245}
!470 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !471, file: !300, line: 1951)
!471 = !DISubprogram(name: "llrintf", scope: !297, file: !297, line: 316, type: !216, flags: DIFlagPrototyped, spFlags: 0)
!472 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !473, file: !300, line: 1952)
!473 = !DISubprogram(name: "llrintl", scope: !297, file: !297, line: 316, type: !474, flags: DIFlagPrototyped, spFlags: 0)
!474 = !DISubroutineType(types: !475)
!475 = !{!213, !365}
!476 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !477, file: !300, line: 1954)
!477 = !DISubprogram(name: "llround", scope: !297, file: !297, line: 322, type: !468, flags: DIFlagPrototyped, spFlags: 0)
!478 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !479, file: !300, line: 1955)
!479 = !DISubprogram(name: "llroundf", scope: !297, file: !297, line: 322, type: !216, flags: DIFlagPrototyped, spFlags: 0)
!480 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !481, file: !300, line: 1956)
!481 = !DISubprogram(name: "llroundl", scope: !297, file: !297, line: 322, type: !474, flags: DIFlagPrototyped, spFlags: 0)
!482 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !483, file: !300, line: 1959)
!483 = !DISubprogram(name: "log1p", scope: !297, file: !297, line: 122, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!484 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !485, file: !300, line: 1960)
!485 = !DISubprogram(name: "log1pf", scope: !297, file: !297, line: 122, type: !107, flags: DIFlagPrototyped, spFlags: 0)
!486 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !487, file: !300, line: 1961)
!487 = !DISubprogram(name: "log1pl", scope: !297, file: !297, line: 122, type: !363, flags: DIFlagPrototyped, spFlags: 0)
!488 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !489, file: !300, line: 1963)
!489 = !DISubprogram(name: "log2", scope: !297, file: !297, line: 133, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!490 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !491, file: !300, line: 1964)
!491 = !DISubprogram(name: "log2f", scope: !297, file: !297, line: 133, type: !107, flags: DIFlagPrototyped, spFlags: 0)
!492 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !493, file: !300, line: 1965)
!493 = !DISubprogram(name: "log2l", scope: !297, file: !297, line: 133, type: !363, flags: DIFlagPrototyped, spFlags: 0)
!494 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !495, file: !300, line: 1967)
!495 = !DISubprogram(name: "logb", scope: !297, file: !297, line: 125, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!496 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !497, file: !300, line: 1968)
!497 = !DISubprogram(name: "logbf", scope: !297, file: !297, line: 125, type: !107, flags: DIFlagPrototyped, spFlags: 0)
!498 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !499, file: !300, line: 1969)
!499 = !DISubprogram(name: "logbl", scope: !297, file: !297, line: 125, type: !363, flags: DIFlagPrototyped, spFlags: 0)
!500 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !501, file: !300, line: 1971)
!501 = !DISubprogram(name: "lrint", scope: !297, file: !297, line: 314, type: !502, flags: DIFlagPrototyped, spFlags: 0)
!502 = !DISubroutineType(types: !503)
!503 = !{!202, !245}
!504 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !505, file: !300, line: 1972)
!505 = !DISubprogram(name: "lrintf", scope: !297, file: !297, line: 314, type: !230, flags: DIFlagPrototyped, spFlags: 0)
!506 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !507, file: !300, line: 1973)
!507 = !DISubprogram(name: "lrintl", scope: !297, file: !297, line: 314, type: !508, flags: DIFlagPrototyped, spFlags: 0)
!508 = !DISubroutineType(types: !509)
!509 = !{!202, !365}
!510 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !511, file: !300, line: 1975)
!511 = !DISubprogram(name: "lround", scope: !297, file: !297, line: 320, type: !502, flags: DIFlagPrototyped, spFlags: 0)
!512 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !513, file: !300, line: 1976)
!513 = !DISubprogram(name: "lroundf", scope: !297, file: !297, line: 320, type: !230, flags: DIFlagPrototyped, spFlags: 0)
!514 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !515, file: !300, line: 1977)
!515 = !DISubprogram(name: "lroundl", scope: !297, file: !297, line: 320, type: !508, flags: DIFlagPrototyped, spFlags: 0)
!516 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !517, file: !300, line: 1979)
!517 = !DISubprogram(name: "nan", scope: !297, file: !297, line: 201, type: !243, flags: DIFlagPrototyped, spFlags: 0)
!518 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !519, file: !300, line: 1980)
!519 = !DISubprogram(name: "nanf", scope: !297, file: !297, line: 201, type: !251, flags: DIFlagPrototyped, spFlags: 0)
!520 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !521, file: !300, line: 1981)
!521 = !DISubprogram(name: "nanl", scope: !297, file: !297, line: 201, type: !522, flags: DIFlagPrototyped, spFlags: 0)
!522 = !DISubroutineType(types: !523)
!523 = !{!365, !246}
!524 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !525, file: !300, line: 1983)
!525 = !DISubprogram(name: "nearbyint", scope: !297, file: !297, line: 294, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!526 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !527, file: !300, line: 1984)
!527 = !DISubprogram(name: "nearbyintf", scope: !297, file: !297, line: 294, type: !107, flags: DIFlagPrototyped, spFlags: 0)
!528 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !529, file: !300, line: 1985)
!529 = !DISubprogram(name: "nearbyintl", scope: !297, file: !297, line: 294, type: !363, flags: DIFlagPrototyped, spFlags: 0)
!530 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !531, file: !300, line: 1987)
!531 = !DISubprogram(name: "nextafter", scope: !297, file: !297, line: 259, type: !307, flags: DIFlagPrototyped, spFlags: 0)
!532 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !533, file: !300, line: 1988)
!533 = !DISubprogram(name: "nextafterf", scope: !297, file: !297, line: 259, type: !120, flags: DIFlagPrototyped, spFlags: 0)
!534 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !535, file: !300, line: 1989)
!535 = !DISubprogram(name: "nextafterl", scope: !297, file: !297, line: 259, type: !390, flags: DIFlagPrototyped, spFlags: 0)
!536 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !537, file: !300, line: 1991)
!537 = !DISubprogram(name: "nexttoward", scope: !297, file: !297, line: 261, type: !538, flags: DIFlagPrototyped, spFlags: 0)
!538 = !DISubroutineType(types: !539)
!539 = !{!245, !245, !365}
!540 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !541, file: !300, line: 1992)
!541 = !DISubprogram(name: "nexttowardf", scope: !297, file: !297, line: 261, type: !542, flags: DIFlagPrototyped, spFlags: 0)
!542 = !DISubroutineType(types: !543)
!543 = !{!109, !109, !365}
!544 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !545, file: !300, line: 1993)
!545 = !DISubprogram(name: "nexttowardl", scope: !297, file: !297, line: 261, type: !390, flags: DIFlagPrototyped, spFlags: 0)
!546 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !547, file: !300, line: 1995)
!547 = !DISubprogram(name: "remainder", scope: !297, file: !297, line: 272, type: !307, flags: DIFlagPrototyped, spFlags: 0)
!548 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !549, file: !300, line: 1996)
!549 = !DISubprogram(name: "remainderf", scope: !297, file: !297, line: 272, type: !120, flags: DIFlagPrototyped, spFlags: 0)
!550 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !551, file: !300, line: 1997)
!551 = !DISubprogram(name: "remainderl", scope: !297, file: !297, line: 272, type: !390, flags: DIFlagPrototyped, spFlags: 0)
!552 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !553, file: !300, line: 1999)
!553 = !DISubprogram(name: "remquo", scope: !297, file: !297, line: 307, type: !554, flags: DIFlagPrototyped, spFlags: 0)
!554 = !DISubroutineType(types: !555)
!555 = !{!245, !245, !245, !168}
!556 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !557, file: !300, line: 2000)
!557 = !DISubprogram(name: "remquof", scope: !297, file: !297, line: 307, type: !263, flags: DIFlagPrototyped, spFlags: 0)
!558 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !559, file: !300, line: 2001)
!559 = !DISubprogram(name: "remquol", scope: !297, file: !297, line: 307, type: !560, flags: DIFlagPrototyped, spFlags: 0)
!560 = !DISubroutineType(types: !561)
!561 = !{!365, !365, !365, !168}
!562 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !563, file: !300, line: 2003)
!563 = !DISubprogram(name: "rint", scope: !297, file: !297, line: 256, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!564 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !565, file: !300, line: 2004)
!565 = !DISubprogram(name: "rintf", scope: !297, file: !297, line: 256, type: !107, flags: DIFlagPrototyped, spFlags: 0)
!566 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !567, file: !300, line: 2005)
!567 = !DISubprogram(name: "rintl", scope: !297, file: !297, line: 256, type: !363, flags: DIFlagPrototyped, spFlags: 0)
!568 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !569, file: !300, line: 2007)
!569 = !DISubprogram(name: "round", scope: !297, file: !297, line: 298, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!570 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !571, file: !300, line: 2008)
!571 = !DISubprogram(name: "roundf", scope: !297, file: !297, line: 298, type: !107, flags: DIFlagPrototyped, spFlags: 0)
!572 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !573, file: !300, line: 2009)
!573 = !DISubprogram(name: "roundl", scope: !297, file: !297, line: 298, type: !363, flags: DIFlagPrototyped, spFlags: 0)
!574 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !575, file: !300, line: 2011)
!575 = !DISubprogram(name: "scalbln", scope: !297, file: !297, line: 290, type: !576, flags: DIFlagPrototyped, spFlags: 0)
!576 = !DISubroutineType(types: !577)
!577 = !{!245, !245, !202}
!578 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !579, file: !300, line: 2012)
!579 = !DISubprogram(name: "scalblnf", scope: !297, file: !297, line: 290, type: !271, flags: DIFlagPrototyped, spFlags: 0)
!580 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !581, file: !300, line: 2013)
!581 = !DISubprogram(name: "scalblnl", scope: !297, file: !297, line: 290, type: !582, flags: DIFlagPrototyped, spFlags: 0)
!582 = !DISubroutineType(types: !583)
!583 = !{!365, !365, !202}
!584 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !585, file: !300, line: 2015)
!585 = !DISubprogram(name: "scalbn", scope: !297, file: !297, line: 276, type: !329, flags: DIFlagPrototyped, spFlags: 0)
!586 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !587, file: !300, line: 2016)
!587 = !DISubprogram(name: "scalbnf", scope: !297, file: !297, line: 276, type: !205, flags: DIFlagPrototyped, spFlags: 0)
!588 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !589, file: !300, line: 2017)
!589 = !DISubprogram(name: "scalbnl", scope: !297, file: !297, line: 276, type: !590, flags: DIFlagPrototyped, spFlags: 0)
!590 = !DISubroutineType(types: !591)
!591 = !{!365, !365, !104}
!592 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !593, file: !300, line: 2019)
!593 = !DISubprogram(name: "tgamma", scope: !297, file: !297, line: 235, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!594 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !595, file: !300, line: 2020)
!595 = !DISubprogram(name: "tgammaf", scope: !297, file: !297, line: 235, type: !107, flags: DIFlagPrototyped, spFlags: 0)
!596 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !597, file: !300, line: 2021)
!597 = !DISubprogram(name: "tgammal", scope: !297, file: !297, line: 235, type: !363, flags: DIFlagPrototyped, spFlags: 0)
!598 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !599, file: !300, line: 2023)
!599 = !DISubprogram(name: "trunc", scope: !297, file: !297, line: 302, type: !298, flags: DIFlagPrototyped, spFlags: 0)
!600 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !601, file: !300, line: 2024)
!601 = !DISubprogram(name: "truncf", scope: !297, file: !297, line: 302, type: !107, flags: DIFlagPrototyped, spFlags: 0)
!602 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !603, file: !300, line: 2025)
!603 = !DISubprogram(name: "truncl", scope: !297, file: !297, line: 302, type: !363, flags: DIFlagPrototyped, spFlags: 0)
!604 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !605, entity: !606, file: !607, line: 58)
!605 = !DINamespace(name: "__gnu_debug", scope: null)
!606 = !DINamespace(name: "__debug", scope: !99)
!607 = !DIFile(filename: "/opt/rh/gcc-toolset-13/root/usr/lib/gcc/x86_64-redhat-linux/13/../../../../include/c++/13/debug/debug.h", directory: "")
!608 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !609, file: !611, line: 131)
!609 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !293, line: 62, baseType: !610)
!610 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !293, line: 58, size: 64, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!611 = !DIFile(filename: "/opt/rh/gcc-toolset-13/root/usr/lib/gcc/x86_64-redhat-linux/13/../../../../include/c++/13/cstdlib", directory: "")
!612 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !613, file: !611, line: 132)
!613 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !293, line: 70, baseType: !614)
!614 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !293, line: 66, size: 128, flags: DIFlagTypePassByValue, elements: !615, identifier: "_ZTS6ldiv_t")
!615 = !{!616, !617}
!616 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !614, file: !293, line: 68, baseType: !202, size: 64)
!617 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !614, file: !293, line: 69, baseType: !202, size: 64, offset: 64)
!618 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !619, file: !611, line: 134)
!619 = !DISubprogram(name: "abort", scope: !293, file: !293, line: 588, type: !620, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!620 = !DISubroutineType(types: !621)
!621 = !{null}
!622 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !623, file: !611, line: 136)
!623 = !DISubprogram(name: "aligned_alloc", scope: !293, file: !293, line: 583, type: !624, flags: DIFlagPrototyped, spFlags: 0)
!624 = !DISubroutineType(types: !625)
!625 = !{!626, !627, !627}
!626 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!627 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !628, line: 18, baseType: !629)
!628 = !DIFile(filename: "/storage/users/sislam3/opt/llvm-22/lib/clang/22/include/__stddef_size_t.h", directory: "")
!629 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!630 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !631, file: !611, line: 138)
!631 = !DISubprogram(name: "atexit", scope: !293, file: !293, line: 592, type: !632, flags: DIFlagPrototyped, spFlags: 0)
!632 = !DISubroutineType(types: !633)
!633 = !{!104, !634}
!634 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !620, size: 64)
!635 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !636, file: !611, line: 141)
!636 = !DISubprogram(name: "at_quick_exit", scope: !293, file: !293, line: 597, type: !632, flags: DIFlagPrototyped, spFlags: 0)
!637 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !638, file: !611, line: 144)
!638 = !DISubprogram(name: "atof", scope: !293, file: !293, line: 101, type: !243, flags: DIFlagPrototyped, spFlags: 0)
!639 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !640, file: !611, line: 145)
!640 = !DISubprogram(name: "atoi", scope: !293, file: !293, line: 104, type: !641, flags: DIFlagPrototyped, spFlags: 0)
!641 = !DISubroutineType(types: !642)
!642 = !{!104, !246}
!643 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !644, file: !611, line: 146)
!644 = !DISubprogram(name: "atol", scope: !293, file: !293, line: 107, type: !645, flags: DIFlagPrototyped, spFlags: 0)
!645 = !DISubroutineType(types: !646)
!646 = !{!202, !246}
!647 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !648, file: !611, line: 147)
!648 = !DISubprogram(name: "bsearch", scope: !293, file: !293, line: 817, type: !649, flags: DIFlagPrototyped, spFlags: 0)
!649 = !DISubroutineType(types: !650)
!650 = !{!626, !651, !651, !627, !627, !653}
!651 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !652, size: 64)
!652 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!653 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !293, line: 805, baseType: !654)
!654 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !655, size: 64)
!655 = !DISubroutineType(types: !656)
!656 = !{!104, !651, !651}
!657 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !658, file: !611, line: 148)
!658 = !DISubprogram(name: "calloc", scope: !293, file: !293, line: 541, type: !624, flags: DIFlagPrototyped, spFlags: 0)
!659 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !660, file: !611, line: 149)
!660 = !DISubprogram(name: "div", scope: !293, file: !293, line: 849, type: !661, flags: DIFlagPrototyped, spFlags: 0)
!661 = !DISubroutineType(types: !662)
!662 = !{!609, !104, !104}
!663 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !664, file: !611, line: 150)
!664 = !DISubprogram(name: "exit", scope: !293, file: !293, line: 614, type: !665, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!665 = !DISubroutineType(types: !666)
!666 = !{null, !104}
!667 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !668, file: !611, line: 151)
!668 = !DISubprogram(name: "free", scope: !293, file: !293, line: 563, type: !669, flags: DIFlagPrototyped, spFlags: 0)
!669 = !DISubroutineType(types: !670)
!670 = !{null, !626}
!671 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !672, file: !611, line: 152)
!672 = !DISubprogram(name: "getenv", scope: !293, file: !293, line: 631, type: !673, flags: DIFlagPrototyped, spFlags: 0)
!673 = !DISubroutineType(types: !674)
!674 = !{!675, !246}
!675 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !248, size: 64)
!676 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !677, file: !611, line: 153)
!677 = !DISubprogram(name: "labs", scope: !293, file: !293, line: 838, type: !200, flags: DIFlagPrototyped, spFlags: 0)
!678 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !679, file: !611, line: 154)
!679 = !DISubprogram(name: "ldiv", scope: !293, file: !293, line: 851, type: !680, flags: DIFlagPrototyped, spFlags: 0)
!680 = !DISubroutineType(types: !681)
!681 = !{!613, !202, !202}
!682 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !683, file: !611, line: 155)
!683 = !DISubprogram(name: "malloc", scope: !293, file: !293, line: 539, type: !684, flags: DIFlagPrototyped, spFlags: 0)
!684 = !DISubroutineType(types: !685)
!685 = !{!626, !627}
!686 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !687, file: !611, line: 157)
!687 = !DISubprogram(name: "mblen", scope: !293, file: !293, line: 919, type: !688, flags: DIFlagPrototyped, spFlags: 0)
!688 = !DISubroutineType(types: !689)
!689 = !{!104, !246, !627}
!690 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !691, file: !611, line: 158)
!691 = !DISubprogram(name: "mbstowcs", scope: !293, file: !293, line: 930, type: !692, flags: DIFlagPrototyped, spFlags: 0)
!692 = !DISubroutineType(types: !693)
!693 = !{!627, !694, !697, !627}
!694 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !695)
!695 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !696, size: 64)
!696 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!697 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !246)
!698 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !699, file: !611, line: 159)
!699 = !DISubprogram(name: "mbtowc", scope: !293, file: !293, line: 922, type: !700, flags: DIFlagPrototyped, spFlags: 0)
!700 = !DISubroutineType(types: !701)
!701 = !{!104, !694, !697, !627}
!702 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !703, file: !611, line: 161)
!703 = !DISubprogram(name: "qsort", scope: !293, file: !293, line: 827, type: !704, flags: DIFlagPrototyped, spFlags: 0)
!704 = !DISubroutineType(types: !705)
!705 = !{null, !626, !627, !627, !653}
!706 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !707, file: !611, line: 164)
!707 = !DISubprogram(name: "quick_exit", scope: !293, file: !293, line: 620, type: !665, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!708 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !709, file: !611, line: 167)
!709 = !DISubprogram(name: "rand", scope: !293, file: !293, line: 453, type: !710, flags: DIFlagPrototyped, spFlags: 0)
!710 = !DISubroutineType(types: !711)
!711 = !{!104}
!712 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !713, file: !611, line: 168)
!713 = !DISubprogram(name: "realloc", scope: !293, file: !293, line: 549, type: !714, flags: DIFlagPrototyped, spFlags: 0)
!714 = !DISubroutineType(types: !715)
!715 = !{!626, !626, !627}
!716 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !717, file: !611, line: 169)
!717 = !DISubprogram(name: "srand", scope: !293, file: !293, line: 455, type: !718, flags: DIFlagPrototyped, spFlags: 0)
!718 = !DISubroutineType(types: !719)
!719 = !{null, !45}
!720 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !721, file: !611, line: 170)
!721 = !DISubprogram(name: "strtod", scope: !293, file: !293, line: 117, type: !722, flags: DIFlagPrototyped, spFlags: 0)
!722 = !DISubroutineType(types: !723)
!723 = !{!245, !697, !724}
!724 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !725)
!725 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !675, size: 64)
!726 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !727, file: !611, line: 171)
!727 = !DISubprogram(name: "strtol", scope: !293, file: !293, line: 176, type: !728, flags: DIFlagPrototyped, spFlags: 0)
!728 = !DISubroutineType(types: !729)
!729 = !{!202, !697, !724, !104}
!730 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !731, file: !611, line: 172)
!731 = !DISubprogram(name: "strtoul", scope: !293, file: !293, line: 180, type: !732, flags: DIFlagPrototyped, spFlags: 0)
!732 = !DISubroutineType(types: !733)
!733 = !{!629, !697, !724, !104}
!734 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !735, file: !611, line: 173)
!735 = !DISubprogram(name: "system", scope: !293, file: !293, line: 781, type: !641, flags: DIFlagPrototyped, spFlags: 0)
!736 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !737, file: !611, line: 175)
!737 = !DISubprogram(name: "wcstombs", scope: !293, file: !293, line: 933, type: !738, flags: DIFlagPrototyped, spFlags: 0)
!738 = !DISubroutineType(types: !739)
!739 = !{!627, !740, !741, !627}
!740 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !675)
!741 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !742)
!742 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !743, size: 64)
!743 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !696)
!744 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !745, file: !611, line: 176)
!745 = !DISubprogram(name: "wctomb", scope: !293, file: !293, line: 926, type: !746, flags: DIFlagPrototyped, spFlags: 0)
!746 = !DISubroutineType(types: !747)
!747 = !{!104, !675, !696}
!748 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !749, entity: !750, file: !611, line: 204)
!749 = !DINamespace(name: "__gnu_cxx", scope: null)
!750 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !293, line: 80, baseType: !751)
!751 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !293, line: 76, size: 128, flags: DIFlagTypePassByValue, elements: !752, identifier: "_ZTS7lldiv_t")
!752 = !{!753, !754}
!753 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !751, file: !293, line: 78, baseType: !213, size: 64)
!754 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !751, file: !293, line: 79, baseType: !213, size: 64, offset: 64)
!755 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !749, entity: !756, file: !611, line: 210)
!756 = !DISubprogram(name: "_Exit", scope: !293, file: !293, line: 626, type: !665, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!757 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !749, entity: !758, file: !611, line: 214)
!758 = !DISubprogram(name: "llabs", scope: !293, file: !293, line: 841, type: !211, flags: DIFlagPrototyped, spFlags: 0)
!759 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !749, entity: !760, file: !611, line: 220)
!760 = !DISubprogram(name: "lldiv", scope: !293, file: !293, line: 855, type: !761, flags: DIFlagPrototyped, spFlags: 0)
!761 = !DISubroutineType(types: !762)
!762 = !{!750, !213, !213}
!763 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !749, entity: !764, file: !611, line: 231)
!764 = !DISubprogram(name: "atoll", scope: !293, file: !293, line: 112, type: !765, flags: DIFlagPrototyped, spFlags: 0)
!765 = !DISubroutineType(types: !766)
!766 = !{!213, !246}
!767 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !749, entity: !768, file: !611, line: 232)
!768 = !DISubprogram(name: "strtoll", scope: !293, file: !293, line: 200, type: !769, flags: DIFlagPrototyped, spFlags: 0)
!769 = !DISubroutineType(types: !770)
!770 = !{!213, !697, !724, !104}
!771 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !749, entity: !772, file: !611, line: 233)
!772 = !DISubprogram(name: "strtoull", scope: !293, file: !293, line: 205, type: !773, flags: DIFlagPrototyped, spFlags: 0)
!773 = !DISubroutineType(types: !774)
!774 = !{!15, !697, !724, !104}
!775 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !749, entity: !776, file: !611, line: 235)
!776 = !DISubprogram(name: "strtof", scope: !293, file: !293, line: 123, type: !777, flags: DIFlagPrototyped, spFlags: 0)
!777 = !DISubroutineType(types: !778)
!778 = !{!109, !697, !724}
!779 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !749, entity: !780, file: !611, line: 236)
!780 = !DISubprogram(name: "strtold", scope: !293, file: !293, line: 126, type: !781, flags: DIFlagPrototyped, spFlags: 0)
!781 = !DISubroutineType(types: !782)
!782 = !{!365, !697, !724}
!783 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !750, file: !611, line: 244)
!784 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !756, file: !611, line: 246)
!785 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !758, file: !611, line: 248)
!786 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !787, file: !611, line: 249)
!787 = !DISubprogram(name: "div", linkageName: "_ZN9__gnu_cxx3divExx", scope: !749, file: !611, line: 217, type: !761, flags: DIFlagPrototyped, spFlags: 0)
!788 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !760, file: !611, line: 250)
!789 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !764, file: !611, line: 252)
!790 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !776, file: !611, line: 253)
!791 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !768, file: !611, line: 254)
!792 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !772, file: !611, line: 255)
!793 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !780, file: !611, line: 256)
!794 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !619, file: !795, line: 38)
!795 = !DIFile(filename: "/opt/rh/gcc-toolset-13/root/usr/lib/gcc/x86_64-redhat-linux/13/../../../../include/c++/13/stdlib.h", directory: "")
!796 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !631, file: !795, line: 39)
!797 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !664, file: !795, line: 40)
!798 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !636, file: !795, line: 43)
!799 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !707, file: !795, line: 46)
!800 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !756, file: !795, line: 49)
!801 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !609, file: !795, line: 54)
!802 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !613, file: !795, line: 55)
!803 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !804, file: !795, line: 57)
!804 = !DISubprogram(name: "abs", linkageName: "_ZSt3absg", scope: !99, file: !294, line: 137, type: !805, flags: DIFlagPrototyped, spFlags: 0)
!805 = !DISubroutineType(types: !806)
!806 = !{!807, !807}
!807 = !DIBasicType(name: "__float128", size: 128, encoding: DW_ATE_float)
!808 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !638, file: !795, line: 58)
!809 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !640, file: !795, line: 59)
!810 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !644, file: !795, line: 60)
!811 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !648, file: !795, line: 61)
!812 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !658, file: !795, line: 62)
!813 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !787, file: !795, line: 63)
!814 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !668, file: !795, line: 64)
!815 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !672, file: !795, line: 65)
!816 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !677, file: !795, line: 66)
!817 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !679, file: !795, line: 67)
!818 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !683, file: !795, line: 68)
!819 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !687, file: !795, line: 70)
!820 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !691, file: !795, line: 71)
!821 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !699, file: !795, line: 72)
!822 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !703, file: !795, line: 74)
!823 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !709, file: !795, line: 75)
!824 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !713, file: !795, line: 76)
!825 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !717, file: !795, line: 77)
!826 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !721, file: !795, line: 78)
!827 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !727, file: !795, line: 79)
!828 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !731, file: !795, line: 80)
!829 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !735, file: !795, line: 81)
!830 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !737, file: !795, line: 83)
!831 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !745, file: !795, line: 84)
!832 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !833, file: !835, line: 443)
!833 = !DISubprogram(name: "acosf", linkageName: "_ZL5acosff", scope: !834, file: !834, line: 63, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!834 = !DIFile(filename: "/storage/users/sislam3/opt/llvm-22/lib/clang/22/include/__clang_cuda_math.h", directory: "")
!835 = !DIFile(filename: "/storage/users/sislam3/opt/llvm-22/lib/clang/22/include/__clang_cuda_cmath.h", directory: "")
!836 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !837, file: !835, line: 444)
!837 = !DISubprogram(name: "acoshf", linkageName: "_ZL6acoshff", scope: !834, file: !834, line: 65, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!838 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !839, file: !835, line: 445)
!839 = !DISubprogram(name: "asinf", linkageName: "_ZL5asinff", scope: !834, file: !834, line: 67, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!840 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !841, file: !835, line: 446)
!841 = !DISubprogram(name: "asinhf", linkageName: "_ZL6asinhff", scope: !834, file: !834, line: 69, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!842 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !843, file: !835, line: 447)
!843 = !DISubprogram(name: "atan2f", linkageName: "_ZL6atan2fff", scope: !834, file: !834, line: 72, type: !120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!844 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !845, file: !835, line: 448)
!845 = !DISubprogram(name: "atanf", linkageName: "_ZL5atanff", scope: !834, file: !834, line: 73, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!846 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !847, file: !835, line: 449)
!847 = !DISubprogram(name: "atanhf", linkageName: "_ZL6atanhff", scope: !834, file: !834, line: 75, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!848 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !849, file: !835, line: 450)
!849 = !DISubprogram(name: "cbrtf", linkageName: "_ZL5cbrtff", scope: !834, file: !834, line: 77, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!850 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !851, file: !835, line: 451)
!851 = !DISubprogram(name: "ceilf", linkageName: "_ZL5ceilff", scope: !834, file: !834, line: 79, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!852 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !853, file: !835, line: 452)
!853 = !DISubprogram(name: "copysignf", linkageName: "_ZL9copysignfff", scope: !834, file: !834, line: 83, type: !120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!854 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !855, file: !835, line: 453)
!855 = !DISubprogram(name: "cosf", linkageName: "_ZL4cosff", scope: !834, file: !834, line: 87, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!856 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !857, file: !835, line: 454)
!857 = !DISubprogram(name: "coshf", linkageName: "_ZL5coshff", scope: !834, file: !834, line: 91, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!858 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !859, file: !835, line: 455)
!859 = !DISubprogram(name: "erfcf", linkageName: "_ZL5erfcff", scope: !834, file: !834, line: 100, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!860 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !861, file: !835, line: 456)
!861 = !DISubprogram(name: "erff", linkageName: "_ZL4erfff", scope: !834, file: !834, line: 105, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!862 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !863, file: !835, line: 457)
!863 = !DISubprogram(name: "exp2f", linkageName: "_ZL5exp2ff", scope: !834, file: !834, line: 112, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!864 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !865, file: !835, line: 458)
!865 = !DISubprogram(name: "expf", linkageName: "_ZL4expff", scope: !834, file: !834, line: 113, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!866 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !867, file: !835, line: 459)
!867 = !DISubprogram(name: "expm1f", linkageName: "_ZL6expm1ff", scope: !834, file: !834, line: 115, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!868 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !869, file: !835, line: 460)
!869 = distinct !DISubprogram(name: "fabsf", linkageName: "_ZL5fabsff", scope: !834, file: !834, line: 116, type: !107, scopeLine: 116, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !6, retainedNodes: !870)
!870 = !{}
!871 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !872, file: !835, line: 461)
!872 = !DISubprogram(name: "fdimf", linkageName: "_ZL5fdimfff", scope: !834, file: !834, line: 118, type: !120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!873 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !874, file: !835, line: 462)
!874 = !DISubprogram(name: "floorf", linkageName: "_ZL6floorff", scope: !834, file: !834, line: 128, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!875 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !876, file: !835, line: 463)
!876 = !DISubprogram(name: "fmaf", linkageName: "_ZL4fmaffff", scope: !834, file: !834, line: 132, type: !152, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!877 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !878, file: !835, line: 464)
!878 = !DISubprogram(name: "fmaxf", linkageName: "_ZL5fmaxfff", scope: !834, file: !834, line: 136, type: !120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!879 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !880, file: !835, line: 465)
!880 = !DISubprogram(name: "fminf", linkageName: "_ZL5fminfff", scope: !834, file: !834, line: 138, type: !120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!881 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !882, file: !835, line: 466)
!882 = !DISubprogram(name: "fmodf", linkageName: "_ZL5fmodfff", scope: !834, file: !834, line: 140, type: !120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!883 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !884, file: !835, line: 467)
!884 = !DISubprogram(name: "frexpf", linkageName: "_ZL6frexpffPi", scope: !834, file: !834, line: 142, type: !166, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!885 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !886, file: !835, line: 468)
!886 = !DISubprogram(name: "hypotf", linkageName: "_ZL6hypotfff", scope: !834, file: !834, line: 144, type: !120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!887 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !888, file: !835, line: 469)
!888 = !DISubprogram(name: "ilogbf", linkageName: "_ZL6ilogbff", scope: !834, file: !834, line: 146, type: !162, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!889 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !890, file: !835, line: 470)
!890 = !DISubprogram(name: "ldexpf", linkageName: "_ZL6ldexpffi", scope: !834, file: !834, line: 159, type: !205, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!891 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !892, file: !835, line: 471)
!892 = !DISubprogram(name: "lgammaf", linkageName: "_ZL7lgammaff", scope: !834, file: !834, line: 161, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!893 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !894, file: !835, line: 472)
!894 = !DISubprogram(name: "llrintf", linkageName: "_ZL7llrintff", scope: !834, file: !834, line: 170, type: !216, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!895 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !896, file: !835, line: 473)
!896 = !DISubprogram(name: "llroundf", linkageName: "_ZL8llroundff", scope: !834, file: !834, line: 172, type: !216, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!897 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !898, file: !835, line: 474)
!898 = !DISubprogram(name: "log10f", linkageName: "_ZL6log10ff", scope: !834, file: !834, line: 177, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!899 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !900, file: !835, line: 475)
!900 = !DISubprogram(name: "log1pf", linkageName: "_ZL6log1pff", scope: !834, file: !834, line: 179, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!901 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !902, file: !835, line: 476)
!902 = !DISubprogram(name: "log2f", linkageName: "_ZL5log2ff", scope: !834, file: !834, line: 181, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!903 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !904, file: !835, line: 477)
!904 = !DISubprogram(name: "logbf", linkageName: "_ZL5logbff", scope: !834, file: !834, line: 185, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!905 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !906, file: !835, line: 478)
!906 = !DISubprogram(name: "logf", linkageName: "_ZL4logff", scope: !834, file: !834, line: 186, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!907 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !908, file: !835, line: 479)
!908 = !DISubprogram(name: "lrintf", linkageName: "_ZL6lrintff", scope: !834, file: !834, line: 191, type: !230, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!909 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !910, file: !835, line: 480)
!910 = !DISubprogram(name: "lroundf", linkageName: "_ZL7lroundff", scope: !834, file: !834, line: 193, type: !230, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!911 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !912, file: !835, line: 481)
!912 = !DISubprogram(name: "modff", linkageName: "_ZL5modfffPf", scope: !834, file: !834, line: 203, type: !238, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!913 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !914, file: !835, line: 482)
!914 = !DISubprogram(name: "nearbyintf", linkageName: "_ZL10nearbyintff", scope: !834, file: !834, line: 205, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!915 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !916, file: !835, line: 483)
!916 = !DISubprogram(name: "nextafterf", linkageName: "_ZL10nextafterfff", scope: !834, file: !834, line: 209, type: !120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!917 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !918, file: !835, line: 484)
!918 = !DISubprogram(name: "powf", linkageName: "_ZL4powfff", scope: !834, file: !834, line: 235, type: !120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!919 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !920, file: !835, line: 485)
!920 = !DISubprogram(name: "remainderf", linkageName: "_ZL10remainderfff", scope: !834, file: !834, line: 243, type: !120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!921 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !922, file: !835, line: 486)
!922 = !DISubprogram(name: "remquof", linkageName: "_ZL7remquofffPi", scope: !834, file: !834, line: 249, type: !263, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!923 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !924, file: !835, line: 487)
!924 = !DISubprogram(name: "rintf", linkageName: "_ZL5rintff", scope: !834, file: !834, line: 260, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!925 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !926, file: !835, line: 488)
!926 = !DISubprogram(name: "roundf", linkageName: "_ZL6roundff", scope: !834, file: !834, line: 174, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!927 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !928, file: !835, line: 489)
!928 = !DISubprogram(name: "scalblnf", linkageName: "_ZL8scalblnffl", scope: !834, file: !834, line: 290, type: !271, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!929 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !930, file: !835, line: 490)
!930 = !DISubprogram(name: "scalbnf", linkageName: "_ZL7scalbnffi", scope: !834, file: !834, line: 282, type: !205, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!931 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !932, file: !835, line: 491)
!932 = !DISubprogram(name: "sinf", linkageName: "_ZL4sinff", scope: !834, file: !834, line: 310, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!933 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !934, file: !835, line: 492)
!934 = !DISubprogram(name: "sinhf", linkageName: "_ZL5sinhff", scope: !834, file: !834, line: 314, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!935 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !936, file: !835, line: 493)
!936 = !DISubprogram(name: "sqrtf", linkageName: "_ZL5sqrtff", scope: !834, file: !834, line: 318, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!937 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !938, file: !835, line: 494)
!938 = !DISubprogram(name: "tanf", linkageName: "_ZL4tanff", scope: !834, file: !834, line: 320, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!939 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !940, file: !835, line: 495)
!940 = !DISubprogram(name: "tanhf", linkageName: "_ZL5tanhff", scope: !834, file: !834, line: 322, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!941 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !942, file: !835, line: 496)
!942 = !DISubprogram(name: "tgammaf", linkageName: "_ZL7tgammaff", scope: !834, file: !834, line: 324, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!943 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !99, entity: !944, file: !835, line: 497)
!944 = !DISubprogram(name: "truncf", linkageName: "_ZL6truncff", scope: !834, file: !834, line: 326, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!945 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !9, file: !10, line: 181)
!946 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !34, file: !10, line: 182)
!947 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !948, file: !10, line: 208)
!948 = !DISubprogram(name: "is_exactly", linkageName: "_ZN2nv6target6detail10is_exactlyENS1_11sm_selectorE", scope: !11, file: !10, line: 153, type: !949, flags: DIFlagPrototyped, spFlags: 0)
!949 = !DISubroutineType(types: !950)
!950 = !{!34, !9}
!951 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !952, file: !10, line: 209)
!952 = !DISubprogram(name: "provides", linkageName: "_ZN2nv6target6detail8providesENS1_11sm_selectorE", scope: !11, file: !10, line: 158, type: !949, flags: DIFlagPrototyped, spFlags: 0)
!953 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !804, file: !954, line: 38)
!954 = !DIFile(filename: "/opt/rh/gcc-toolset-13/root/usr/lib/gcc/x86_64-redhat-linux/13/../../../../include/c++/13/math.h", directory: "")
!955 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !956, file: !954, line: 54)
!956 = !DISubprogram(name: "modf", linkageName: "_ZSt4modfePe", scope: !99, file: !300, line: 364, type: !957, flags: DIFlagPrototyped, spFlags: 0)
!957 = !DISubroutineType(types: !958)
!958 = !{!365, !365, !959}
!959 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !365, size: 64)
!960 = !{!"clang version 22.1.5 (https://github.com/llvm/llvm-project.git 5ea218a153f4d2f815b8244eab3e4b4ba5e00e6c)"}
!961 = !{!"clang version 3.8.0 (tags/RELEASE_380/final)"}
!962 = !{i32 2, i32 0}
!963 = distinct !DISubprogram(name: "is_subnormal", linkageName: "_Z12is_subnormalf", scope: !7, file: !7, line: 7, type: !175, scopeLine: 7, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !6, retainedNodes: !870)
!964 = !DILocalVariable(name: "x", arg: 1, scope: !963, file: !7, line: 7, type: !109)
!965 = !DILocation(line: 7, column: 36, scope: !963)
!966 = !DILocation(line: 8, column: 13, scope: !963)
!967 = !DILocation(line: 8, column: 15, scope: !963)
!968 = !DILocation(line: 8, column: 24, scope: !963)
!969 = !DILocation(line: 8, column: 34, scope: !963)
!970 = !DILocalVariable(name: "__a", arg: 1, scope: !869, file: !834, line: 116, type: !109)
!971 = !DILocation(line: 116, column: 30, scope: !869, inlinedAt: !972)
!972 = distinct !DILocation(line: 8, column: 28, scope: !963)
!973 = !DILocation(line: 116, column: 55, scope: !869, inlinedAt: !972)
!974 = !DILocation(line: 116, column: 44, scope: !869, inlinedAt: !972)
!975 = !DILocation(line: 8, column: 37, scope: !963)
!976 = !DILocation(line: 0, scope: !963)
!977 = !DILocation(line: 8, column: 5, scope: !963)
!978 = distinct !DISubprogram(name: "testUnderflow_RoundNearest", linkageName: "_Z26testUnderflow_RoundNearestPfPi", scope: !7, file: !7, line: 11, type: !979, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !6, retainedNodes: !870)
!979 = !DISubroutineType(types: !980)
!980 = !{null, !240, !168}
!981 = !DILocalVariable(name: "result", arg: 1, scope: !978, file: !7, line: 11, type: !240)
!982 = !DILocation(line: 11, column: 51, scope: !978)
!983 = !DILocalVariable(name: "is_denormal", arg: 2, scope: !978, file: !7, line: 11, type: !168)
!984 = !DILocation(line: 11, column: 64, scope: !978)
!985 = !DILocalVariable(name: "idx", scope: !978, file: !7, line: 12, type: !104)
!986 = !DILocation(line: 12, column: 9, scope: !978)
!987 = !DILocation(line: 53, column: 27, scope: !988, inlinedAt: !989)
!988 = distinct !DISubprogram(name: "__fetch_builtin_x", linkageName: "_ZN26__cuda_builtin_threadIdx_t17__fetch_builtin_xEv", scope: !66, file: !67, line: 53, type: !70, scopeLine: 53, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !6, declaration: !69)
!989 = distinct !DILocation(line: 12, column: 15, scope: !978)
!990 = !DILocalVariable(name: "tiny", scope: !978, file: !7, line: 14, type: !109)
!991 = !DILocation(line: 14, column: 11, scope: !978)
!992 = !DILocation(line: 18, column: 9, scope: !993)
!993 = distinct !DILexicalBlock(scope: !978, file: !7, line: 18, column: 9)
!994 = !DILocation(line: 18, column: 13, scope: !993)
!995 = !DILocation(line: 20, column: 31, scope: !996)
!996 = distinct !DILexicalBlock(scope: !993, file: !7, line: 18, column: 19)
!997 = !DILocalVariable(name: "__a", arg: 1, scope: !998, file: !999, line: 212, type: !109)
!998 = distinct !DISubprogram(name: "__fdiv_rn", linkageName: "_ZL9__fdiv_rnff", scope: !999, file: !999, line: 212, type: !120, scopeLine: 212, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !6, retainedNodes: !870)
!999 = !DIFile(filename: "/storage/users/sislam3/opt/llvm-22/lib/clang/22/include/__clang_cuda_device_functions.h", directory: "")
!1000 = !DILocation(line: 212, column: 34, scope: !998, inlinedAt: !1001)
!1001 = distinct !DILocation(line: 20, column: 21, scope: !996)
!1002 = !DILocalVariable(name: "__b", arg: 2, scope: !998, file: !999, line: 212, type: !109)
!1003 = !DILocation(line: 212, column: 45, scope: !998, inlinedAt: !1001)
!1004 = !DILocation(line: 213, column: 23, scope: !998, inlinedAt: !1001)
!1005 = !DILocation(line: 213, column: 28, scope: !998, inlinedAt: !1001)
!1006 = !DILocation(line: 213, column: 10, scope: !998, inlinedAt: !1001)
!1007 = !DILocation(line: 20, column: 9, scope: !996)
!1008 = !DILocation(line: 20, column: 19, scope: !996)
!1009 = !DILocation(line: 21, column: 39, scope: !996)
!1010 = !DILocation(line: 21, column: 26, scope: !996)
!1011 = !DILocation(line: 21, column: 9, scope: !996)
!1012 = !DILocation(line: 21, column: 24, scope: !996)
!1013 = !DILocation(line: 22, column: 5, scope: !996)
!1014 = !DILocation(line: 24, column: 9, scope: !1015)
!1015 = distinct !DILexicalBlock(scope: !978, file: !7, line: 24, column: 9)
!1016 = !DILocation(line: 24, column: 13, scope: !1015)
!1017 = !DILocation(line: 26, column: 31, scope: !1018)
!1018 = distinct !DILexicalBlock(scope: !1015, file: !7, line: 24, column: 19)
!1019 = !DILocalVariable(name: "__a", arg: 1, scope: !1020, file: !999, line: 306, type: !109)
!1020 = distinct !DISubprogram(name: "__fmul_rn", linkageName: "_ZL9__fmul_rnff", scope: !999, file: !999, line: 306, type: !120, scopeLine: 306, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !6, retainedNodes: !870)
!1021 = !DILocation(line: 306, column: 34, scope: !1020, inlinedAt: !1022)
!1022 = distinct !DILocation(line: 26, column: 21, scope: !1018)
!1023 = !DILocalVariable(name: "__b", arg: 2, scope: !1020, file: !999, line: 306, type: !109)
!1024 = !DILocation(line: 306, column: 45, scope: !1020, inlinedAt: !1022)
!1025 = !DILocation(line: 307, column: 23, scope: !1020, inlinedAt: !1022)
!1026 = !DILocation(line: 307, column: 28, scope: !1020, inlinedAt: !1022)
!1027 = !DILocation(line: 307, column: 10, scope: !1020, inlinedAt: !1022)
!1028 = !DILocation(line: 26, column: 9, scope: !1018)
!1029 = !DILocation(line: 26, column: 19, scope: !1018)
!1030 = !DILocation(line: 27, column: 39, scope: !1018)
!1031 = !DILocation(line: 27, column: 26, scope: !1018)
!1032 = !DILocation(line: 27, column: 9, scope: !1018)
!1033 = !DILocation(line: 27, column: 24, scope: !1018)
!1034 = !DILocation(line: 28, column: 5, scope: !1018)
!1035 = !DILocation(line: 30, column: 9, scope: !1036)
!1036 = distinct !DILexicalBlock(scope: !978, file: !7, line: 30, column: 9)
!1037 = !DILocation(line: 30, column: 13, scope: !1036)
!1038 = !DILocation(line: 32, column: 31, scope: !1039)
!1039 = distinct !DILexicalBlock(scope: !1036, file: !7, line: 30, column: 19)
!1040 = !DILocation(line: 306, column: 34, scope: !1020, inlinedAt: !1041)
!1041 = distinct !DILocation(line: 32, column: 21, scope: !1039)
!1042 = !DILocation(line: 306, column: 45, scope: !1020, inlinedAt: !1041)
!1043 = !DILocation(line: 307, column: 23, scope: !1020, inlinedAt: !1041)
!1044 = !DILocation(line: 307, column: 28, scope: !1020, inlinedAt: !1041)
!1045 = !DILocation(line: 307, column: 10, scope: !1020, inlinedAt: !1041)
!1046 = !DILocation(line: 32, column: 9, scope: !1039)
!1047 = !DILocation(line: 32, column: 19, scope: !1039)
!1048 = !DILocation(line: 33, column: 39, scope: !1039)
!1049 = !DILocation(line: 33, column: 26, scope: !1039)
!1050 = !DILocation(line: 33, column: 9, scope: !1039)
!1051 = !DILocation(line: 33, column: 24, scope: !1039)
!1052 = !DILocation(line: 34, column: 5, scope: !1039)
!1053 = !DILocation(line: 36, column: 9, scope: !1054)
!1054 = distinct !DILexicalBlock(scope: !978, file: !7, line: 36, column: 9)
!1055 = !DILocation(line: 36, column: 13, scope: !1054)
!1056 = !DILocalVariable(name: "a", scope: !1057, file: !7, line: 38, type: !109)
!1057 = distinct !DILexicalBlock(scope: !1054, file: !7, line: 36, column: 19)
!1058 = !DILocation(line: 38, column: 15, scope: !1057)
!1059 = !DILocation(line: 38, column: 19, scope: !1057)
!1060 = !DILocation(line: 38, column: 24, scope: !1057)
!1061 = !DILocalVariable(name: "b", scope: !1057, file: !7, line: 39, type: !109)
!1062 = !DILocation(line: 39, column: 15, scope: !1057)
!1063 = !DILocation(line: 39, column: 19, scope: !1057)
!1064 = !DILocation(line: 40, column: 31, scope: !1057)
!1065 = !DILocation(line: 40, column: 34, scope: !1057)
!1066 = !DILocalVariable(name: "__a", arg: 1, scope: !1067, file: !999, line: 327, type: !109)
!1067 = distinct !DISubprogram(name: "__fsub_rn", linkageName: "_ZL9__fsub_rnff", scope: !999, file: !999, line: 327, type: !120, scopeLine: 327, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !6, retainedNodes: !870)
!1068 = !DILocation(line: 327, column: 34, scope: !1067, inlinedAt: !1069)
!1069 = distinct !DILocation(line: 40, column: 21, scope: !1057)
!1070 = !DILocalVariable(name: "__b", arg: 2, scope: !1067, file: !999, line: 327, type: !109)
!1071 = !DILocation(line: 327, column: 45, scope: !1067, inlinedAt: !1069)
!1072 = !DILocation(line: 328, column: 23, scope: !1067, inlinedAt: !1069)
!1073 = !DILocation(line: 328, column: 28, scope: !1067, inlinedAt: !1069)
!1074 = !DILocation(line: 328, column: 10, scope: !1067, inlinedAt: !1069)
!1075 = !{i32 9580}
!1076 = !DILocation(line: 40, column: 9, scope: !1057)
!1077 = !DILocation(line: 40, column: 19, scope: !1057)
!1078 = !DILocation(line: 41, column: 39, scope: !1057)
!1079 = !DILocation(line: 41, column: 26, scope: !1057)
!1080 = !DILocation(line: 41, column: 9, scope: !1057)
!1081 = !DILocation(line: 41, column: 24, scope: !1057)
!1082 = !DILocation(line: 42, column: 5, scope: !1057)
!1083 = !DILocation(line: 44, column: 9, scope: !1084)
!1084 = distinct !DILexicalBlock(scope: !978, file: !7, line: 44, column: 9)
!1085 = !DILocation(line: 44, column: 13, scope: !1084)
!1086 = !DILocation(line: 46, column: 31, scope: !1087)
!1087 = distinct !DILexicalBlock(scope: !1084, file: !7, line: 44, column: 19)
!1088 = !DILocalVariable(name: "__a", arg: 1, scope: !1089, file: !999, line: 294, type: !109)
!1089 = distinct !DISubprogram(name: "__fmaf_rn", linkageName: "_ZL9__fmaf_rnfff", scope: !999, file: !999, line: 294, type: !152, scopeLine: 294, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !6, retainedNodes: !870)
!1090 = !DILocation(line: 294, column: 34, scope: !1089, inlinedAt: !1091)
!1091 = distinct !DILocation(line: 46, column: 21, scope: !1087)
!1092 = !DILocalVariable(name: "__b", arg: 2, scope: !1089, file: !999, line: 294, type: !109)
!1093 = !DILocation(line: 294, column: 45, scope: !1089, inlinedAt: !1091)
!1094 = !DILocalVariable(name: "__c", arg: 3, scope: !1089, file: !999, line: 294, type: !109)
!1095 = !DILocation(line: 294, column: 56, scope: !1089, inlinedAt: !1091)
!1096 = !DILocation(line: 295, column: 23, scope: !1089, inlinedAt: !1091)
!1097 = !DILocation(line: 295, column: 28, scope: !1089, inlinedAt: !1091)
!1098 = !DILocation(line: 295, column: 33, scope: !1089, inlinedAt: !1091)
!1099 = !DILocation(line: 295, column: 10, scope: !1089, inlinedAt: !1091)
!1100 = !DILocation(line: 46, column: 9, scope: !1087)
!1101 = !DILocation(line: 46, column: 19, scope: !1087)
!1102 = !DILocation(line: 47, column: 39, scope: !1087)
!1103 = !DILocation(line: 47, column: 26, scope: !1087)
!1104 = !DILocation(line: 47, column: 9, scope: !1087)
!1105 = !DILocation(line: 47, column: 24, scope: !1087)
!1106 = !DILocation(line: 48, column: 5, scope: !1087)
!1107 = !DILocation(line: 49, column: 1, scope: !978)
!1108 = distinct !DISubprogram(name: "testUnderflow_RoundZero", linkageName: "_Z23testUnderflow_RoundZeroPfPi", scope: !7, file: !7, line: 51, type: !979, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !6, retainedNodes: !870)
!1109 = !DILocalVariable(name: "result", arg: 1, scope: !1108, file: !7, line: 51, type: !240)
!1110 = !DILocation(line: 51, column: 48, scope: !1108)
!1111 = !DILocalVariable(name: "is_denormal", arg: 2, scope: !1108, file: !7, line: 51, type: !168)
!1112 = !DILocation(line: 51, column: 61, scope: !1108)
!1113 = !DILocalVariable(name: "idx", scope: !1108, file: !7, line: 52, type: !104)
!1114 = !DILocation(line: 52, column: 9, scope: !1108)
!1115 = !DILocation(line: 53, column: 27, scope: !988, inlinedAt: !1116)
!1116 = distinct !DILocation(line: 52, column: 15, scope: !1108)
!1117 = !DILocalVariable(name: "tiny", scope: !1108, file: !7, line: 54, type: !109)
!1118 = !DILocation(line: 54, column: 11, scope: !1108)
!1119 = !DILocation(line: 58, column: 9, scope: !1120)
!1120 = distinct !DILexicalBlock(scope: !1108, file: !7, line: 58, column: 9)
!1121 = !DILocation(line: 58, column: 13, scope: !1120)
!1122 = !DILocation(line: 59, column: 31, scope: !1123)
!1123 = distinct !DILexicalBlock(scope: !1120, file: !7, line: 58, column: 19)
!1124 = !DILocalVariable(name: "__a", arg: 1, scope: !1125, file: !999, line: 218, type: !109)
!1125 = distinct !DISubprogram(name: "__fdiv_rz", linkageName: "_ZL9__fdiv_rzff", scope: !999, file: !999, line: 218, type: !120, scopeLine: 218, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !6, retainedNodes: !870)
!1126 = !DILocation(line: 218, column: 34, scope: !1125, inlinedAt: !1127)
!1127 = distinct !DILocation(line: 59, column: 21, scope: !1123)
!1128 = !DILocalVariable(name: "__b", arg: 2, scope: !1125, file: !999, line: 218, type: !109)
!1129 = !DILocation(line: 218, column: 45, scope: !1125, inlinedAt: !1127)
!1130 = !DILocation(line: 219, column: 23, scope: !1125, inlinedAt: !1127)
!1131 = !DILocation(line: 219, column: 28, scope: !1125, inlinedAt: !1127)
!1132 = !DILocation(line: 219, column: 10, scope: !1125, inlinedAt: !1127)
!1133 = !DILocation(line: 59, column: 9, scope: !1123)
!1134 = !DILocation(line: 59, column: 19, scope: !1123)
!1135 = !DILocation(line: 60, column: 39, scope: !1123)
!1136 = !DILocation(line: 60, column: 26, scope: !1123)
!1137 = !DILocation(line: 60, column: 9, scope: !1123)
!1138 = !DILocation(line: 60, column: 24, scope: !1123)
!1139 = !DILocation(line: 61, column: 5, scope: !1123)
!1140 = !DILocation(line: 63, column: 9, scope: !1141)
!1141 = distinct !DILexicalBlock(scope: !1108, file: !7, line: 63, column: 9)
!1142 = !DILocation(line: 63, column: 13, scope: !1141)
!1143 = !DILocation(line: 64, column: 31, scope: !1144)
!1144 = distinct !DILexicalBlock(scope: !1141, file: !7, line: 63, column: 19)
!1145 = !DILocalVariable(name: "__a", arg: 1, scope: !1146, file: !999, line: 312, type: !109)
!1146 = distinct !DISubprogram(name: "__fmul_rz", linkageName: "_ZL9__fmul_rzff", scope: !999, file: !999, line: 312, type: !120, scopeLine: 312, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !6, retainedNodes: !870)
!1147 = !DILocation(line: 312, column: 34, scope: !1146, inlinedAt: !1148)
!1148 = distinct !DILocation(line: 64, column: 21, scope: !1144)
!1149 = !DILocalVariable(name: "__b", arg: 2, scope: !1146, file: !999, line: 312, type: !109)
!1150 = !DILocation(line: 312, column: 45, scope: !1146, inlinedAt: !1148)
!1151 = !DILocation(line: 313, column: 23, scope: !1146, inlinedAt: !1148)
!1152 = !DILocation(line: 313, column: 28, scope: !1146, inlinedAt: !1148)
!1153 = !DILocation(line: 313, column: 10, scope: !1146, inlinedAt: !1148)
!1154 = !DILocation(line: 64, column: 9, scope: !1144)
!1155 = !DILocation(line: 64, column: 19, scope: !1144)
!1156 = !DILocation(line: 65, column: 39, scope: !1144)
!1157 = !DILocation(line: 65, column: 26, scope: !1144)
!1158 = !DILocation(line: 65, column: 9, scope: !1144)
!1159 = !DILocation(line: 65, column: 24, scope: !1144)
!1160 = !DILocation(line: 66, column: 5, scope: !1144)
!1161 = !DILocation(line: 68, column: 9, scope: !1162)
!1162 = distinct !DILexicalBlock(scope: !1108, file: !7, line: 68, column: 9)
!1163 = !DILocation(line: 68, column: 13, scope: !1162)
!1164 = !DILocation(line: 70, column: 31, scope: !1165)
!1165 = distinct !DILexicalBlock(scope: !1162, file: !7, line: 68, column: 19)
!1166 = !DILocation(line: 312, column: 34, scope: !1146, inlinedAt: !1167)
!1167 = distinct !DILocation(line: 70, column: 21, scope: !1165)
!1168 = !DILocation(line: 312, column: 45, scope: !1146, inlinedAt: !1167)
!1169 = !DILocation(line: 313, column: 23, scope: !1146, inlinedAt: !1167)
!1170 = !DILocation(line: 313, column: 28, scope: !1146, inlinedAt: !1167)
!1171 = !DILocation(line: 313, column: 10, scope: !1146, inlinedAt: !1167)
!1172 = !DILocation(line: 70, column: 9, scope: !1165)
!1173 = !DILocation(line: 70, column: 19, scope: !1165)
!1174 = !DILocation(line: 71, column: 39, scope: !1165)
!1175 = !DILocation(line: 71, column: 26, scope: !1165)
!1176 = !DILocation(line: 71, column: 9, scope: !1165)
!1177 = !DILocation(line: 71, column: 24, scope: !1165)
!1178 = !DILocation(line: 72, column: 5, scope: !1165)
!1179 = !DILocation(line: 73, column: 1, scope: !1108)
!1180 = distinct !DISubprogram(name: "testUnderflow_RoundUp", linkageName: "_Z21testUnderflow_RoundUpPfPi", scope: !7, file: !7, line: 75, type: !979, scopeLine: 75, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !6, retainedNodes: !870)
!1181 = !DILocalVariable(name: "result", arg: 1, scope: !1180, file: !7, line: 75, type: !240)
!1182 = !DILocation(line: 75, column: 46, scope: !1180)
!1183 = !DILocalVariable(name: "is_denormal", arg: 2, scope: !1180, file: !7, line: 75, type: !168)
!1184 = !DILocation(line: 75, column: 59, scope: !1180)
!1185 = !DILocalVariable(name: "idx", scope: !1180, file: !7, line: 76, type: !104)
!1186 = !DILocation(line: 76, column: 9, scope: !1180)
!1187 = !DILocation(line: 53, column: 27, scope: !988, inlinedAt: !1188)
!1188 = distinct !DILocation(line: 76, column: 15, scope: !1180)
!1189 = !DILocalVariable(name: "tiny", scope: !1180, file: !7, line: 78, type: !109)
!1190 = !DILocation(line: 78, column: 11, scope: !1180)
!1191 = !DILocation(line: 82, column: 9, scope: !1192)
!1192 = distinct !DILexicalBlock(scope: !1180, file: !7, line: 82, column: 9)
!1193 = !DILocation(line: 82, column: 13, scope: !1192)
!1194 = !DILocation(line: 84, column: 31, scope: !1195)
!1195 = distinct !DILexicalBlock(scope: !1192, file: !7, line: 82, column: 19)
!1196 = !DILocalVariable(name: "__a", arg: 1, scope: !1197, file: !999, line: 215, type: !109)
!1197 = distinct !DISubprogram(name: "__fdiv_ru", linkageName: "_ZL9__fdiv_ruff", scope: !999, file: !999, line: 215, type: !120, scopeLine: 215, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !6, retainedNodes: !870)
!1198 = !DILocation(line: 215, column: 34, scope: !1197, inlinedAt: !1199)
!1199 = distinct !DILocation(line: 84, column: 21, scope: !1195)
!1200 = !DILocalVariable(name: "__b", arg: 2, scope: !1197, file: !999, line: 215, type: !109)
!1201 = !DILocation(line: 215, column: 45, scope: !1197, inlinedAt: !1199)
!1202 = !DILocation(line: 216, column: 23, scope: !1197, inlinedAt: !1199)
!1203 = !DILocation(line: 216, column: 28, scope: !1197, inlinedAt: !1199)
!1204 = !DILocation(line: 216, column: 10, scope: !1197, inlinedAt: !1199)
!1205 = !DILocation(line: 84, column: 9, scope: !1195)
!1206 = !DILocation(line: 84, column: 19, scope: !1195)
!1207 = !DILocation(line: 85, column: 39, scope: !1195)
!1208 = !DILocation(line: 85, column: 26, scope: !1195)
!1209 = !DILocation(line: 85, column: 9, scope: !1195)
!1210 = !DILocation(line: 85, column: 24, scope: !1195)
!1211 = !DILocation(line: 86, column: 5, scope: !1195)
!1212 = !DILocation(line: 88, column: 9, scope: !1213)
!1213 = distinct !DILexicalBlock(scope: !1180, file: !7, line: 88, column: 9)
!1214 = !DILocation(line: 88, column: 13, scope: !1213)
!1215 = !DILocation(line: 89, column: 31, scope: !1216)
!1216 = distinct !DILexicalBlock(scope: !1213, file: !7, line: 88, column: 19)
!1217 = !DILocalVariable(name: "__a", arg: 1, scope: !1218, file: !999, line: 309, type: !109)
!1218 = distinct !DISubprogram(name: "__fmul_ru", linkageName: "_ZL9__fmul_ruff", scope: !999, file: !999, line: 309, type: !120, scopeLine: 309, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !6, retainedNodes: !870)
!1219 = !DILocation(line: 309, column: 34, scope: !1218, inlinedAt: !1220)
!1220 = distinct !DILocation(line: 89, column: 21, scope: !1216)
!1221 = !DILocalVariable(name: "__b", arg: 2, scope: !1218, file: !999, line: 309, type: !109)
!1222 = !DILocation(line: 309, column: 45, scope: !1218, inlinedAt: !1220)
!1223 = !DILocation(line: 310, column: 23, scope: !1218, inlinedAt: !1220)
!1224 = !DILocation(line: 310, column: 28, scope: !1218, inlinedAt: !1220)
!1225 = !DILocation(line: 310, column: 10, scope: !1218, inlinedAt: !1220)
!1226 = !DILocation(line: 89, column: 9, scope: !1216)
!1227 = !DILocation(line: 89, column: 19, scope: !1216)
!1228 = !DILocation(line: 90, column: 39, scope: !1216)
!1229 = !DILocation(line: 90, column: 26, scope: !1216)
!1230 = !DILocation(line: 90, column: 9, scope: !1216)
!1231 = !DILocation(line: 90, column: 24, scope: !1216)
!1232 = !DILocation(line: 91, column: 5, scope: !1216)
!1233 = !DILocation(line: 93, column: 9, scope: !1234)
!1234 = distinct !DILexicalBlock(scope: !1180, file: !7, line: 93, column: 9)
!1235 = !DILocation(line: 93, column: 13, scope: !1234)
!1236 = !DILocation(line: 95, column: 32, scope: !1237)
!1237 = distinct !DILexicalBlock(scope: !1234, file: !7, line: 93, column: 19)
!1238 = !DILocation(line: 95, column: 31, scope: !1237)
!1239 = !DILocation(line: 309, column: 34, scope: !1218, inlinedAt: !1240)
!1240 = distinct !DILocation(line: 95, column: 21, scope: !1237)
!1241 = !DILocation(line: 309, column: 45, scope: !1218, inlinedAt: !1240)
!1242 = !DILocation(line: 310, column: 23, scope: !1218, inlinedAt: !1240)
!1243 = !DILocation(line: 310, column: 28, scope: !1218, inlinedAt: !1240)
!1244 = !DILocation(line: 310, column: 10, scope: !1218, inlinedAt: !1240)
!1245 = !DILocation(line: 95, column: 9, scope: !1237)
!1246 = !DILocation(line: 95, column: 19, scope: !1237)
!1247 = !DILocation(line: 96, column: 39, scope: !1237)
!1248 = !DILocation(line: 96, column: 26, scope: !1237)
!1249 = !DILocation(line: 96, column: 9, scope: !1237)
!1250 = !DILocation(line: 96, column: 24, scope: !1237)
!1251 = !DILocation(line: 97, column: 5, scope: !1237)
!1252 = !DILocation(line: 98, column: 1, scope: !1180)
!1253 = distinct !DISubprogram(name: "testUnderflow_RoundDown", linkageName: "_Z23testUnderflow_RoundDownPfPi", scope: !7, file: !7, line: 100, type: !979, scopeLine: 100, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !6, retainedNodes: !870)
!1254 = !DILocalVariable(name: "result", arg: 1, scope: !1253, file: !7, line: 100, type: !240)
!1255 = !DILocation(line: 100, column: 48, scope: !1253)
!1256 = !DILocalVariable(name: "is_denormal", arg: 2, scope: !1253, file: !7, line: 100, type: !168)
!1257 = !DILocation(line: 100, column: 61, scope: !1253)
!1258 = !DILocalVariable(name: "idx", scope: !1253, file: !7, line: 101, type: !104)
!1259 = !DILocation(line: 101, column: 9, scope: !1253)
!1260 = !DILocation(line: 53, column: 27, scope: !988, inlinedAt: !1261)
!1261 = distinct !DILocation(line: 101, column: 15, scope: !1253)
!1262 = !DILocalVariable(name: "tiny", scope: !1253, file: !7, line: 103, type: !109)
!1263 = !DILocation(line: 103, column: 11, scope: !1253)
!1264 = !DILocation(line: 107, column: 9, scope: !1265)
!1265 = distinct !DILexicalBlock(scope: !1253, file: !7, line: 107, column: 9)
!1266 = !DILocation(line: 107, column: 13, scope: !1265)
!1267 = !DILocation(line: 109, column: 31, scope: !1268)
!1268 = distinct !DILexicalBlock(scope: !1265, file: !7, line: 107, column: 19)
!1269 = !DILocalVariable(name: "__a", arg: 1, scope: !1270, file: !999, line: 209, type: !109)
!1270 = distinct !DISubprogram(name: "__fdiv_rd", linkageName: "_ZL9__fdiv_rdff", scope: !999, file: !999, line: 209, type: !120, scopeLine: 209, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !6, retainedNodes: !870)
!1271 = !DILocation(line: 209, column: 34, scope: !1270, inlinedAt: !1272)
!1272 = distinct !DILocation(line: 109, column: 21, scope: !1268)
!1273 = !DILocalVariable(name: "__b", arg: 2, scope: !1270, file: !999, line: 209, type: !109)
!1274 = !DILocation(line: 209, column: 45, scope: !1270, inlinedAt: !1272)
!1275 = !DILocation(line: 210, column: 23, scope: !1270, inlinedAt: !1272)
!1276 = !DILocation(line: 210, column: 28, scope: !1270, inlinedAt: !1272)
!1277 = !DILocation(line: 210, column: 10, scope: !1270, inlinedAt: !1272)
!1278 = !DILocation(line: 109, column: 9, scope: !1268)
!1279 = !DILocation(line: 109, column: 19, scope: !1268)
!1280 = !DILocation(line: 110, column: 39, scope: !1268)
!1281 = !DILocation(line: 110, column: 26, scope: !1268)
!1282 = !DILocation(line: 110, column: 9, scope: !1268)
!1283 = !DILocation(line: 110, column: 24, scope: !1268)
!1284 = !DILocation(line: 111, column: 5, scope: !1268)
!1285 = !DILocation(line: 113, column: 9, scope: !1286)
!1286 = distinct !DILexicalBlock(scope: !1253, file: !7, line: 113, column: 9)
!1287 = !DILocation(line: 113, column: 13, scope: !1286)
!1288 = !DILocation(line: 115, column: 32, scope: !1289)
!1289 = distinct !DILexicalBlock(scope: !1286, file: !7, line: 113, column: 19)
!1290 = !DILocation(line: 115, column: 31, scope: !1289)
!1291 = !DILocalVariable(name: "__a", arg: 1, scope: !1292, file: !999, line: 303, type: !109)
!1292 = distinct !DISubprogram(name: "__fmul_rd", linkageName: "_ZL9__fmul_rdff", scope: !999, file: !999, line: 303, type: !120, scopeLine: 303, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !6, retainedNodes: !870)
!1293 = !DILocation(line: 303, column: 34, scope: !1292, inlinedAt: !1294)
!1294 = distinct !DILocation(line: 115, column: 21, scope: !1289)
!1295 = !DILocalVariable(name: "__b", arg: 2, scope: !1292, file: !999, line: 303, type: !109)
!1296 = !DILocation(line: 303, column: 45, scope: !1292, inlinedAt: !1294)
!1297 = !DILocation(line: 304, column: 23, scope: !1292, inlinedAt: !1294)
!1298 = !DILocation(line: 304, column: 28, scope: !1292, inlinedAt: !1294)
!1299 = !DILocation(line: 304, column: 10, scope: !1292, inlinedAt: !1294)
!1300 = !DILocation(line: 115, column: 9, scope: !1289)
!1301 = !DILocation(line: 115, column: 19, scope: !1289)
!1302 = !DILocation(line: 116, column: 39, scope: !1289)
!1303 = !DILocation(line: 116, column: 26, scope: !1289)
!1304 = !DILocation(line: 116, column: 9, scope: !1289)
!1305 = !DILocation(line: 116, column: 24, scope: !1289)
!1306 = !DILocation(line: 117, column: 5, scope: !1289)
!1307 = !DILocation(line: 119, column: 9, scope: !1308)
!1308 = distinct !DILexicalBlock(scope: !1253, file: !7, line: 119, column: 9)
!1309 = !DILocation(line: 119, column: 13, scope: !1308)
!1310 = !DILocation(line: 120, column: 32, scope: !1311)
!1311 = distinct !DILexicalBlock(scope: !1308, file: !7, line: 119, column: 19)
!1312 = !DILocation(line: 120, column: 31, scope: !1311)
!1313 = !DILocation(line: 303, column: 34, scope: !1292, inlinedAt: !1314)
!1314 = distinct !DILocation(line: 120, column: 21, scope: !1311)
!1315 = !DILocation(line: 303, column: 45, scope: !1292, inlinedAt: !1314)
!1316 = !DILocation(line: 304, column: 23, scope: !1292, inlinedAt: !1314)
!1317 = !DILocation(line: 304, column: 28, scope: !1292, inlinedAt: !1314)
!1318 = !DILocation(line: 304, column: 10, scope: !1292, inlinedAt: !1314)
!1319 = !DILocation(line: 120, column: 9, scope: !1311)
!1320 = !DILocation(line: 120, column: 19, scope: !1311)
!1321 = !DILocation(line: 121, column: 39, scope: !1311)
!1322 = !DILocation(line: 121, column: 26, scope: !1311)
!1323 = !DILocation(line: 121, column: 9, scope: !1311)
!1324 = !DILocation(line: 121, column: 24, scope: !1311)
!1325 = !DILocation(line: 122, column: 5, scope: !1311)
!1326 = !DILocation(line: 123, column: 1, scope: !1253)
