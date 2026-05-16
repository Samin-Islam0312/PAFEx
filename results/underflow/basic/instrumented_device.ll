; ModuleID = '/home/users/sislam3/SBAC-PAD/results/underflow/basic/instrumented_device.bc'
source_filename = "llvm-link"
target datalayout = "e-p6:32:32-i64:64-i128:128-i256:256-v16:16-v32:32-n16:32:64"
target triple = "nvptx64-nvidia-cuda"

%struct.float2 = type { float, float }

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

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.fabs.f32(float) #1

; Function Attrs: convergent noinline norecurse nounwind optnone
define dso_local ptx_kernel void @_Z24testUnderflow_OperationsPfPi(ptr noundef %result, ptr noundef %is_denorm) #2 !dbg !978 {
entry:
  %__a.addr.i68 = alloca float, align 4
  %__a.addr.i66 = alloca float, align 4
  %__b.addr.i = alloca float, align 4
  %__a.addr.i64 = alloca float, align 4
  %__a.addr.i = alloca float, align 4
  %result.addr = alloca ptr, align 8
  %is_denorm.addr = alloca ptr, align 8
  %idx = alloca i32, align 4
  %tiny = alloca float, align 4
  %a = alloca float, align 4
  %b = alloca float, align 4
  %denorm = alloca float, align 4
  store ptr %result, ptr %result.addr, align 8
    #dbg_declare(ptr %result.addr, !981, !DIExpression(), !982)
  store ptr %is_denorm, ptr %is_denorm.addr, align 8
    #dbg_declare(ptr %is_denorm.addr, !983, !DIExpression(), !984)
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
  %3 = bitcast float %2 to i32, !dbg !997
  %4 = bitcast float %2 to i32, !dbg !997
  %5 = and i32 %4, 2139095040, !dbg !997
  %6 = icmp eq i32 %5, 2139095040, !dbg !997
  %7 = and i32 %4, 8388607, !dbg !997
  %8 = icmp ne i32 %7, 0, !dbg !997
  %is_nan = and i1 %6, %8, !dbg !997
  %9 = and i32 %3, 4194304, !dbg !997
  %10 = icmp eq i32 %9, 0, !dbg !997
  %is_snan = and i1 %is_nan, %10, !dbg !997
  %11 = or i1 %is_snan, false, !dbg !997
  %12 = bitcast float %2 to i32, !dbg !997
  %13 = and i32 %12, 2147483647, !dbg !997
  %is_zero = icmp eq i32 %13, 0, !dbg !997
  %14 = and i1 %is_zero, false, !dbg !997
  %15 = bitcast float %2 to i32, !dbg !997
  %16 = and i32 %15, 2139095040, !dbg !997
  %17 = icmp eq i32 %16, 2139095040, !dbg !997
  %18 = and i32 %15, 8388607, !dbg !997
  %19 = icmp eq i32 %18, 0, !dbg !997
  %is_inf = and i1 %17, %19, !dbg !997
  %20 = and i1 %is_inf, false, !dbg !997
  %21 = or i1 %14, %20, !dbg !997
  %22 = or i1 %11, %21, !dbg !997
  br i1 %22, label %23, label %25, !dbg !997

23:                                               ; preds = %if.then
  %24 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !997
  br label %25, !dbg !997

25:                                               ; preds = %if.then, %23
  %26 = bitcast float %2 to i32, !dbg !997
  %27 = and i32 %26, 2139095040, !dbg !997
  %is_finite = icmp ne i32 %27, 2139095040, !dbg !997
  %28 = bitcast float %2 to i32, !dbg !997
  %29 = and i32 %28, 2147483647, !dbg !997
  %is_zero1 = icmp eq i32 %29, 0, !dbg !997
  %30 = xor i1 %is_zero1, true, !dbg !997
  %31 = and i1 %is_finite, %30, !dbg !997
  %divzero_cond = and i1 false, %31, !dbg !997
  br i1 %divzero_cond, label %32, label %34, !dbg !997

32:                                               ; preds = %25
  %33 = atomicrmw add ptr addrspace(1) @fp_divbyzero_counter, i64 1 monotonic, align 8, !dbg !997
  br label %34, !dbg !997

34:                                               ; preds = %25, %32
  %div = fdiv contract float %2, 1.000000e+02, !dbg !997
  %35 = bitcast float %2 to i32, !dbg !998
  %36 = and i32 %35, 2139095040, !dbg !998
  %is_finite2 = icmp ne i32 %36, 2139095040, !dbg !998
  %37 = and i1 true, %is_finite2, !dbg !998
  %38 = and i1 %37, true, !dbg !998
  %overflow_denom_nonzero = and i1 %38, true, !dbg !998
  %39 = bitcast float %div to i32, !dbg !998
  %40 = and i32 %39, 2139095040, !dbg !998
  %41 = icmp eq i32 %40, 2139095040, !dbg !998
  %42 = and i32 %39, 8388607, !dbg !998
  %43 = icmp eq i32 %42, 0, !dbg !998
  %is_inf3 = and i1 %41, %43, !dbg !998
  %44 = bitcast float %div to i32, !dbg !998
  %45 = and i32 %44, 2147483647, !dbg !998
  %is_maxfinite = icmp eq i32 %45, 2139095039, !dbg !998
  %46 = bitcast float %div to i32, !dbg !998
  %47 = and i32 %46, -2147483648, !dbg !998
  %48 = icmp eq i32 %47, 0, !dbg !998
  %49 = icmp ne i32 %47, 0, !dbg !998
  %is_pos_inf = and i1 %is_inf3, %48, !dbg !998
  %is_neg_inf = and i1 %is_inf3, %49, !dbg !998
  %is_pos_max = and i1 %is_maxfinite, %48, !dbg !998
  %is_neg_max = and i1 %is_maxfinite, %49, !dbg !998
  %overflow_cond = and i1 %overflow_denom_nonzero, %is_inf3, !dbg !998
  br i1 %overflow_cond, label %50, label %52, !dbg !998

50:                                               ; preds = %34
  %51 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !998
  br label %52, !dbg !998

52:                                               ; preds = %34, %50
  %53 = bitcast float %2 to i32, !dbg !998
  %54 = and i32 %53, 2139095040, !dbg !998
  %55 = icmp eq i32 %54, 0, !dbg !998
  %56 = and i32 %53, 8388607, !dbg !998
  %57 = icmp ne i32 %56, 0, !dbg !998
  %is_subnormal = and i1 %55, %57, !dbg !998
  %58 = xor i1 %is_subnormal, true, !dbg !998
  %59 = and i1 true, %58, !dbg !998
  %60 = and i1 %59, true, !dbg !998
  %61 = bitcast float %div to i32, !dbg !998
  %62 = and i32 %61, 2139095040, !dbg !998
  %63 = icmp eq i32 %62, 0, !dbg !998
  %64 = and i32 %61, 8388607, !dbg !998
  %65 = icmp ne i32 %64, 0, !dbg !998
  %is_subnormal4 = and i1 %63, %65, !dbg !998
  %66 = bitcast float %div to i32, !dbg !998
  %67 = and i32 %66, 2147483647, !dbg !998
  %is_zero5 = icmp eq i32 %67, 0, !dbg !998
  %68 = bitcast float %2 to i32, !dbg !998
  %69 = and i32 %68, 2147483647, !dbg !998
  %is_zero6 = icmp eq i32 %69, 0, !dbg !998
  %70 = xor i1 %is_zero6, true, !dbg !998
  %71 = and i1 %70, true, !dbg !998
  %72 = and i1 %is_zero5, %71, !dbg !998
  %is_tiny = or i1 %is_subnormal4, %72, !dbg !998
  %underflow_cond = and i1 %60, %is_tiny, !dbg !998
  br i1 %underflow_cond, label %73, label %75, !dbg !998

73:                                               ; preds = %52
  %74 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !998
  br label %75, !dbg !998

75:                                               ; preds = %52, %73
  %76 = load ptr, ptr %result.addr, align 8, !dbg !998
  %arrayidx = getelementptr inbounds float, ptr %76, i64 0, !dbg !998
  store float %div, ptr %arrayidx, align 4, !dbg !999
  %77 = load ptr, ptr %result.addr, align 8, !dbg !1000
  %arrayidx1 = getelementptr inbounds float, ptr %77, i64 0, !dbg !1000
  %78 = load float, ptr %arrayidx1, align 4, !dbg !1000
  %call2 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %78) #4, !dbg !1001
  %79 = zext i1 %call2 to i64, !dbg !1001
  %cond = select i1 %call2, i32 1, i32 0, !dbg !1001
  %80 = load ptr, ptr %is_denorm.addr, align 8, !dbg !1002
  %arrayidx3 = getelementptr inbounds i32, ptr %80, i64 0, !dbg !1002
  store i32 %cond, ptr %arrayidx3, align 4, !dbg !1003
  br label %if.end, !dbg !1004

if.end:                                           ; preds = %75, %entry
  %81 = load i32, ptr %idx, align 4, !dbg !1005
  %cmp4 = icmp eq i32 %81, 1, !dbg !1007
  br i1 %cmp4, label %if.then5, label %if.end11, !dbg !1007

if.then5:                                         ; preds = %if.end
  %82 = load float, ptr %tiny, align 4, !dbg !1008
  %83 = bitcast float %82 to i32, !dbg !1010
  %84 = bitcast float %82 to i32, !dbg !1010
  %85 = and i32 %84, 2139095040, !dbg !1010
  %86 = icmp eq i32 %85, 2139095040, !dbg !1010
  %87 = and i32 %84, 8388607, !dbg !1010
  %88 = icmp ne i32 %87, 0, !dbg !1010
  %is_nan7 = and i1 %86, %88, !dbg !1010
  %89 = and i32 %83, 4194304, !dbg !1010
  %90 = icmp eq i32 %89, 0, !dbg !1010
  %is_snan8 = and i1 %is_nan7, %90, !dbg !1010
  %91 = or i1 %is_snan8, false, !dbg !1010
  %92 = bitcast float %82 to i32, !dbg !1010
  %93 = and i32 %92, 2147483647, !dbg !1010
  %is_zero9 = icmp eq i32 %93, 0, !dbg !1010
  %94 = and i1 %is_zero9, false, !dbg !1010
  %95 = bitcast float %82 to i32, !dbg !1010
  %96 = and i32 %95, 2139095040, !dbg !1010
  %97 = icmp eq i32 %96, 2139095040, !dbg !1010
  %98 = and i32 %95, 8388607, !dbg !1010
  %99 = icmp eq i32 %98, 0, !dbg !1010
  %is_inf10 = and i1 %97, %99, !dbg !1010
  %100 = and i1 %is_inf10, false, !dbg !1010
  %101 = or i1 %94, %100, !dbg !1010
  %102 = or i1 %91, %101, !dbg !1010
  br i1 %102, label %103, label %105, !dbg !1010

103:                                              ; preds = %if.then5
  %104 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1010
  br label %105, !dbg !1010

105:                                              ; preds = %if.then5, %103
  %mul = fmul contract float %82, 0x3F847AE140000000, !dbg !1010
  %106 = bitcast float %82 to i32, !dbg !1011
  %107 = and i32 %106, 2139095040, !dbg !1011
  %is_finite11 = icmp ne i32 %107, 2139095040, !dbg !1011
  %108 = and i1 true, %is_finite11, !dbg !1011
  %109 = and i1 %108, true, !dbg !1011
  %110 = bitcast float %mul to i32, !dbg !1011
  %111 = and i32 %110, 2139095040, !dbg !1011
  %112 = icmp eq i32 %111, 2139095040, !dbg !1011
  %113 = and i32 %110, 8388607, !dbg !1011
  %114 = icmp eq i32 %113, 0, !dbg !1011
  %is_inf12 = and i1 %112, %114, !dbg !1011
  %115 = bitcast float %mul to i32, !dbg !1011
  %116 = and i32 %115, 2147483647, !dbg !1011
  %is_maxfinite13 = icmp eq i32 %116, 2139095039, !dbg !1011
  %117 = bitcast float %mul to i32, !dbg !1011
  %118 = and i32 %117, -2147483648, !dbg !1011
  %119 = icmp eq i32 %118, 0, !dbg !1011
  %120 = icmp ne i32 %118, 0, !dbg !1011
  %is_pos_inf14 = and i1 %is_inf12, %119, !dbg !1011
  %is_neg_inf15 = and i1 %is_inf12, %120, !dbg !1011
  %is_pos_max16 = and i1 %is_maxfinite13, %119, !dbg !1011
  %is_neg_max17 = and i1 %is_maxfinite13, %120, !dbg !1011
  %overflow_cond18 = and i1 %109, %is_inf12, !dbg !1011
  br i1 %overflow_cond18, label %121, label %123, !dbg !1011

121:                                              ; preds = %105
  %122 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1011
  br label %123, !dbg !1011

123:                                              ; preds = %105, %121
  %124 = bitcast float %82 to i32, !dbg !1011
  %125 = and i32 %124, 2139095040, !dbg !1011
  %126 = icmp eq i32 %125, 0, !dbg !1011
  %127 = and i32 %124, 8388607, !dbg !1011
  %128 = icmp ne i32 %127, 0, !dbg !1011
  %is_subnormal19 = and i1 %126, %128, !dbg !1011
  %129 = xor i1 %is_subnormal19, true, !dbg !1011
  %130 = and i1 true, %129, !dbg !1011
  %131 = and i1 %130, true, !dbg !1011
  %132 = bitcast float %mul to i32, !dbg !1011
  %133 = and i32 %132, 2139095040, !dbg !1011
  %134 = icmp eq i32 %133, 0, !dbg !1011
  %135 = and i32 %132, 8388607, !dbg !1011
  %136 = icmp ne i32 %135, 0, !dbg !1011
  %is_subnormal20 = and i1 %134, %136, !dbg !1011
  %137 = bitcast float %mul to i32, !dbg !1011
  %138 = and i32 %137, 2147483647, !dbg !1011
  %is_zero21 = icmp eq i32 %138, 0, !dbg !1011
  %139 = bitcast float %82 to i32, !dbg !1011
  %140 = and i32 %139, 2147483647, !dbg !1011
  %is_zero22 = icmp eq i32 %140, 0, !dbg !1011
  %141 = xor i1 %is_zero22, true, !dbg !1011
  %142 = and i1 %141, true, !dbg !1011
  %143 = and i1 %is_zero21, %142, !dbg !1011
  %is_tiny23 = or i1 %is_subnormal20, %143, !dbg !1011
  %underflow_cond24 = and i1 %131, %is_tiny23, !dbg !1011
  br i1 %underflow_cond24, label %144, label %146, !dbg !1011

144:                                              ; preds = %123
  %145 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1011
  br label %146, !dbg !1011

146:                                              ; preds = %123, %144
  %147 = load ptr, ptr %result.addr, align 8, !dbg !1011
  %arrayidx6 = getelementptr inbounds float, ptr %147, i64 1, !dbg !1011
  store float %mul, ptr %arrayidx6, align 4, !dbg !1012
  %148 = load ptr, ptr %result.addr, align 8, !dbg !1013
  %arrayidx7 = getelementptr inbounds float, ptr %148, i64 1, !dbg !1013
  %149 = load float, ptr %arrayidx7, align 4, !dbg !1013
  %call8 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %149) #4, !dbg !1014
  %150 = zext i1 %call8 to i64, !dbg !1014
  %cond9 = select i1 %call8, i32 1, i32 0, !dbg !1014
  %151 = load ptr, ptr %is_denorm.addr, align 8, !dbg !1015
  %arrayidx10 = getelementptr inbounds i32, ptr %151, i64 1, !dbg !1015
  store i32 %cond9, ptr %arrayidx10, align 4, !dbg !1016
  br label %if.end11, !dbg !1017

if.end11:                                         ; preds = %146, %if.end
  %152 = load i32, ptr %idx, align 4, !dbg !1018
  %cmp12 = icmp eq i32 %152, 2, !dbg !1020
  br i1 %cmp12, label %if.then13, label %if.end19, !dbg !1020

if.then13:                                        ; preds = %if.end11
    #dbg_declare(ptr %a, !1021, !DIExpression(), !1023)
  store float 0x38119999A0000000, ptr %a, align 4, !dbg !1023
    #dbg_declare(ptr %b, !1024, !DIExpression(), !1025)
  store float 0x3810000000000000, ptr %b, align 4, !dbg !1025
  %153 = load float, ptr %a, align 4, !dbg !1026
  %154 = load float, ptr %b, align 4, !dbg !1027
  %155 = bitcast float %153 to i32, !dbg !1028
  %156 = bitcast float %153 to i32, !dbg !1028
  %157 = and i32 %156, 2139095040, !dbg !1028
  %158 = icmp eq i32 %157, 2139095040, !dbg !1028
  %159 = and i32 %156, 8388607, !dbg !1028
  %160 = icmp ne i32 %159, 0, !dbg !1028
  %is_nan25 = and i1 %158, %160, !dbg !1028
  %161 = and i32 %155, 4194304, !dbg !1028
  %162 = icmp eq i32 %161, 0, !dbg !1028
  %is_snan26 = and i1 %is_nan25, %162, !dbg !1028
  %163 = bitcast float %154 to i32, !dbg !1028
  %164 = bitcast float %154 to i32, !dbg !1028
  %165 = and i32 %164, 2139095040, !dbg !1028
  %166 = icmp eq i32 %165, 2139095040, !dbg !1028
  %167 = and i32 %164, 8388607, !dbg !1028
  %168 = icmp ne i32 %167, 0, !dbg !1028
  %is_nan27 = and i1 %166, %168, !dbg !1028
  %169 = and i32 %163, 4194304, !dbg !1028
  %170 = icmp eq i32 %169, 0, !dbg !1028
  %is_snan28 = and i1 %is_nan27, %170, !dbg !1028
  %171 = or i1 %is_snan26, %is_snan28, !dbg !1028
  %172 = bitcast float %153 to i32, !dbg !1028
  %173 = and i32 %172, 2139095040, !dbg !1028
  %174 = icmp eq i32 %173, 2139095040, !dbg !1028
  %175 = and i32 %172, 8388607, !dbg !1028
  %176 = icmp eq i32 %175, 0, !dbg !1028
  %is_inf29 = and i1 %174, %176, !dbg !1028
  %177 = bitcast float %154 to i32, !dbg !1028
  %178 = and i32 %177, 2139095040, !dbg !1028
  %179 = icmp eq i32 %178, 2139095040, !dbg !1028
  %180 = and i32 %177, 8388607, !dbg !1028
  %181 = icmp eq i32 %180, 0, !dbg !1028
  %is_inf30 = and i1 %179, %181, !dbg !1028
  %182 = and i1 %is_inf29, %is_inf30, !dbg !1028
  %183 = bitcast float %153 to i32, !dbg !1028
  %184 = bitcast float %154 to i32, !dbg !1028
  %185 = and i32 %183, -2147483648, !dbg !1028
  %186 = and i32 %184, -2147483648, !dbg !1028
  %187 = icmp eq i32 %185, %186, !dbg !1028
  %188 = and i1 %182, %187, !dbg !1028
  %189 = or i1 %171, %188, !dbg !1028
  br i1 %189, label %190, label %192, !dbg !1028

190:                                              ; preds = %if.then13
  %191 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1028
  br label %192, !dbg !1028

192:                                              ; preds = %if.then13, %190
  %sub = fsub contract float %153, %154, !dbg !1028
  %193 = bitcast float %153 to i32, !dbg !1029
  %194 = and i32 %193, 2139095040, !dbg !1029
  %is_finite31 = icmp ne i32 %194, 2139095040, !dbg !1029
  %195 = and i1 true, %is_finite31, !dbg !1029
  %196 = bitcast float %154 to i32, !dbg !1029
  %197 = and i32 %196, 2139095040, !dbg !1029
  %is_finite32 = icmp ne i32 %197, 2139095040, !dbg !1029
  %198 = and i1 %195, %is_finite32, !dbg !1029
  %199 = bitcast float %sub to i32, !dbg !1029
  %200 = and i32 %199, 2139095040, !dbg !1029
  %201 = icmp eq i32 %200, 2139095040, !dbg !1029
  %202 = and i32 %199, 8388607, !dbg !1029
  %203 = icmp eq i32 %202, 0, !dbg !1029
  %is_inf33 = and i1 %201, %203, !dbg !1029
  %204 = bitcast float %sub to i32, !dbg !1029
  %205 = and i32 %204, 2147483647, !dbg !1029
  %is_maxfinite34 = icmp eq i32 %205, 2139095039, !dbg !1029
  %206 = bitcast float %sub to i32, !dbg !1029
  %207 = and i32 %206, -2147483648, !dbg !1029
  %208 = icmp eq i32 %207, 0, !dbg !1029
  %209 = icmp ne i32 %207, 0, !dbg !1029
  %is_pos_inf35 = and i1 %is_inf33, %208, !dbg !1029
  %is_neg_inf36 = and i1 %is_inf33, %209, !dbg !1029
  %is_pos_max37 = and i1 %is_maxfinite34, %208, !dbg !1029
  %is_neg_max38 = and i1 %is_maxfinite34, %209, !dbg !1029
  %overflow_cond39 = and i1 %198, %is_inf33, !dbg !1029
  br i1 %overflow_cond39, label %210, label %212, !dbg !1029

210:                                              ; preds = %192
  %211 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1029
  br label %212, !dbg !1029

212:                                              ; preds = %192, %210
  %213 = load ptr, ptr %result.addr, align 8, !dbg !1029
  %arrayidx14 = getelementptr inbounds float, ptr %213, i64 2, !dbg !1029
  store float %sub, ptr %arrayidx14, align 4, !dbg !1030
  %214 = load ptr, ptr %result.addr, align 8, !dbg !1031
  %arrayidx15 = getelementptr inbounds float, ptr %214, i64 2, !dbg !1031
  %215 = load float, ptr %arrayidx15, align 4, !dbg !1031
  %call16 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %215) #4, !dbg !1032
  %216 = zext i1 %call16 to i64, !dbg !1032
  %cond17 = select i1 %call16, i32 1, i32 0, !dbg !1032
  %217 = load ptr, ptr %is_denorm.addr, align 8, !dbg !1033
  %arrayidx18 = getelementptr inbounds i32, ptr %217, i64 2, !dbg !1033
  store i32 %cond17, ptr %arrayidx18, align 4, !dbg !1034
  br label %if.end19, !dbg !1035

if.end19:                                         ; preds = %212, %if.end11
  %218 = load i32, ptr %idx, align 4, !dbg !1036
  %cmp20 = icmp eq i32 %218, 3, !dbg !1038
  br i1 %cmp20, label %if.then21, label %if.end27, !dbg !1038

if.then21:                                        ; preds = %if.end19
    #dbg_declare(ptr %denorm, !1039, !DIExpression(), !1041)
  store float 0x37D9999A00000000, ptr %denorm, align 4, !dbg !1041
  %219 = load float, ptr %denorm, align 4, !dbg !1042
  %220 = load float, ptr %denorm, align 4, !dbg !1043
  %221 = bitcast float %219 to i32, !dbg !1044
  %222 = bitcast float %219 to i32, !dbg !1044
  %223 = and i32 %222, 2139095040, !dbg !1044
  %224 = icmp eq i32 %223, 2139095040, !dbg !1044
  %225 = and i32 %222, 8388607, !dbg !1044
  %226 = icmp ne i32 %225, 0, !dbg !1044
  %is_nan40 = and i1 %224, %226, !dbg !1044
  %227 = and i32 %221, 4194304, !dbg !1044
  %228 = icmp eq i32 %227, 0, !dbg !1044
  %is_snan41 = and i1 %is_nan40, %228, !dbg !1044
  %229 = bitcast float %220 to i32, !dbg !1044
  %230 = bitcast float %220 to i32, !dbg !1044
  %231 = and i32 %230, 2139095040, !dbg !1044
  %232 = icmp eq i32 %231, 2139095040, !dbg !1044
  %233 = and i32 %230, 8388607, !dbg !1044
  %234 = icmp ne i32 %233, 0, !dbg !1044
  %is_nan42 = and i1 %232, %234, !dbg !1044
  %235 = and i32 %229, 4194304, !dbg !1044
  %236 = icmp eq i32 %235, 0, !dbg !1044
  %is_snan43 = and i1 %is_nan42, %236, !dbg !1044
  %237 = or i1 %is_snan41, %is_snan43, !dbg !1044
  %238 = bitcast float %219 to i32, !dbg !1044
  %239 = and i32 %238, 2139095040, !dbg !1044
  %240 = icmp eq i32 %239, 2139095040, !dbg !1044
  %241 = and i32 %238, 8388607, !dbg !1044
  %242 = icmp eq i32 %241, 0, !dbg !1044
  %is_inf44 = and i1 %240, %242, !dbg !1044
  %243 = bitcast float %220 to i32, !dbg !1044
  %244 = and i32 %243, 2139095040, !dbg !1044
  %245 = icmp eq i32 %244, 2139095040, !dbg !1044
  %246 = and i32 %243, 8388607, !dbg !1044
  %247 = icmp eq i32 %246, 0, !dbg !1044
  %is_inf45 = and i1 %245, %247, !dbg !1044
  %248 = and i1 %is_inf44, %is_inf45, !dbg !1044
  %249 = bitcast float %219 to i32, !dbg !1044
  %250 = bitcast float %220 to i32, !dbg !1044
  %251 = and i32 %249, -2147483648, !dbg !1044
  %252 = and i32 %250, -2147483648, !dbg !1044
  %253 = icmp ne i32 %251, %252, !dbg !1044
  %254 = and i1 %248, %253, !dbg !1044
  %255 = or i1 %237, %254, !dbg !1044
  br i1 %255, label %256, label %258, !dbg !1044

256:                                              ; preds = %if.then21
  %257 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1044
  br label %258, !dbg !1044

258:                                              ; preds = %if.then21, %256
  %add = fadd contract float %219, %220, !dbg !1044
  %259 = bitcast float %219 to i32, !dbg !1045
  %260 = and i32 %259, 2139095040, !dbg !1045
  %is_finite46 = icmp ne i32 %260, 2139095040, !dbg !1045
  %261 = and i1 true, %is_finite46, !dbg !1045
  %262 = bitcast float %220 to i32, !dbg !1045
  %263 = and i32 %262, 2139095040, !dbg !1045
  %is_finite47 = icmp ne i32 %263, 2139095040, !dbg !1045
  %264 = and i1 %261, %is_finite47, !dbg !1045
  %265 = bitcast float %add to i32, !dbg !1045
  %266 = and i32 %265, 2139095040, !dbg !1045
  %267 = icmp eq i32 %266, 2139095040, !dbg !1045
  %268 = and i32 %265, 8388607, !dbg !1045
  %269 = icmp eq i32 %268, 0, !dbg !1045
  %is_inf48 = and i1 %267, %269, !dbg !1045
  %270 = bitcast float %add to i32, !dbg !1045
  %271 = and i32 %270, 2147483647, !dbg !1045
  %is_maxfinite49 = icmp eq i32 %271, 2139095039, !dbg !1045
  %272 = bitcast float %add to i32, !dbg !1045
  %273 = and i32 %272, -2147483648, !dbg !1045
  %274 = icmp eq i32 %273, 0, !dbg !1045
  %275 = icmp ne i32 %273, 0, !dbg !1045
  %is_pos_inf50 = and i1 %is_inf48, %274, !dbg !1045
  %is_neg_inf51 = and i1 %is_inf48, %275, !dbg !1045
  %is_pos_max52 = and i1 %is_maxfinite49, %274, !dbg !1045
  %is_neg_max53 = and i1 %is_maxfinite49, %275, !dbg !1045
  %overflow_cond54 = and i1 %264, %is_inf48, !dbg !1045
  br i1 %overflow_cond54, label %276, label %278, !dbg !1045

276:                                              ; preds = %258
  %277 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1045
  br label %278, !dbg !1045

278:                                              ; preds = %258, %276
  %279 = load ptr, ptr %result.addr, align 8, !dbg !1045
  %arrayidx22 = getelementptr inbounds float, ptr %279, i64 3, !dbg !1045
  store float %add, ptr %arrayidx22, align 4, !dbg !1046
  %280 = load ptr, ptr %result.addr, align 8, !dbg !1047
  %arrayidx23 = getelementptr inbounds float, ptr %280, i64 3, !dbg !1047
  %281 = load float, ptr %arrayidx23, align 4, !dbg !1047
  %call24 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %281) #4, !dbg !1048
  %282 = zext i1 %call24 to i64, !dbg !1048
  %cond25 = select i1 %call24, i32 1, i32 0, !dbg !1048
  %283 = load ptr, ptr %is_denorm.addr, align 8, !dbg !1049
  %arrayidx26 = getelementptr inbounds i32, ptr %283, i64 3, !dbg !1049
  store i32 %cond25, ptr %arrayidx26, align 4, !dbg !1050
  br label %if.end27, !dbg !1051

if.end27:                                         ; preds = %278, %if.end19
  %284 = load i32, ptr %idx, align 4, !dbg !1052
  %cmp28 = icmp eq i32 %284, 4, !dbg !1054
  br i1 %cmp28, label %if.then29, label %if.end36, !dbg !1054

if.then29:                                        ; preds = %if.end27
  %285 = load float, ptr %tiny, align 4, !dbg !1055
  store float %285, ptr %__a.addr.i, align 4
    #dbg_declare(ptr %__a.addr.i, !1057, !DIExpression(), !1058)
  %286 = load float, ptr %__a.addr.i, align 4, !dbg !1060
  %287 = bitcast float %286 to i32, !dbg !1061
  %288 = bitcast float %286 to i32, !dbg !1061
  %289 = and i32 %288, 2139095040, !dbg !1061
  %290 = icmp eq i32 %289, 2139095040, !dbg !1061
  %291 = and i32 %288, 8388607, !dbg !1061
  %292 = icmp ne i32 %291, 0, !dbg !1061
  %is_nan55 = and i1 %290, %292, !dbg !1061
  %293 = and i32 %287, 4194304, !dbg !1061
  %294 = icmp eq i32 %293, 0, !dbg !1061
  %is_snan56 = and i1 %is_nan55, %294, !dbg !1061
  %295 = bitcast float %286 to i32, !dbg !1061
  %296 = and i32 %295, -2147483648, !dbg !1061
  %is_neg = icmp ne i32 %296, 0, !dbg !1061
  %297 = or i1 %is_snan56, %is_neg, !dbg !1061
  br i1 %297, label %298, label %300, !dbg !1061

298:                                              ; preds = %if.then29
  %299 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1061
  br label %300, !dbg !1061

300:                                              ; preds = %if.then29, %298
  %301 = call float @llvm.nvvm.sqrt.approx.f(float %286) #5, !dbg !1061
  %302 = load ptr, ptr %result.addr, align 8, !dbg !1062
  %arrayidx31 = getelementptr inbounds float, ptr %302, i64 4, !dbg !1062
  store float %301, ptr %arrayidx31, align 4, !dbg !1063
  %303 = load ptr, ptr %result.addr, align 8, !dbg !1064
  %arrayidx32 = getelementptr inbounds float, ptr %303, i64 4, !dbg !1064
  %304 = load float, ptr %arrayidx32, align 4, !dbg !1064
  %call33 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %304) #4, !dbg !1065
  %305 = zext i1 %call33 to i64, !dbg !1065
  %cond34 = select i1 %call33, i32 1, i32 0, !dbg !1065
  %306 = load ptr, ptr %is_denorm.addr, align 8, !dbg !1066
  %arrayidx35 = getelementptr inbounds i32, ptr %306, i64 4, !dbg !1066
  store i32 %cond34, ptr %arrayidx35, align 4, !dbg !1067
  br label %if.end36, !dbg !1068

if.end36:                                         ; preds = %300, %if.end27
  %307 = load i32, ptr %idx, align 4, !dbg !1069
  %cmp37 = icmp eq i32 %307, 5, !dbg !1071
  br i1 %cmp37, label %if.then38, label %if.end45, !dbg !1071

if.then38:                                        ; preds = %if.end36
  store float -1.000000e+02, ptr %__a.addr.i64, align 4
    #dbg_declare(ptr %__a.addr.i64, !1072, !DIExpression(), !1073)
  %308 = load float, ptr %__a.addr.i64, align 4, !dbg !1076
  %309 = bitcast float %308 to i32, !dbg !1077
  %310 = bitcast float %308 to i32, !dbg !1077
  %311 = and i32 %310, 2139095040, !dbg !1077
  %312 = icmp eq i32 %311, 2139095040, !dbg !1077
  %313 = and i32 %310, 8388607, !dbg !1077
  %314 = icmp ne i32 %313, 0, !dbg !1077
  %is_nan57 = and i1 %312, %314, !dbg !1077
  %315 = and i32 %309, 4194304, !dbg !1077
  %316 = icmp eq i32 %315, 0, !dbg !1077
  %is_snan58 = and i1 %is_nan57, %316, !dbg !1077
  %317 = or i1 %is_snan58, false, !dbg !1077
  %318 = or i1 %317, false, !dbg !1077
  %319 = bitcast float %308 to i32, !dbg !1077
  %320 = and i32 %319, 2147483647, !dbg !1077
  %is_zero59 = icmp eq i32 %320, 0, !dbg !1077
  %321 = and i1 %is_zero59, false, !dbg !1077
  %322 = bitcast float %308 to i32, !dbg !1077
  %323 = and i32 %322, 2139095040, !dbg !1077
  %324 = icmp eq i32 %323, 2139095040, !dbg !1077
  %325 = and i32 %322, 8388607, !dbg !1077
  %326 = icmp eq i32 %325, 0, !dbg !1077
  %is_inf60 = and i1 %324, %326, !dbg !1077
  %327 = and i1 %is_inf60, false, !dbg !1077
  %328 = or i1 %321, %327, !dbg !1077
  %329 = or i1 %318, %328, !dbg !1077
  br i1 %329, label %330, label %332, !dbg !1077

330:                                              ; preds = %if.then38
  %331 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %332, !dbg !1077

332:                                              ; preds = %if.then38, %330
  %333 = call float @llvm.nvvm.fma.rn.f(float %308, float 0x3F777313A0000000, float 5.000000e-01) #5, !dbg !1077
  %334 = bitcast float %308 to i32, !dbg !1077
  %335 = and i32 %334, 2139095040, !dbg !1077
  %is_finite61 = icmp ne i32 %335, 2139095040, !dbg !1077
  %336 = and i1 true, %is_finite61, !dbg !1077
  %337 = and i1 %336, true, !dbg !1077
  %338 = bitcast float %333 to i32, !dbg !1077
  %339 = and i32 %338, 2139095040, !dbg !1077
  %340 = icmp eq i32 %339, 2139095040, !dbg !1077
  %341 = and i32 %338, 8388607, !dbg !1077
  %342 = icmp eq i32 %341, 0, !dbg !1077
  %is_inf62 = and i1 %340, %342, !dbg !1077
  %343 = bitcast float %333 to i32, !dbg !1077
  %344 = and i32 %343, 2147483647, !dbg !1077
  %is_maxfinite63 = icmp eq i32 %344, 2139095039, !dbg !1077
  %345 = bitcast float %333 to i32, !dbg !1077
  %346 = and i32 %345, -2147483648, !dbg !1077
  %347 = icmp eq i32 %346, 0, !dbg !1077
  %348 = icmp ne i32 %346, 0, !dbg !1077
  %is_pos_inf64 = and i1 %is_inf62, %347, !dbg !1077
  %is_neg_inf65 = and i1 %is_inf62, %348, !dbg !1077
  %is_pos_max66 = and i1 %is_maxfinite63, %347, !dbg !1077
  %is_neg_max67 = and i1 %is_maxfinite63, %348, !dbg !1077
  %overflow_cond68 = and i1 %337, %is_inf62, !dbg !1077
  br i1 %overflow_cond68, label %349, label %351, !dbg !1077

349:                                              ; preds = %332
  %350 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %351, !dbg !1077

351:                                              ; preds = %332, %349
  %352 = bitcast float %308 to i32, !dbg !1077
  %353 = and i32 %352, 2139095040, !dbg !1077
  %354 = icmp eq i32 %353, 0, !dbg !1077
  %355 = and i32 %352, 8388607, !dbg !1077
  %356 = icmp ne i32 %355, 0, !dbg !1077
  %is_subnormal69 = and i1 %354, %356, !dbg !1077
  %357 = xor i1 %is_subnormal69, true, !dbg !1077
  %358 = and i1 true, %357, !dbg !1077
  %359 = and i1 %358, true, !dbg !1077
  %360 = and i1 %359, true, !dbg !1077
  %361 = bitcast float %333 to i32, !dbg !1077
  %362 = and i32 %361, 2139095040, !dbg !1077
  %363 = icmp eq i32 %362, 0, !dbg !1077
  %364 = and i32 %361, 8388607, !dbg !1077
  %365 = icmp ne i32 %364, 0, !dbg !1077
  %is_subnormal70 = and i1 %363, %365, !dbg !1077
  %is_tiny71 = or i1 %is_subnormal70, false, !dbg !1077
  %underflow_cond72 = and i1 %360, %is_tiny71, !dbg !1077
  br i1 %underflow_cond72, label %366, label %368, !dbg !1077

366:                                              ; preds = %351
  %367 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %368, !dbg !1077

368:                                              ; preds = %351, %366
  %369 = call float @llvm.nvvm.saturate.f(float %333) #5, !dbg !1077
  %370 = bitcast float %369 to i32, !dbg !1077
  %371 = bitcast float %369 to i32, !dbg !1077
  %372 = and i32 %371, 2139095040, !dbg !1077
  %373 = icmp eq i32 %372, 2139095040, !dbg !1077
  %374 = and i32 %371, 8388607, !dbg !1077
  %375 = icmp ne i32 %374, 0, !dbg !1077
  %is_nan73 = and i1 %373, %375, !dbg !1077
  %376 = and i32 %370, 4194304, !dbg !1077
  %377 = icmp eq i32 %376, 0, !dbg !1077
  %is_snan74 = and i1 %is_nan73, %377, !dbg !1077
  %378 = or i1 %is_snan74, false, !dbg !1077
  %379 = or i1 %378, false, !dbg !1077
  %380 = bitcast float %369 to i32, !dbg !1077
  %381 = and i32 %380, 2147483647, !dbg !1077
  %is_zero75 = icmp eq i32 %381, 0, !dbg !1077
  %382 = and i1 %is_zero75, false, !dbg !1077
  %383 = bitcast float %369 to i32, !dbg !1077
  %384 = and i32 %383, 2139095040, !dbg !1077
  %385 = icmp eq i32 %384, 2139095040, !dbg !1077
  %386 = and i32 %383, 8388607, !dbg !1077
  %387 = icmp eq i32 %386, 0, !dbg !1077
  %is_inf76 = and i1 %385, %387, !dbg !1077
  %388 = and i1 %is_inf76, false, !dbg !1077
  %389 = or i1 %382, %388, !dbg !1077
  %390 = or i1 %379, %389, !dbg !1077
  br i1 %390, label %391, label %393, !dbg !1077

391:                                              ; preds = %368
  %392 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %393, !dbg !1077

393:                                              ; preds = %368, %391
  %394 = call float @llvm.nvvm.fma.rm.f(float %369, float 2.520000e+02, float 0x4168000020000000) #5, !dbg !1077
  %395 = bitcast float %369 to i32, !dbg !1077
  %396 = and i32 %395, 2139095040, !dbg !1077
  %is_finite77 = icmp ne i32 %396, 2139095040, !dbg !1077
  %397 = and i1 true, %is_finite77, !dbg !1077
  %398 = and i1 %397, true, !dbg !1077
  %399 = bitcast float %394 to i32, !dbg !1077
  %400 = and i32 %399, 2139095040, !dbg !1077
  %401 = icmp eq i32 %400, 2139095040, !dbg !1077
  %402 = and i32 %399, 8388607, !dbg !1077
  %403 = icmp eq i32 %402, 0, !dbg !1077
  %is_inf78 = and i1 %401, %403, !dbg !1077
  %404 = bitcast float %394 to i32, !dbg !1077
  %405 = and i32 %404, 2147483647, !dbg !1077
  %is_maxfinite79 = icmp eq i32 %405, 2139095039, !dbg !1077
  %406 = bitcast float %394 to i32, !dbg !1077
  %407 = and i32 %406, -2147483648, !dbg !1077
  %408 = icmp eq i32 %407, 0, !dbg !1077
  %409 = icmp ne i32 %407, 0, !dbg !1077
  %is_pos_inf80 = and i1 %is_inf78, %408, !dbg !1077
  %is_neg_inf81 = and i1 %is_inf78, %409, !dbg !1077
  %is_pos_max82 = and i1 %is_maxfinite79, %408, !dbg !1077
  %is_neg_max83 = and i1 %is_maxfinite79, %409, !dbg !1077
  %overflow_rm = or i1 %is_neg_inf81, %is_pos_max82, !dbg !1077
  %overflow_cond84 = and i1 %398, %overflow_rm, !dbg !1077
  br i1 %overflow_cond84, label %410, label %412, !dbg !1077

410:                                              ; preds = %393
  %411 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %412, !dbg !1077

412:                                              ; preds = %393, %410
  %413 = bitcast float %369 to i32, !dbg !1077
  %414 = and i32 %413, 2139095040, !dbg !1077
  %415 = icmp eq i32 %414, 0, !dbg !1077
  %416 = and i32 %413, 8388607, !dbg !1077
  %417 = icmp ne i32 %416, 0, !dbg !1077
  %is_subnormal85 = and i1 %415, %417, !dbg !1077
  %418 = xor i1 %is_subnormal85, true, !dbg !1077
  %419 = and i1 true, %418, !dbg !1077
  %420 = and i1 %419, true, !dbg !1077
  %421 = and i1 %420, true, !dbg !1077
  %422 = bitcast float %394 to i32, !dbg !1077
  %423 = and i32 %422, 2139095040, !dbg !1077
  %424 = icmp eq i32 %423, 0, !dbg !1077
  %425 = and i32 %422, 8388607, !dbg !1077
  %426 = icmp ne i32 %425, 0, !dbg !1077
  %is_subnormal86 = and i1 %424, %426, !dbg !1077
  %is_tiny87 = or i1 %is_subnormal86, false, !dbg !1077
  %underflow_cond88 = and i1 %421, %is_tiny87, !dbg !1077
  br i1 %underflow_cond88, label %427, label %429, !dbg !1077

427:                                              ; preds = %412
  %428 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %429, !dbg !1077

429:                                              ; preds = %412, %427
  %430 = bitcast float %394 to i32, !dbg !1077
  %431 = bitcast float %394 to i32, !dbg !1077
  %432 = and i32 %431, 2139095040, !dbg !1077
  %433 = icmp eq i32 %432, 2139095040, !dbg !1077
  %434 = and i32 %431, 8388607, !dbg !1077
  %435 = icmp ne i32 %434, 0, !dbg !1077
  %is_nan89 = and i1 %433, %435, !dbg !1077
  %436 = and i32 %430, 4194304, !dbg !1077
  %437 = icmp eq i32 %436, 0, !dbg !1077
  %is_snan90 = and i1 %is_nan89, %437, !dbg !1077
  %438 = or i1 %is_snan90, false, !dbg !1077
  %439 = bitcast float %394 to i32, !dbg !1077
  %440 = and i32 %439, 2139095040, !dbg !1077
  %441 = icmp eq i32 %440, 2139095040, !dbg !1077
  %442 = and i32 %439, 8388607, !dbg !1077
  %443 = icmp eq i32 %442, 0, !dbg !1077
  %is_inf91 = and i1 %441, %443, !dbg !1077
  %444 = and i1 %is_inf91, false, !dbg !1077
  %445 = bitcast float %394 to i32, !dbg !1077
  %446 = and i32 %445, -2147483648, !dbg !1077
  %447 = icmp eq i32 %446, 0, !dbg !1077
  %448 = and i1 %444, %447, !dbg !1077
  %449 = or i1 %438, %448, !dbg !1077
  br i1 %449, label %450, label %452, !dbg !1077

450:                                              ; preds = %429
  %451 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %452, !dbg !1077

452:                                              ; preds = %429, %450
  %453 = fsub float %394, 0x4168000FE0000000, !dbg !1077
  %454 = bitcast float %394 to i32, !dbg !1077
  %455 = and i32 %454, 2139095040, !dbg !1077
  %is_finite92 = icmp ne i32 %455, 2139095040, !dbg !1077
  %456 = and i1 true, %is_finite92, !dbg !1077
  %457 = and i1 %456, true, !dbg !1077
  %458 = bitcast float %453 to i32, !dbg !1077
  %459 = and i32 %458, 2139095040, !dbg !1077
  %460 = icmp eq i32 %459, 2139095040, !dbg !1077
  %461 = and i32 %458, 8388607, !dbg !1077
  %462 = icmp eq i32 %461, 0, !dbg !1077
  %is_inf93 = and i1 %460, %462, !dbg !1077
  %463 = bitcast float %453 to i32, !dbg !1077
  %464 = and i32 %463, 2147483647, !dbg !1077
  %is_maxfinite94 = icmp eq i32 %464, 2139095039, !dbg !1077
  %465 = bitcast float %453 to i32, !dbg !1077
  %466 = and i32 %465, -2147483648, !dbg !1077
  %467 = icmp eq i32 %466, 0, !dbg !1077
  %468 = icmp ne i32 %466, 0, !dbg !1077
  %is_pos_inf95 = and i1 %is_inf93, %467, !dbg !1077
  %is_neg_inf96 = and i1 %is_inf93, %468, !dbg !1077
  %is_pos_max97 = and i1 %is_maxfinite94, %467, !dbg !1077
  %is_neg_max98 = and i1 %is_maxfinite94, %468, !dbg !1077
  %overflow_cond99 = and i1 %457, %is_inf93, !dbg !1077
  br i1 %overflow_cond99, label %469, label %471, !dbg !1077

469:                                              ; preds = %452
  %470 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %471, !dbg !1077

471:                                              ; preds = %452, %469
  %472 = bitcast float %453 to i32, !dbg !1077
  %473 = bitcast float %453 to i32, !dbg !1077
  %474 = and i32 %473, 2139095040, !dbg !1077
  %475 = icmp eq i32 %474, 2139095040, !dbg !1077
  %476 = and i32 %473, 8388607, !dbg !1077
  %477 = icmp ne i32 %476, 0, !dbg !1077
  %is_nan100 = and i1 %475, %477, !dbg !1077
  %478 = and i32 %472, 4194304, !dbg !1077
  %479 = icmp eq i32 %478, 0, !dbg !1077
  %is_snan101 = and i1 %is_nan100, %479, !dbg !1077
  %480 = or i1 false, %is_snan101, !dbg !1077
  %481 = bitcast float %453 to i32, !dbg !1077
  %482 = and i32 %481, 2139095040, !dbg !1077
  %483 = icmp eq i32 %482, 2139095040, !dbg !1077
  %484 = and i32 %481, 8388607, !dbg !1077
  %485 = icmp eq i32 %484, 0, !dbg !1077
  %is_inf102 = and i1 %483, %485, !dbg !1077
  %486 = and i1 false, %is_inf102, !dbg !1077
  %487 = bitcast float %453 to i32, !dbg !1077
  %488 = and i32 %487, -2147483648, !dbg !1077
  %489 = icmp eq i32 -2147483648, %488, !dbg !1077
  %490 = and i1 %486, %489, !dbg !1077
  %491 = or i1 %480, %490, !dbg !1077
  br i1 %491, label %492, label %494, !dbg !1077

492:                                              ; preds = %471
  %493 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %494, !dbg !1077

494:                                              ; preds = %471, %492
  %495 = fsub float -0.000000e+00, %453, !dbg !1077
  %496 = bitcast float %453 to i32, !dbg !1077
  %497 = and i32 %496, 2139095040, !dbg !1077
  %is_finite103 = icmp ne i32 %497, 2139095040, !dbg !1077
  %498 = and i1 true, %is_finite103, !dbg !1077
  %499 = bitcast float %495 to i32, !dbg !1077
  %500 = and i32 %499, 2139095040, !dbg !1077
  %501 = icmp eq i32 %500, 2139095040, !dbg !1077
  %502 = and i32 %499, 8388607, !dbg !1077
  %503 = icmp eq i32 %502, 0, !dbg !1077
  %is_inf104 = and i1 %501, %503, !dbg !1077
  %504 = bitcast float %495 to i32, !dbg !1077
  %505 = and i32 %504, 2147483647, !dbg !1077
  %is_maxfinite105 = icmp eq i32 %505, 2139095039, !dbg !1077
  %506 = bitcast float %495 to i32, !dbg !1077
  %507 = and i32 %506, -2147483648, !dbg !1077
  %508 = icmp eq i32 %507, 0, !dbg !1077
  %509 = icmp ne i32 %507, 0, !dbg !1077
  %is_pos_inf106 = and i1 %is_inf104, %508, !dbg !1077
  %is_neg_inf107 = and i1 %is_inf104, %509, !dbg !1077
  %is_pos_max108 = and i1 %is_maxfinite105, %508, !dbg !1077
  %is_neg_max109 = and i1 %is_maxfinite105, %509, !dbg !1077
  %overflow_cond110 = and i1 %498, %is_inf104, !dbg !1077
  br i1 %overflow_cond110, label %510, label %512, !dbg !1077

510:                                              ; preds = %494
  %511 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %512, !dbg !1077

512:                                              ; preds = %494, %510
  %513 = bitcast float %308 to i32, !dbg !1077
  %514 = bitcast float %308 to i32, !dbg !1077
  %515 = and i32 %514, 2139095040, !dbg !1077
  %516 = icmp eq i32 %515, 2139095040, !dbg !1077
  %517 = and i32 %514, 8388607, !dbg !1077
  %518 = icmp ne i32 %517, 0, !dbg !1077
  %is_nan111 = and i1 %516, %518, !dbg !1077
  %519 = and i32 %513, 4194304, !dbg !1077
  %520 = icmp eq i32 %519, 0, !dbg !1077
  %is_snan112 = and i1 %is_nan111, %520, !dbg !1077
  %521 = or i1 %is_snan112, false, !dbg !1077
  %522 = bitcast float %495 to i32, !dbg !1077
  %523 = bitcast float %495 to i32, !dbg !1077
  %524 = and i32 %523, 2139095040, !dbg !1077
  %525 = icmp eq i32 %524, 2139095040, !dbg !1077
  %526 = and i32 %523, 8388607, !dbg !1077
  %527 = icmp ne i32 %526, 0, !dbg !1077
  %is_nan113 = and i1 %525, %527, !dbg !1077
  %528 = and i32 %522, 4194304, !dbg !1077
  %529 = icmp eq i32 %528, 0, !dbg !1077
  %is_snan114 = and i1 %is_nan113, %529, !dbg !1077
  %530 = or i1 %521, %is_snan114, !dbg !1077
  %531 = bitcast float %308 to i32, !dbg !1077
  %532 = and i32 %531, 2147483647, !dbg !1077
  %is_zero115 = icmp eq i32 %532, 0, !dbg !1077
  %533 = and i1 %is_zero115, false, !dbg !1077
  %534 = bitcast float %308 to i32, !dbg !1077
  %535 = and i32 %534, 2139095040, !dbg !1077
  %536 = icmp eq i32 %535, 2139095040, !dbg !1077
  %537 = and i32 %534, 8388607, !dbg !1077
  %538 = icmp eq i32 %537, 0, !dbg !1077
  %is_inf116 = and i1 %536, %538, !dbg !1077
  %539 = and i1 %is_inf116, false, !dbg !1077
  %540 = or i1 %533, %539, !dbg !1077
  %541 = or i1 %530, %540, !dbg !1077
  br i1 %541, label %542, label %544, !dbg !1077

542:                                              ; preds = %512
  %543 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %544, !dbg !1077

544:                                              ; preds = %512, %542
  %545 = call float @llvm.nvvm.fma.rn.f(float %308, float 0x3FF7154760000000, float %495) #5, !dbg !1077
  %546 = bitcast float %308 to i32, !dbg !1077
  %547 = and i32 %546, 2139095040, !dbg !1077
  %is_finite117 = icmp ne i32 %547, 2139095040, !dbg !1077
  %548 = and i1 true, %is_finite117, !dbg !1077
  %549 = and i1 %548, true, !dbg !1077
  %550 = bitcast float %545 to i32, !dbg !1077
  %551 = and i32 %550, 2139095040, !dbg !1077
  %552 = icmp eq i32 %551, 2139095040, !dbg !1077
  %553 = and i32 %550, 8388607, !dbg !1077
  %554 = icmp eq i32 %553, 0, !dbg !1077
  %is_inf118 = and i1 %552, %554, !dbg !1077
  %555 = bitcast float %545 to i32, !dbg !1077
  %556 = and i32 %555, 2147483647, !dbg !1077
  %is_maxfinite119 = icmp eq i32 %556, 2139095039, !dbg !1077
  %557 = bitcast float %545 to i32, !dbg !1077
  %558 = and i32 %557, -2147483648, !dbg !1077
  %559 = icmp eq i32 %558, 0, !dbg !1077
  %560 = icmp ne i32 %558, 0, !dbg !1077
  %is_pos_inf120 = and i1 %is_inf118, %559, !dbg !1077
  %is_neg_inf121 = and i1 %is_inf118, %560, !dbg !1077
  %is_pos_max122 = and i1 %is_maxfinite119, %559, !dbg !1077
  %is_neg_max123 = and i1 %is_maxfinite119, %560, !dbg !1077
  %overflow_cond124 = and i1 %549, %is_inf118, !dbg !1077
  br i1 %overflow_cond124, label %561, label %563, !dbg !1077

561:                                              ; preds = %544
  %562 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %563, !dbg !1077

563:                                              ; preds = %544, %561
  %564 = bitcast float %308 to i32, !dbg !1077
  %565 = and i32 %564, 2139095040, !dbg !1077
  %566 = icmp eq i32 %565, 0, !dbg !1077
  %567 = and i32 %564, 8388607, !dbg !1077
  %568 = icmp ne i32 %567, 0, !dbg !1077
  %is_subnormal125 = and i1 %566, %568, !dbg !1077
  %569 = xor i1 %is_subnormal125, true, !dbg !1077
  %570 = and i1 true, %569, !dbg !1077
  %571 = and i1 %570, true, !dbg !1077
  %572 = bitcast float %495 to i32, !dbg !1077
  %573 = and i32 %572, 2139095040, !dbg !1077
  %574 = icmp eq i32 %573, 0, !dbg !1077
  %575 = and i32 %572, 8388607, !dbg !1077
  %576 = icmp ne i32 %575, 0, !dbg !1077
  %is_subnormal126 = and i1 %574, %576, !dbg !1077
  %577 = xor i1 %is_subnormal126, true, !dbg !1077
  %578 = and i1 %571, %577, !dbg !1077
  %579 = bitcast float %545 to i32, !dbg !1077
  %580 = and i32 %579, 2139095040, !dbg !1077
  %581 = icmp eq i32 %580, 0, !dbg !1077
  %582 = and i32 %579, 8388607, !dbg !1077
  %583 = icmp ne i32 %582, 0, !dbg !1077
  %is_subnormal127 = and i1 %581, %583, !dbg !1077
  %is_tiny128 = or i1 %is_subnormal127, false, !dbg !1077
  %underflow_cond129 = and i1 %578, %is_tiny128, !dbg !1077
  br i1 %underflow_cond129, label %584, label %586, !dbg !1077

584:                                              ; preds = %563
  %585 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %586, !dbg !1077

586:                                              ; preds = %563, %584
  %587 = bitcast float %308 to i32, !dbg !1077
  %588 = bitcast float %308 to i32, !dbg !1077
  %589 = and i32 %588, 2139095040, !dbg !1077
  %590 = icmp eq i32 %589, 2139095040, !dbg !1077
  %591 = and i32 %588, 8388607, !dbg !1077
  %592 = icmp ne i32 %591, 0, !dbg !1077
  %is_nan130 = and i1 %590, %592, !dbg !1077
  %593 = and i32 %587, 4194304, !dbg !1077
  %594 = icmp eq i32 %593, 0, !dbg !1077
  %is_snan131 = and i1 %is_nan130, %594, !dbg !1077
  %595 = or i1 %is_snan131, false, !dbg !1077
  %596 = bitcast float %545 to i32, !dbg !1077
  %597 = bitcast float %545 to i32, !dbg !1077
  %598 = and i32 %597, 2139095040, !dbg !1077
  %599 = icmp eq i32 %598, 2139095040, !dbg !1077
  %600 = and i32 %597, 8388607, !dbg !1077
  %601 = icmp ne i32 %600, 0, !dbg !1077
  %is_nan132 = and i1 %599, %601, !dbg !1077
  %602 = and i32 %596, 4194304, !dbg !1077
  %603 = icmp eq i32 %602, 0, !dbg !1077
  %is_snan133 = and i1 %is_nan132, %603, !dbg !1077
  %604 = or i1 %595, %is_snan133, !dbg !1077
  %605 = bitcast float %308 to i32, !dbg !1077
  %606 = and i32 %605, 2147483647, !dbg !1077
  %is_zero134 = icmp eq i32 %606, 0, !dbg !1077
  %607 = and i1 %is_zero134, false, !dbg !1077
  %608 = bitcast float %308 to i32, !dbg !1077
  %609 = and i32 %608, 2139095040, !dbg !1077
  %610 = icmp eq i32 %609, 2139095040, !dbg !1077
  %611 = and i32 %608, 8388607, !dbg !1077
  %612 = icmp eq i32 %611, 0, !dbg !1077
  %is_inf135 = and i1 %610, %612, !dbg !1077
  %613 = and i1 %is_inf135, false, !dbg !1077
  %614 = or i1 %607, %613, !dbg !1077
  %615 = or i1 %604, %614, !dbg !1077
  br i1 %615, label %616, label %618, !dbg !1077

616:                                              ; preds = %586
  %617 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %618, !dbg !1077

618:                                              ; preds = %586, %616
  %619 = call float @llvm.nvvm.fma.rn.f(float %308, float 0x3E54AE0C00000000, float %545) #5, !dbg !1077
  %620 = bitcast float %308 to i32, !dbg !1077
  %621 = and i32 %620, 2139095040, !dbg !1077
  %is_finite136 = icmp ne i32 %621, 2139095040, !dbg !1077
  %622 = and i1 true, %is_finite136, !dbg !1077
  %623 = and i1 %622, true, !dbg !1077
  %624 = bitcast float %619 to i32, !dbg !1077
  %625 = and i32 %624, 2139095040, !dbg !1077
  %626 = icmp eq i32 %625, 2139095040, !dbg !1077
  %627 = and i32 %624, 8388607, !dbg !1077
  %628 = icmp eq i32 %627, 0, !dbg !1077
  %is_inf137 = and i1 %626, %628, !dbg !1077
  %629 = bitcast float %619 to i32, !dbg !1077
  %630 = and i32 %629, 2147483647, !dbg !1077
  %is_maxfinite138 = icmp eq i32 %630, 2139095039, !dbg !1077
  %631 = bitcast float %619 to i32, !dbg !1077
  %632 = and i32 %631, -2147483648, !dbg !1077
  %633 = icmp eq i32 %632, 0, !dbg !1077
  %634 = icmp ne i32 %632, 0, !dbg !1077
  %is_pos_inf139 = and i1 %is_inf137, %633, !dbg !1077
  %is_neg_inf140 = and i1 %is_inf137, %634, !dbg !1077
  %is_pos_max141 = and i1 %is_maxfinite138, %633, !dbg !1077
  %is_neg_max142 = and i1 %is_maxfinite138, %634, !dbg !1077
  %overflow_cond143 = and i1 %623, %is_inf137, !dbg !1077
  br i1 %overflow_cond143, label %635, label %637, !dbg !1077

635:                                              ; preds = %618
  %636 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %637, !dbg !1077

637:                                              ; preds = %618, %635
  %638 = bitcast float %308 to i32, !dbg !1077
  %639 = and i32 %638, 2139095040, !dbg !1077
  %640 = icmp eq i32 %639, 0, !dbg !1077
  %641 = and i32 %638, 8388607, !dbg !1077
  %642 = icmp ne i32 %641, 0, !dbg !1077
  %is_subnormal144 = and i1 %640, %642, !dbg !1077
  %643 = xor i1 %is_subnormal144, true, !dbg !1077
  %644 = and i1 true, %643, !dbg !1077
  %645 = and i1 %644, true, !dbg !1077
  %646 = bitcast float %545 to i32, !dbg !1077
  %647 = and i32 %646, 2139095040, !dbg !1077
  %648 = icmp eq i32 %647, 0, !dbg !1077
  %649 = and i32 %646, 8388607, !dbg !1077
  %650 = icmp ne i32 %649, 0, !dbg !1077
  %is_subnormal145 = and i1 %648, %650, !dbg !1077
  %651 = xor i1 %is_subnormal145, true, !dbg !1077
  %652 = and i1 %645, %651, !dbg !1077
  %653 = bitcast float %619 to i32, !dbg !1077
  %654 = and i32 %653, 2139095040, !dbg !1077
  %655 = icmp eq i32 %654, 0, !dbg !1077
  %656 = and i32 %653, 8388607, !dbg !1077
  %657 = icmp ne i32 %656, 0, !dbg !1077
  %is_subnormal146 = and i1 %655, %657, !dbg !1077
  %is_tiny147 = or i1 %is_subnormal146, false, !dbg !1077
  %underflow_cond148 = and i1 %652, %is_tiny147, !dbg !1077
  br i1 %underflow_cond148, label %658, label %660, !dbg !1077

658:                                              ; preds = %637
  %659 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %660, !dbg !1077

660:                                              ; preds = %637, %658
  %661 = bitcast float %394 to i32, !dbg !1077
  %662 = shl i32 %661, 23, !dbg !1077
  %663 = bitcast i32 %662 to float, !dbg !1077
  %664 = call float @llvm.nvvm.ex2.approx.ftz.f32(float %619), !dbg !1077
  %665 = bitcast float %664 to i32, !dbg !1077
  %666 = bitcast float %664 to i32, !dbg !1077
  %667 = and i32 %666, 2139095040, !dbg !1077
  %668 = icmp eq i32 %667, 2139095040, !dbg !1077
  %669 = and i32 %666, 8388607, !dbg !1077
  %670 = icmp ne i32 %669, 0, !dbg !1077
  %is_nan149 = and i1 %668, %670, !dbg !1077
  %671 = and i32 %665, 4194304, !dbg !1077
  %672 = icmp eq i32 %671, 0, !dbg !1077
  %is_snan150 = and i1 %is_nan149, %672, !dbg !1077
  %673 = bitcast float %663 to i32, !dbg !1077
  %674 = bitcast float %663 to i32, !dbg !1077
  %675 = and i32 %674, 2139095040, !dbg !1077
  %676 = icmp eq i32 %675, 2139095040, !dbg !1077
  %677 = and i32 %674, 8388607, !dbg !1077
  %678 = icmp ne i32 %677, 0, !dbg !1077
  %is_nan151 = and i1 %676, %678, !dbg !1077
  %679 = and i32 %673, 4194304, !dbg !1077
  %680 = icmp eq i32 %679, 0, !dbg !1077
  %is_snan152 = and i1 %is_nan151, %680, !dbg !1077
  %681 = or i1 %is_snan150, %is_snan152, !dbg !1077
  %682 = bitcast float %664 to i32, !dbg !1077
  %683 = and i32 %682, 2147483647, !dbg !1077
  %is_zero153 = icmp eq i32 %683, 0, !dbg !1077
  %684 = bitcast float %663 to i32, !dbg !1077
  %685 = and i32 %684, 2139095040, !dbg !1077
  %686 = icmp eq i32 %685, 2139095040, !dbg !1077
  %687 = and i32 %684, 8388607, !dbg !1077
  %688 = icmp eq i32 %687, 0, !dbg !1077
  %is_inf154 = and i1 %686, %688, !dbg !1077
  %689 = and i1 %is_zero153, %is_inf154, !dbg !1077
  %690 = bitcast float %664 to i32, !dbg !1077
  %691 = and i32 %690, 2139095040, !dbg !1077
  %692 = icmp eq i32 %691, 2139095040, !dbg !1077
  %693 = and i32 %690, 8388607, !dbg !1077
  %694 = icmp eq i32 %693, 0, !dbg !1077
  %is_inf155 = and i1 %692, %694, !dbg !1077
  %695 = bitcast float %663 to i32, !dbg !1077
  %696 = and i32 %695, 2147483647, !dbg !1077
  %is_zero156 = icmp eq i32 %696, 0, !dbg !1077
  %697 = and i1 %is_inf155, %is_zero156, !dbg !1077
  %698 = or i1 %689, %697, !dbg !1077
  %699 = or i1 %681, %698, !dbg !1077
  br i1 %699, label %700, label %702, !dbg !1077

700:                                              ; preds = %660
  %701 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %702, !dbg !1077

702:                                              ; preds = %660, %700
  %703 = fmul float %664, %663, !dbg !1077
  %704 = bitcast float %664 to i32, !dbg !1078
  %705 = and i32 %704, 2139095040, !dbg !1078
  %is_finite157 = icmp ne i32 %705, 2139095040, !dbg !1078
  %706 = and i1 true, %is_finite157, !dbg !1078
  %707 = bitcast float %663 to i32, !dbg !1078
  %708 = and i32 %707, 2139095040, !dbg !1078
  %is_finite158 = icmp ne i32 %708, 2139095040, !dbg !1078
  %709 = and i1 %706, %is_finite158, !dbg !1078
  %710 = bitcast float %703 to i32, !dbg !1078
  %711 = and i32 %710, 2139095040, !dbg !1078
  %712 = icmp eq i32 %711, 2139095040, !dbg !1078
  %713 = and i32 %710, 8388607, !dbg !1078
  %714 = icmp eq i32 %713, 0, !dbg !1078
  %is_inf159 = and i1 %712, %714, !dbg !1078
  %715 = bitcast float %703 to i32, !dbg !1078
  %716 = and i32 %715, 2147483647, !dbg !1078
  %is_maxfinite160 = icmp eq i32 %716, 2139095039, !dbg !1078
  %717 = bitcast float %703 to i32, !dbg !1078
  %718 = and i32 %717, -2147483648, !dbg !1078
  %719 = icmp eq i32 %718, 0, !dbg !1078
  %720 = icmp ne i32 %718, 0, !dbg !1078
  %is_pos_inf161 = and i1 %is_inf159, %719, !dbg !1078
  %is_neg_inf162 = and i1 %is_inf159, %720, !dbg !1078
  %is_pos_max163 = and i1 %is_maxfinite160, %719, !dbg !1078
  %is_neg_max164 = and i1 %is_maxfinite160, %720, !dbg !1078
  %overflow_cond165 = and i1 %709, %is_inf159, !dbg !1078
  br i1 %overflow_cond165, label %721, label %723, !dbg !1078

721:                                              ; preds = %702
  %722 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1078
  br label %723, !dbg !1078

723:                                              ; preds = %702, %721
  %724 = bitcast float %664 to i32, !dbg !1078
  %725 = and i32 %724, 2139095040, !dbg !1078
  %726 = icmp eq i32 %725, 0, !dbg !1078
  %727 = and i32 %724, 8388607, !dbg !1078
  %728 = icmp ne i32 %727, 0, !dbg !1078
  %is_subnormal166 = and i1 %726, %728, !dbg !1078
  %729 = xor i1 %is_subnormal166, true, !dbg !1078
  %730 = and i1 true, %729, !dbg !1078
  %731 = bitcast float %663 to i32, !dbg !1078
  %732 = and i32 %731, 2139095040, !dbg !1078
  %733 = icmp eq i32 %732, 0, !dbg !1078
  %734 = and i32 %731, 8388607, !dbg !1078
  %735 = icmp ne i32 %734, 0, !dbg !1078
  %is_subnormal167 = and i1 %733, %735, !dbg !1078
  %736 = xor i1 %is_subnormal167, true, !dbg !1078
  %737 = and i1 %730, %736, !dbg !1078
  %738 = bitcast float %703 to i32, !dbg !1078
  %739 = and i32 %738, 2139095040, !dbg !1078
  %740 = icmp eq i32 %739, 0, !dbg !1078
  %741 = and i32 %738, 8388607, !dbg !1078
  %742 = icmp ne i32 %741, 0, !dbg !1078
  %is_subnormal168 = and i1 %740, %742, !dbg !1078
  %743 = bitcast float %703 to i32, !dbg !1078
  %744 = and i32 %743, 2147483647, !dbg !1078
  %is_zero169 = icmp eq i32 %744, 0, !dbg !1078
  %745 = bitcast float %664 to i32, !dbg !1078
  %746 = and i32 %745, 2147483647, !dbg !1078
  %is_zero170 = icmp eq i32 %746, 0, !dbg !1078
  %747 = xor i1 %is_zero170, true, !dbg !1078
  %748 = bitcast float %663 to i32, !dbg !1078
  %749 = and i32 %748, 2147483647, !dbg !1078
  %is_zero171 = icmp eq i32 %749, 0, !dbg !1078
  %750 = xor i1 %is_zero171, true, !dbg !1078
  %751 = and i1 %747, %750, !dbg !1078
  %752 = and i1 %is_zero169, %751, !dbg !1078
  %is_tiny172 = or i1 %is_subnormal168, %752, !dbg !1078
  %underflow_cond173 = and i1 %737, %is_tiny172, !dbg !1078
  br i1 %underflow_cond173, label %753, label %755, !dbg !1078

753:                                              ; preds = %723
  %754 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1078
  br label %755, !dbg !1078

755:                                              ; preds = %723, %753
  %756 = load ptr, ptr %result.addr, align 8, !dbg !1078
  %arrayidx40 = getelementptr inbounds float, ptr %756, i64 5, !dbg !1078
  store float %703, ptr %arrayidx40, align 4, !dbg !1079
  %757 = load ptr, ptr %result.addr, align 8, !dbg !1080
  %arrayidx41 = getelementptr inbounds float, ptr %757, i64 5, !dbg !1080
  %758 = load float, ptr %arrayidx41, align 4, !dbg !1080
  %call42 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %758) #4, !dbg !1081
  %759 = zext i1 %call42 to i64, !dbg !1081
  %cond43 = select i1 %call42, i32 1, i32 0, !dbg !1081
  %760 = load ptr, ptr %is_denorm.addr, align 8, !dbg !1082
  %arrayidx44 = getelementptr inbounds i32, ptr %760, i64 5, !dbg !1082
  store i32 %cond43, ptr %arrayidx44, align 4, !dbg !1083
  br label %if.end45, !dbg !1084

if.end45:                                         ; preds = %755, %if.end36
  %761 = load i32, ptr %idx, align 4, !dbg !1085
  %cmp46 = icmp eq i32 %761, 6, !dbg !1087
  br i1 %cmp46, label %if.then47, label %if.end54, !dbg !1087

if.then47:                                        ; preds = %if.end45
  store float 0x3FB99999A0000000, ptr %__a.addr.i66, align 4
    #dbg_declare(ptr %__a.addr.i66, !1088, !DIExpression(), !1089)
  store float 4.000000e+01, ptr %__b.addr.i, align 4
    #dbg_declare(ptr %__b.addr.i, !1092, !DIExpression(), !1093)
  %762 = load float, ptr %__a.addr.i66, align 4, !dbg !1094
  %763 = load float, ptr %__b.addr.i, align 4, !dbg !1095
  %764 = bitcast float %763 to i32, !dbg !1096
  %765 = bitcast float %763 to i32, !dbg !1096
  %766 = and i32 %765, 2139095040, !dbg !1096
  %767 = icmp eq i32 %766, 2139095040, !dbg !1096
  %768 = and i32 %765, 8388607, !dbg !1096
  %769 = icmp ne i32 %768, 0, !dbg !1096
  %is_nan174 = and i1 %767, %769, !dbg !1096
  %770 = and i32 %764, 4194304, !dbg !1096
  %771 = icmp eq i32 %770, 0, !dbg !1096
  %is_snan175 = and i1 %is_nan174, %771, !dbg !1096
  %772 = or i1 false, %is_snan175, !dbg !1096
  %773 = bitcast float %763 to i32, !dbg !1096
  %774 = and i32 %773, 2139095040, !dbg !1096
  %775 = icmp eq i32 %774, 2139095040, !dbg !1096
  %776 = and i32 %773, 8388607, !dbg !1096
  %777 = icmp eq i32 %776, 0, !dbg !1096
  %is_inf176 = and i1 %775, %777, !dbg !1096
  %778 = and i1 false, %is_inf176, !dbg !1096
  %779 = bitcast float %763 to i32, !dbg !1096
  %780 = and i32 %779, 2147483647, !dbg !1096
  %is_zero177 = icmp eq i32 %780, 0, !dbg !1096
  %781 = and i1 false, %is_zero177, !dbg !1096
  %782 = or i1 %778, %781, !dbg !1096
  %783 = or i1 %772, %782, !dbg !1096
  br i1 %783, label %784, label %786, !dbg !1096

784:                                              ; preds = %if.then47
  %785 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %786, !dbg !1096

786:                                              ; preds = %if.then47, %784
  %787 = fmul float 5.000000e-01, %763, !dbg !1096
  %788 = bitcast float %763 to i32, !dbg !1096
  %789 = and i32 %788, 2139095040, !dbg !1096
  %is_finite178 = icmp ne i32 %789, 2139095040, !dbg !1096
  %790 = and i1 true, %is_finite178, !dbg !1096
  %791 = bitcast float %787 to i32, !dbg !1096
  %792 = and i32 %791, 2139095040, !dbg !1096
  %793 = icmp eq i32 %792, 2139095040, !dbg !1096
  %794 = and i32 %791, 8388607, !dbg !1096
  %795 = icmp eq i32 %794, 0, !dbg !1096
  %is_inf179 = and i1 %793, %795, !dbg !1096
  %796 = bitcast float %787 to i32, !dbg !1096
  %797 = and i32 %796, 2147483647, !dbg !1096
  %is_maxfinite180 = icmp eq i32 %797, 2139095039, !dbg !1096
  %798 = bitcast float %787 to i32, !dbg !1096
  %799 = and i32 %798, -2147483648, !dbg !1096
  %800 = icmp eq i32 %799, 0, !dbg !1096
  %801 = icmp ne i32 %799, 0, !dbg !1096
  %is_pos_inf181 = and i1 %is_inf179, %800, !dbg !1096
  %is_neg_inf182 = and i1 %is_inf179, %801, !dbg !1096
  %is_pos_max183 = and i1 %is_maxfinite180, %800, !dbg !1096
  %is_neg_max184 = and i1 %is_maxfinite180, %801, !dbg !1096
  %overflow_cond185 = and i1 %790, %is_inf179, !dbg !1096
  br i1 %overflow_cond185, label %802, label %804, !dbg !1096

802:                                              ; preds = %786
  %803 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %804, !dbg !1096

804:                                              ; preds = %786, %802
  %805 = bitcast float %763 to i32, !dbg !1096
  %806 = and i32 %805, 2139095040, !dbg !1096
  %807 = icmp eq i32 %806, 0, !dbg !1096
  %808 = and i32 %805, 8388607, !dbg !1096
  %809 = icmp ne i32 %808, 0, !dbg !1096
  %is_subnormal186 = and i1 %807, %809, !dbg !1096
  %810 = xor i1 %is_subnormal186, true, !dbg !1096
  %811 = and i1 true, %810, !dbg !1096
  %812 = bitcast float %787 to i32, !dbg !1096
  %813 = and i32 %812, 2139095040, !dbg !1096
  %814 = icmp eq i32 %813, 0, !dbg !1096
  %815 = and i32 %812, 8388607, !dbg !1096
  %816 = icmp ne i32 %815, 0, !dbg !1096
  %is_subnormal187 = and i1 %814, %816, !dbg !1096
  %817 = bitcast float %787 to i32, !dbg !1096
  %818 = and i32 %817, 2147483647, !dbg !1096
  %is_zero188 = icmp eq i32 %818, 0, !dbg !1096
  %819 = bitcast float %763 to i32, !dbg !1096
  %820 = and i32 %819, 2147483647, !dbg !1096
  %is_zero189 = icmp eq i32 %820, 0, !dbg !1096
  %821 = xor i1 %is_zero189, true, !dbg !1096
  %822 = and i1 true, %821, !dbg !1096
  %823 = and i1 %is_zero188, %822, !dbg !1096
  %is_tiny190 = or i1 %is_subnormal187, %823, !dbg !1096
  %underflow_cond191 = and i1 %811, %is_tiny190, !dbg !1096
  br i1 %underflow_cond191, label %824, label %826, !dbg !1096

824:                                              ; preds = %804
  %825 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %826, !dbg !1096

826:                                              ; preds = %804, %824
  %827 = call float @llvm.nvvm.trunc.f(float %787) #5, !dbg !1096
  %828 = bitcast float %827 to i32, !dbg !1096
  %829 = bitcast float %827 to i32, !dbg !1096
  %830 = and i32 %829, 2139095040, !dbg !1096
  %831 = icmp eq i32 %830, 2139095040, !dbg !1096
  %832 = and i32 %829, 8388607, !dbg !1096
  %833 = icmp ne i32 %832, 0, !dbg !1096
  %is_nan192 = and i1 %831, %833, !dbg !1096
  %834 = and i32 %828, 4194304, !dbg !1096
  %835 = icmp eq i32 %834, 0, !dbg !1096
  %is_snan193 = and i1 %is_nan192, %835, !dbg !1096
  %836 = or i1 false, %is_snan193, !dbg !1096
  %837 = bitcast float %827 to i32, !dbg !1096
  %838 = and i32 %837, 2139095040, !dbg !1096
  %839 = icmp eq i32 %838, 2139095040, !dbg !1096
  %840 = and i32 %837, 8388607, !dbg !1096
  %841 = icmp eq i32 %840, 0, !dbg !1096
  %is_inf194 = and i1 %839, %841, !dbg !1096
  %842 = and i1 false, %is_inf194, !dbg !1096
  %843 = bitcast float %827 to i32, !dbg !1096
  %844 = and i32 %843, 2147483647, !dbg !1096
  %is_zero195 = icmp eq i32 %844, 0, !dbg !1096
  %845 = and i1 false, %is_zero195, !dbg !1096
  %846 = or i1 %842, %845, !dbg !1096
  %847 = or i1 %836, %846, !dbg !1096
  br i1 %847, label %848, label %850, !dbg !1096

848:                                              ; preds = %826
  %849 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %850, !dbg !1096

850:                                              ; preds = %826, %848
  %851 = fmul float 2.000000e+00, %827, !dbg !1096
  %852 = bitcast float %827 to i32, !dbg !1096
  %853 = and i32 %852, 2139095040, !dbg !1096
  %is_finite196 = icmp ne i32 %853, 2139095040, !dbg !1096
  %854 = and i1 true, %is_finite196, !dbg !1096
  %855 = bitcast float %851 to i32, !dbg !1096
  %856 = and i32 %855, 2139095040, !dbg !1096
  %857 = icmp eq i32 %856, 2139095040, !dbg !1096
  %858 = and i32 %855, 8388607, !dbg !1096
  %859 = icmp eq i32 %858, 0, !dbg !1096
  %is_inf197 = and i1 %857, %859, !dbg !1096
  %860 = bitcast float %851 to i32, !dbg !1096
  %861 = and i32 %860, 2147483647, !dbg !1096
  %is_maxfinite198 = icmp eq i32 %861, 2139095039, !dbg !1096
  %862 = bitcast float %851 to i32, !dbg !1096
  %863 = and i32 %862, -2147483648, !dbg !1096
  %864 = icmp eq i32 %863, 0, !dbg !1096
  %865 = icmp ne i32 %863, 0, !dbg !1096
  %is_pos_inf199 = and i1 %is_inf197, %864, !dbg !1096
  %is_neg_inf200 = and i1 %is_inf197, %865, !dbg !1096
  %is_pos_max201 = and i1 %is_maxfinite198, %864, !dbg !1096
  %is_neg_max202 = and i1 %is_maxfinite198, %865, !dbg !1096
  %overflow_cond203 = and i1 %854, %is_inf197, !dbg !1096
  br i1 %overflow_cond203, label %866, label %868, !dbg !1096

866:                                              ; preds = %850
  %867 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %868, !dbg !1096

868:                                              ; preds = %850, %866
  %869 = bitcast float %827 to i32, !dbg !1096
  %870 = and i32 %869, 2139095040, !dbg !1096
  %871 = icmp eq i32 %870, 0, !dbg !1096
  %872 = and i32 %869, 8388607, !dbg !1096
  %873 = icmp ne i32 %872, 0, !dbg !1096
  %is_subnormal204 = and i1 %871, %873, !dbg !1096
  %874 = xor i1 %is_subnormal204, true, !dbg !1096
  %875 = and i1 true, %874, !dbg !1096
  %876 = bitcast float %851 to i32, !dbg !1096
  %877 = and i32 %876, 2139095040, !dbg !1096
  %878 = icmp eq i32 %877, 0, !dbg !1096
  %879 = and i32 %876, 8388607, !dbg !1096
  %880 = icmp ne i32 %879, 0, !dbg !1096
  %is_subnormal205 = and i1 %878, %880, !dbg !1096
  %881 = bitcast float %851 to i32, !dbg !1096
  %882 = and i32 %881, 2147483647, !dbg !1096
  %is_zero206 = icmp eq i32 %882, 0, !dbg !1096
  %883 = bitcast float %827 to i32, !dbg !1096
  %884 = and i32 %883, 2147483647, !dbg !1096
  %is_zero207 = icmp eq i32 %884, 0, !dbg !1096
  %885 = xor i1 %is_zero207, true, !dbg !1096
  %886 = and i1 true, %885, !dbg !1096
  %887 = and i1 %is_zero206, %886, !dbg !1096
  %is_tiny208 = or i1 %is_subnormal205, %887, !dbg !1096
  %underflow_cond209 = and i1 %875, %is_tiny208, !dbg !1096
  br i1 %underflow_cond209, label %888, label %890, !dbg !1096

888:                                              ; preds = %868
  %889 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %890, !dbg !1096

890:                                              ; preds = %868, %888
  %891 = bitcast float %763 to i32, !dbg !1096
  %892 = bitcast float %763 to i32, !dbg !1096
  %893 = and i32 %892, 2139095040, !dbg !1096
  %894 = icmp eq i32 %893, 2139095040, !dbg !1096
  %895 = and i32 %892, 8388607, !dbg !1096
  %896 = icmp ne i32 %895, 0, !dbg !1096
  %is_nan210 = and i1 %894, %896, !dbg !1096
  %897 = and i32 %891, 4194304, !dbg !1096
  %898 = icmp eq i32 %897, 0, !dbg !1096
  %is_snan211 = and i1 %is_nan210, %898, !dbg !1096
  %899 = bitcast float %851 to i32, !dbg !1096
  %900 = bitcast float %851 to i32, !dbg !1096
  %901 = and i32 %900, 2139095040, !dbg !1096
  %902 = icmp eq i32 %901, 2139095040, !dbg !1096
  %903 = and i32 %900, 8388607, !dbg !1096
  %904 = icmp ne i32 %903, 0, !dbg !1096
  %is_nan212 = and i1 %902, %904, !dbg !1096
  %905 = and i32 %899, 4194304, !dbg !1096
  %906 = icmp eq i32 %905, 0, !dbg !1096
  %is_snan213 = and i1 %is_nan212, %906, !dbg !1096
  %907 = or i1 %is_snan211, %is_snan213, !dbg !1096
  %908 = bitcast float %763 to i32, !dbg !1096
  %909 = and i32 %908, 2139095040, !dbg !1096
  %910 = icmp eq i32 %909, 2139095040, !dbg !1096
  %911 = and i32 %908, 8388607, !dbg !1096
  %912 = icmp eq i32 %911, 0, !dbg !1096
  %is_inf214 = and i1 %910, %912, !dbg !1096
  %913 = bitcast float %851 to i32, !dbg !1096
  %914 = and i32 %913, 2139095040, !dbg !1096
  %915 = icmp eq i32 %914, 2139095040, !dbg !1096
  %916 = and i32 %913, 8388607, !dbg !1096
  %917 = icmp eq i32 %916, 0, !dbg !1096
  %is_inf215 = and i1 %915, %917, !dbg !1096
  %918 = and i1 %is_inf214, %is_inf215, !dbg !1096
  %919 = bitcast float %763 to i32, !dbg !1096
  %920 = bitcast float %851 to i32, !dbg !1096
  %921 = and i32 %919, -2147483648, !dbg !1096
  %922 = and i32 %920, -2147483648, !dbg !1096
  %923 = icmp eq i32 %921, %922, !dbg !1096
  %924 = and i1 %918, %923, !dbg !1096
  %925 = or i1 %907, %924, !dbg !1096
  br i1 %925, label %926, label %928, !dbg !1096

926:                                              ; preds = %890
  %927 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %928, !dbg !1096

928:                                              ; preds = %890, %926
  %929 = fsub float %763, %851, !dbg !1096
  %930 = bitcast float %763 to i32, !dbg !1096
  %931 = and i32 %930, 2139095040, !dbg !1096
  %is_finite216 = icmp ne i32 %931, 2139095040, !dbg !1096
  %932 = and i1 true, %is_finite216, !dbg !1096
  %933 = bitcast float %851 to i32, !dbg !1096
  %934 = and i32 %933, 2139095040, !dbg !1096
  %is_finite217 = icmp ne i32 %934, 2139095040, !dbg !1096
  %935 = and i1 %932, %is_finite217, !dbg !1096
  %936 = bitcast float %929 to i32, !dbg !1096
  %937 = and i32 %936, 2139095040, !dbg !1096
  %938 = icmp eq i32 %937, 2139095040, !dbg !1096
  %939 = and i32 %936, 8388607, !dbg !1096
  %940 = icmp eq i32 %939, 0, !dbg !1096
  %is_inf218 = and i1 %938, %940, !dbg !1096
  %941 = bitcast float %929 to i32, !dbg !1096
  %942 = and i32 %941, 2147483647, !dbg !1096
  %is_maxfinite219 = icmp eq i32 %942, 2139095039, !dbg !1096
  %943 = bitcast float %929 to i32, !dbg !1096
  %944 = and i32 %943, -2147483648, !dbg !1096
  %945 = icmp eq i32 %944, 0, !dbg !1096
  %946 = icmp ne i32 %944, 0, !dbg !1096
  %is_pos_inf220 = and i1 %is_inf218, %945, !dbg !1096
  %is_neg_inf221 = and i1 %is_inf218, %946, !dbg !1096
  %is_pos_max222 = and i1 %is_maxfinite219, %945, !dbg !1096
  %is_neg_max223 = and i1 %is_maxfinite219, %946, !dbg !1096
  %overflow_cond224 = and i1 %935, %is_inf218, !dbg !1096
  br i1 %overflow_cond224, label %947, label %949, !dbg !1096

947:                                              ; preds = %928
  %948 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %949, !dbg !1096

949:                                              ; preds = %928, %947
  %950 = call float @llvm.nvvm.fabs.f32(float %929), !dbg !1096
  %951 = fcmp oeq float %950, 1.000000e+00, !dbg !1096
  %952 = select i1 %951, i32 1, i32 0, !dbg !1096
  %953 = call float @llvm.nvvm.fabs.f32(float %762), !dbg !1096
  %954 = fcmp olt float %953, 0x3810000000000000, !dbg !1096
  br i1 %954, label %955, label %1021, !dbg !1096

955:                                              ; preds = %949
  %956 = bitcast float %953 to i32, !dbg !1096
  %957 = bitcast float %953 to i32, !dbg !1096
  %958 = and i32 %957, 2139095040, !dbg !1096
  %959 = icmp eq i32 %958, 2139095040, !dbg !1096
  %960 = and i32 %957, 8388607, !dbg !1096
  %961 = icmp ne i32 %960, 0, !dbg !1096
  %is_nan225 = and i1 %959, %961, !dbg !1096
  %962 = and i32 %956, 4194304, !dbg !1096
  %963 = icmp eq i32 %962, 0, !dbg !1096
  %is_snan226 = and i1 %is_nan225, %963, !dbg !1096
  %964 = or i1 %is_snan226, false, !dbg !1096
  %965 = bitcast float %953 to i32, !dbg !1096
  %966 = and i32 %965, 2147483647, !dbg !1096
  %is_zero227 = icmp eq i32 %966, 0, !dbg !1096
  %967 = and i1 %is_zero227, false, !dbg !1096
  %968 = bitcast float %953 to i32, !dbg !1096
  %969 = and i32 %968, 2139095040, !dbg !1096
  %970 = icmp eq i32 %969, 2139095040, !dbg !1096
  %971 = and i32 %968, 8388607, !dbg !1096
  %972 = icmp eq i32 %971, 0, !dbg !1096
  %is_inf228 = and i1 %970, %972, !dbg !1096
  %973 = and i1 %is_inf228, false, !dbg !1096
  %974 = or i1 %967, %973, !dbg !1096
  %975 = or i1 %964, %974, !dbg !1096
  br i1 %975, label %976, label %978, !dbg !1096

976:                                              ; preds = %955
  %977 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %978, !dbg !1096

978:                                              ; preds = %955, %976
  %979 = fmul float %953, 0x4170000000000000, !dbg !1096
  %980 = bitcast float %953 to i32, !dbg !1096
  %981 = and i32 %980, 2139095040, !dbg !1096
  %is_finite229 = icmp ne i32 %981, 2139095040, !dbg !1096
  %982 = and i1 true, %is_finite229, !dbg !1096
  %983 = and i1 %982, true, !dbg !1096
  %984 = bitcast float %979 to i32, !dbg !1096
  %985 = and i32 %984, 2139095040, !dbg !1096
  %986 = icmp eq i32 %985, 2139095040, !dbg !1096
  %987 = and i32 %984, 8388607, !dbg !1096
  %988 = icmp eq i32 %987, 0, !dbg !1096
  %is_inf230 = and i1 %986, %988, !dbg !1096
  %989 = bitcast float %979 to i32, !dbg !1096
  %990 = and i32 %989, 2147483647, !dbg !1096
  %is_maxfinite231 = icmp eq i32 %990, 2139095039, !dbg !1096
  %991 = bitcast float %979 to i32, !dbg !1096
  %992 = and i32 %991, -2147483648, !dbg !1096
  %993 = icmp eq i32 %992, 0, !dbg !1096
  %994 = icmp ne i32 %992, 0, !dbg !1096
  %is_pos_inf232 = and i1 %is_inf230, %993, !dbg !1096
  %is_neg_inf233 = and i1 %is_inf230, %994, !dbg !1096
  %is_pos_max234 = and i1 %is_maxfinite231, %993, !dbg !1096
  %is_neg_max235 = and i1 %is_maxfinite231, %994, !dbg !1096
  %overflow_cond236 = and i1 %983, %is_inf230, !dbg !1096
  br i1 %overflow_cond236, label %995, label %997, !dbg !1096

995:                                              ; preds = %978
  %996 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %997, !dbg !1096

997:                                              ; preds = %978, %995
  %998 = bitcast float %953 to i32, !dbg !1096
  %999 = and i32 %998, 2139095040, !dbg !1096
  %1000 = icmp eq i32 %999, 0, !dbg !1096
  %1001 = and i32 %998, 8388607, !dbg !1096
  %1002 = icmp ne i32 %1001, 0, !dbg !1096
  %is_subnormal237 = and i1 %1000, %1002, !dbg !1096
  %1003 = xor i1 %is_subnormal237, true, !dbg !1096
  %1004 = and i1 true, %1003, !dbg !1096
  %1005 = and i1 %1004, true, !dbg !1096
  %1006 = bitcast float %979 to i32, !dbg !1096
  %1007 = and i32 %1006, 2139095040, !dbg !1096
  %1008 = icmp eq i32 %1007, 0, !dbg !1096
  %1009 = and i32 %1006, 8388607, !dbg !1096
  %1010 = icmp ne i32 %1009, 0, !dbg !1096
  %is_subnormal238 = and i1 %1008, %1010, !dbg !1096
  %1011 = bitcast float %979 to i32, !dbg !1096
  %1012 = and i32 %1011, 2147483647, !dbg !1096
  %is_zero239 = icmp eq i32 %1012, 0, !dbg !1096
  %1013 = bitcast float %953 to i32, !dbg !1096
  %1014 = and i32 %1013, 2147483647, !dbg !1096
  %is_zero240 = icmp eq i32 %1014, 0, !dbg !1096
  %1015 = xor i1 %is_zero240, true, !dbg !1096
  %1016 = and i1 %1015, true, !dbg !1096
  %1017 = and i1 %is_zero239, %1016, !dbg !1096
  %is_tiny241 = or i1 %is_subnormal238, %1017, !dbg !1096
  %underflow_cond242 = and i1 %1005, %is_tiny241, !dbg !1096
  br i1 %underflow_cond242, label %1018, label %1020, !dbg !1096

1018:                                             ; preds = %997
  %1019 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1020, !dbg !1096

1020:                                             ; preds = %997, %1018
  br label %1021, !dbg !1096

1021:                                             ; preds = %1020, %949
  %.013.i = phi float [ %979, %1020 ], [ %953, %949 ], !dbg !1096
  %expo.i.i.0.i = phi float [ -2.400000e+01, %1020 ], [ 0.000000e+00, %949 ], !dbg !1096
  %1022 = bitcast float %.013.i to i32, !dbg !1096
  %1023 = sub i32 %1022, 1060439283, !dbg !1096
  %1024 = and i32 %1023, -8388608, !dbg !1096
  %1025 = bitcast float %.013.i to i32, !dbg !1096
  %1026 = sub i32 %1025, %1024, !dbg !1096
  %1027 = bitcast i32 %1026 to float, !dbg !1096
  %1028 = sitofp i32 %1024 to float, !dbg !1096
  %1029 = bitcast float %1028 to i32, !dbg !1096
  %1030 = bitcast float %1028 to i32, !dbg !1096
  %1031 = and i32 %1030, 2139095040, !dbg !1096
  %1032 = icmp eq i32 %1031, 2139095040, !dbg !1096
  %1033 = and i32 %1030, 8388607, !dbg !1096
  %1034 = icmp ne i32 %1033, 0, !dbg !1096
  %is_nan243 = and i1 %1032, %1034, !dbg !1096
  %1035 = and i32 %1029, 4194304, !dbg !1096
  %1036 = icmp eq i32 %1035, 0, !dbg !1096
  %is_snan244 = and i1 %is_nan243, %1036, !dbg !1096
  %1037 = or i1 %is_snan244, false, !dbg !1096
  %1038 = bitcast float %expo.i.i.0.i to i32, !dbg !1096
  %1039 = bitcast float %expo.i.i.0.i to i32, !dbg !1096
  %1040 = and i32 %1039, 2139095040, !dbg !1096
  %1041 = icmp eq i32 %1040, 2139095040, !dbg !1096
  %1042 = and i32 %1039, 8388607, !dbg !1096
  %1043 = icmp ne i32 %1042, 0, !dbg !1096
  %is_nan245 = and i1 %1041, %1043, !dbg !1096
  %1044 = and i32 %1038, 4194304, !dbg !1096
  %1045 = icmp eq i32 %1044, 0, !dbg !1096
  %is_snan246 = and i1 %is_nan245, %1045, !dbg !1096
  %1046 = or i1 %1037, %is_snan246, !dbg !1096
  %1047 = bitcast float %1028 to i32, !dbg !1096
  %1048 = and i32 %1047, 2147483647, !dbg !1096
  %is_zero247 = icmp eq i32 %1048, 0, !dbg !1096
  %1049 = and i1 %is_zero247, false, !dbg !1096
  %1050 = bitcast float %1028 to i32, !dbg !1096
  %1051 = and i32 %1050, 2139095040, !dbg !1096
  %1052 = icmp eq i32 %1051, 2139095040, !dbg !1096
  %1053 = and i32 %1050, 8388607, !dbg !1096
  %1054 = icmp eq i32 %1053, 0, !dbg !1096
  %is_inf248 = and i1 %1052, %1054, !dbg !1096
  %1055 = and i1 %is_inf248, false, !dbg !1096
  %1056 = or i1 %1049, %1055, !dbg !1096
  %1057 = or i1 %1046, %1056, !dbg !1096
  br i1 %1057, label %1058, label %1060, !dbg !1096

1058:                                             ; preds = %1021
  %1059 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1060, !dbg !1096

1060:                                             ; preds = %1021, %1058
  %1061 = call float @llvm.nvvm.fma.rn.f(float %1028, float 0x3E80000000000000, float %expo.i.i.0.i) #5, !dbg !1096
  %1062 = bitcast float %1028 to i32, !dbg !1096
  %1063 = and i32 %1062, 2139095040, !dbg !1096
  %is_finite249 = icmp ne i32 %1063, 2139095040, !dbg !1096
  %1064 = and i1 true, %is_finite249, !dbg !1096
  %1065 = and i1 %1064, true, !dbg !1096
  %1066 = bitcast float %1061 to i32, !dbg !1096
  %1067 = and i32 %1066, 2139095040, !dbg !1096
  %1068 = icmp eq i32 %1067, 2139095040, !dbg !1096
  %1069 = and i32 %1066, 8388607, !dbg !1096
  %1070 = icmp eq i32 %1069, 0, !dbg !1096
  %is_inf250 = and i1 %1068, %1070, !dbg !1096
  %1071 = bitcast float %1061 to i32, !dbg !1096
  %1072 = and i32 %1071, 2147483647, !dbg !1096
  %is_maxfinite251 = icmp eq i32 %1072, 2139095039, !dbg !1096
  %1073 = bitcast float %1061 to i32, !dbg !1096
  %1074 = and i32 %1073, -2147483648, !dbg !1096
  %1075 = icmp eq i32 %1074, 0, !dbg !1096
  %1076 = icmp ne i32 %1074, 0, !dbg !1096
  %is_pos_inf252 = and i1 %is_inf250, %1075, !dbg !1096
  %is_neg_inf253 = and i1 %is_inf250, %1076, !dbg !1096
  %is_pos_max254 = and i1 %is_maxfinite251, %1075, !dbg !1096
  %is_neg_max255 = and i1 %is_maxfinite251, %1076, !dbg !1096
  %overflow_cond256 = and i1 %1065, %is_inf250, !dbg !1096
  br i1 %overflow_cond256, label %1077, label %1079, !dbg !1096

1077:                                             ; preds = %1060
  %1078 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1079, !dbg !1096

1079:                                             ; preds = %1060, %1077
  %1080 = bitcast float %1028 to i32, !dbg !1096
  %1081 = and i32 %1080, 2139095040, !dbg !1096
  %1082 = icmp eq i32 %1081, 0, !dbg !1096
  %1083 = and i32 %1080, 8388607, !dbg !1096
  %1084 = icmp ne i32 %1083, 0, !dbg !1096
  %is_subnormal257 = and i1 %1082, %1084, !dbg !1096
  %1085 = xor i1 %is_subnormal257, true, !dbg !1096
  %1086 = and i1 true, %1085, !dbg !1096
  %1087 = and i1 %1086, true, !dbg !1096
  %1088 = bitcast float %expo.i.i.0.i to i32, !dbg !1096
  %1089 = and i32 %1088, 2139095040, !dbg !1096
  %1090 = icmp eq i32 %1089, 0, !dbg !1096
  %1091 = and i32 %1088, 8388607, !dbg !1096
  %1092 = icmp ne i32 %1091, 0, !dbg !1096
  %is_subnormal258 = and i1 %1090, %1092, !dbg !1096
  %1093 = xor i1 %is_subnormal258, true, !dbg !1096
  %1094 = and i1 %1087, %1093, !dbg !1096
  %1095 = bitcast float %1061 to i32, !dbg !1096
  %1096 = and i32 %1095, 2139095040, !dbg !1096
  %1097 = icmp eq i32 %1096, 0, !dbg !1096
  %1098 = and i32 %1095, 8388607, !dbg !1096
  %1099 = icmp ne i32 %1098, 0, !dbg !1096
  %is_subnormal259 = and i1 %1097, %1099, !dbg !1096
  %is_tiny260 = or i1 %is_subnormal259, false, !dbg !1096
  %underflow_cond261 = and i1 %1094, %is_tiny260, !dbg !1096
  br i1 %underflow_cond261, label %1100, label %1102, !dbg !1096

1100:                                             ; preds = %1079
  %1101 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1102, !dbg !1096

1102:                                             ; preds = %1079, %1100
  %1103 = bitcast float %1027 to i32, !dbg !1096
  %1104 = bitcast float %1027 to i32, !dbg !1096
  %1105 = and i32 %1104, 2139095040, !dbg !1096
  %1106 = icmp eq i32 %1105, 2139095040, !dbg !1096
  %1107 = and i32 %1104, 8388607, !dbg !1096
  %1108 = icmp ne i32 %1107, 0, !dbg !1096
  %is_nan262 = and i1 %1106, %1108, !dbg !1096
  %1109 = and i32 %1103, 4194304, !dbg !1096
  %1110 = icmp eq i32 %1109, 0, !dbg !1096
  %is_snan263 = and i1 %is_nan262, %1110, !dbg !1096
  %1111 = or i1 %is_snan263, false, !dbg !1096
  %1112 = bitcast float %1027 to i32, !dbg !1096
  %1113 = and i32 %1112, 2139095040, !dbg !1096
  %1114 = icmp eq i32 %1113, 2139095040, !dbg !1096
  %1115 = and i32 %1112, 8388607, !dbg !1096
  %1116 = icmp eq i32 %1115, 0, !dbg !1096
  %is_inf264 = and i1 %1114, %1116, !dbg !1096
  %1117 = and i1 %is_inf264, false, !dbg !1096
  %1118 = bitcast float %1027 to i32, !dbg !1096
  %1119 = and i32 %1118, -2147483648, !dbg !1096
  %1120 = icmp eq i32 %1119, 0, !dbg !1096
  %1121 = and i1 %1117, %1120, !dbg !1096
  %1122 = or i1 %1111, %1121, !dbg !1096
  br i1 %1122, label %1123, label %1125, !dbg !1096

1123:                                             ; preds = %1102
  %1124 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1125, !dbg !1096

1125:                                             ; preds = %1102, %1123
  %1126 = fsub float %1027, 1.000000e+00, !dbg !1096
  %1127 = bitcast float %1027 to i32, !dbg !1096
  %1128 = and i32 %1127, 2139095040, !dbg !1096
  %is_finite265 = icmp ne i32 %1128, 2139095040, !dbg !1096
  %1129 = and i1 true, %is_finite265, !dbg !1096
  %1130 = and i1 %1129, true, !dbg !1096
  %1131 = bitcast float %1126 to i32, !dbg !1096
  %1132 = and i32 %1131, 2139095040, !dbg !1096
  %1133 = icmp eq i32 %1132, 2139095040, !dbg !1096
  %1134 = and i32 %1131, 8388607, !dbg !1096
  %1135 = icmp eq i32 %1134, 0, !dbg !1096
  %is_inf266 = and i1 %1133, %1135, !dbg !1096
  %1136 = bitcast float %1126 to i32, !dbg !1096
  %1137 = and i32 %1136, 2147483647, !dbg !1096
  %is_maxfinite267 = icmp eq i32 %1137, 2139095039, !dbg !1096
  %1138 = bitcast float %1126 to i32, !dbg !1096
  %1139 = and i32 %1138, -2147483648, !dbg !1096
  %1140 = icmp eq i32 %1139, 0, !dbg !1096
  %1141 = icmp ne i32 %1139, 0, !dbg !1096
  %is_pos_inf268 = and i1 %is_inf266, %1140, !dbg !1096
  %is_neg_inf269 = and i1 %is_inf266, %1141, !dbg !1096
  %is_pos_max270 = and i1 %is_maxfinite267, %1140, !dbg !1096
  %is_neg_max271 = and i1 %is_maxfinite267, %1141, !dbg !1096
  %overflow_cond272 = and i1 %1130, %is_inf266, !dbg !1096
  br i1 %overflow_cond272, label %1142, label %1144, !dbg !1096

1142:                                             ; preds = %1125
  %1143 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1144, !dbg !1096

1144:                                             ; preds = %1125, %1142
  %1145 = bitcast float %1027 to i32, !dbg !1096
  %1146 = bitcast float %1027 to i32, !dbg !1096
  %1147 = and i32 %1146, 2139095040, !dbg !1096
  %1148 = icmp eq i32 %1147, 2139095040, !dbg !1096
  %1149 = and i32 %1146, 8388607, !dbg !1096
  %1150 = icmp ne i32 %1149, 0, !dbg !1096
  %is_nan273 = and i1 %1148, %1150, !dbg !1096
  %1151 = and i32 %1145, 4194304, !dbg !1096
  %1152 = icmp eq i32 %1151, 0, !dbg !1096
  %is_snan274 = and i1 %is_nan273, %1152, !dbg !1096
  %1153 = or i1 %is_snan274, false, !dbg !1096
  %1154 = bitcast float %1027 to i32, !dbg !1096
  %1155 = and i32 %1154, 2139095040, !dbg !1096
  %1156 = icmp eq i32 %1155, 2139095040, !dbg !1096
  %1157 = and i32 %1154, 8388607, !dbg !1096
  %1158 = icmp eq i32 %1157, 0, !dbg !1096
  %is_inf275 = and i1 %1156, %1158, !dbg !1096
  %1159 = and i1 %is_inf275, false, !dbg !1096
  %1160 = bitcast float %1027 to i32, !dbg !1096
  %1161 = and i32 %1160, -2147483648, !dbg !1096
  %1162 = icmp ne i32 %1161, 0, !dbg !1096
  %1163 = and i1 %1159, %1162, !dbg !1096
  %1164 = or i1 %1153, %1163, !dbg !1096
  br i1 %1164, label %1165, label %1167, !dbg !1096

1165:                                             ; preds = %1144
  %1166 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1167, !dbg !1096

1167:                                             ; preds = %1144, %1165
  %1168 = fadd float %1027, 1.000000e+00, !dbg !1096
  %1169 = bitcast float %1027 to i32, !dbg !1096
  %1170 = and i32 %1169, 2139095040, !dbg !1096
  %is_finite276 = icmp ne i32 %1170, 2139095040, !dbg !1096
  %1171 = and i1 true, %is_finite276, !dbg !1096
  %1172 = and i1 %1171, true, !dbg !1096
  %1173 = bitcast float %1168 to i32, !dbg !1096
  %1174 = and i32 %1173, 2139095040, !dbg !1096
  %1175 = icmp eq i32 %1174, 2139095040, !dbg !1096
  %1176 = and i32 %1173, 8388607, !dbg !1096
  %1177 = icmp eq i32 %1176, 0, !dbg !1096
  %is_inf277 = and i1 %1175, %1177, !dbg !1096
  %1178 = bitcast float %1168 to i32, !dbg !1096
  %1179 = and i32 %1178, 2147483647, !dbg !1096
  %is_maxfinite278 = icmp eq i32 %1179, 2139095039, !dbg !1096
  %1180 = bitcast float %1168 to i32, !dbg !1096
  %1181 = and i32 %1180, -2147483648, !dbg !1096
  %1182 = icmp eq i32 %1181, 0, !dbg !1096
  %1183 = icmp ne i32 %1181, 0, !dbg !1096
  %is_pos_inf279 = and i1 %is_inf277, %1182, !dbg !1096
  %is_neg_inf280 = and i1 %is_inf277, %1183, !dbg !1096
  %is_pos_max281 = and i1 %is_maxfinite278, %1182, !dbg !1096
  %is_neg_max282 = and i1 %is_maxfinite278, %1183, !dbg !1096
  %overflow_cond283 = and i1 %1172, %is_inf277, !dbg !1096
  br i1 %overflow_cond283, label %1184, label %1186, !dbg !1096

1184:                                             ; preds = %1167
  %1185 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1186, !dbg !1096

1186:                                             ; preds = %1167, %1184
  %1187 = call float asm "rcp.approx.ftz.f32 $0,$1;", "=f,f"(float %1168) #6, !dbg !1096, !srcloc !1097
  %1188 = bitcast float %1126 to i32, !dbg !1096
  %1189 = bitcast float %1126 to i32, !dbg !1096
  %1190 = and i32 %1189, 2139095040, !dbg !1096
  %1191 = icmp eq i32 %1190, 2139095040, !dbg !1096
  %1192 = and i32 %1189, 8388607, !dbg !1096
  %1193 = icmp ne i32 %1192, 0, !dbg !1096
  %is_nan284 = and i1 %1191, %1193, !dbg !1096
  %1194 = and i32 %1188, 4194304, !dbg !1096
  %1195 = icmp eq i32 %1194, 0, !dbg !1096
  %is_snan285 = and i1 %is_nan284, %1195, !dbg !1096
  %1196 = or i1 false, %is_snan285, !dbg !1096
  %1197 = bitcast float %1126 to i32, !dbg !1096
  %1198 = and i32 %1197, 2139095040, !dbg !1096
  %1199 = icmp eq i32 %1198, 2139095040, !dbg !1096
  %1200 = and i32 %1197, 8388607, !dbg !1096
  %1201 = icmp eq i32 %1200, 0, !dbg !1096
  %is_inf286 = and i1 %1199, %1201, !dbg !1096
  %1202 = and i1 false, %is_inf286, !dbg !1096
  %1203 = bitcast float %1126 to i32, !dbg !1096
  %1204 = and i32 %1203, 2147483647, !dbg !1096
  %is_zero287 = icmp eq i32 %1204, 0, !dbg !1096
  %1205 = and i1 false, %is_zero287, !dbg !1096
  %1206 = or i1 %1202, %1205, !dbg !1096
  %1207 = or i1 %1196, %1206, !dbg !1096
  br i1 %1207, label %1208, label %1210, !dbg !1096

1208:                                             ; preds = %1186
  %1209 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1210, !dbg !1096

1210:                                             ; preds = %1186, %1208
  %1211 = fmul float 2.000000e+00, %1126, !dbg !1096
  %1212 = bitcast float %1126 to i32, !dbg !1096
  %1213 = and i32 %1212, 2139095040, !dbg !1096
  %is_finite288 = icmp ne i32 %1213, 2139095040, !dbg !1096
  %1214 = and i1 true, %is_finite288, !dbg !1096
  %1215 = bitcast float %1211 to i32, !dbg !1096
  %1216 = and i32 %1215, 2139095040, !dbg !1096
  %1217 = icmp eq i32 %1216, 2139095040, !dbg !1096
  %1218 = and i32 %1215, 8388607, !dbg !1096
  %1219 = icmp eq i32 %1218, 0, !dbg !1096
  %is_inf289 = and i1 %1217, %1219, !dbg !1096
  %1220 = bitcast float %1211 to i32, !dbg !1096
  %1221 = and i32 %1220, 2147483647, !dbg !1096
  %is_maxfinite290 = icmp eq i32 %1221, 2139095039, !dbg !1096
  %1222 = bitcast float %1211 to i32, !dbg !1096
  %1223 = and i32 %1222, -2147483648, !dbg !1096
  %1224 = icmp eq i32 %1223, 0, !dbg !1096
  %1225 = icmp ne i32 %1223, 0, !dbg !1096
  %is_pos_inf291 = and i1 %is_inf289, %1224, !dbg !1096
  %is_neg_inf292 = and i1 %is_inf289, %1225, !dbg !1096
  %is_pos_max293 = and i1 %is_maxfinite290, %1224, !dbg !1096
  %is_neg_max294 = and i1 %is_maxfinite290, %1225, !dbg !1096
  %overflow_cond295 = and i1 %1214, %is_inf289, !dbg !1096
  br i1 %overflow_cond295, label %1226, label %1228, !dbg !1096

1226:                                             ; preds = %1210
  %1227 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1228, !dbg !1096

1228:                                             ; preds = %1210, %1226
  %1229 = bitcast float %1126 to i32, !dbg !1096
  %1230 = and i32 %1229, 2139095040, !dbg !1096
  %1231 = icmp eq i32 %1230, 0, !dbg !1096
  %1232 = and i32 %1229, 8388607, !dbg !1096
  %1233 = icmp ne i32 %1232, 0, !dbg !1096
  %is_subnormal296 = and i1 %1231, %1233, !dbg !1096
  %1234 = xor i1 %is_subnormal296, true, !dbg !1096
  %1235 = and i1 true, %1234, !dbg !1096
  %1236 = bitcast float %1211 to i32, !dbg !1096
  %1237 = and i32 %1236, 2139095040, !dbg !1096
  %1238 = icmp eq i32 %1237, 0, !dbg !1096
  %1239 = and i32 %1236, 8388607, !dbg !1096
  %1240 = icmp ne i32 %1239, 0, !dbg !1096
  %is_subnormal297 = and i1 %1238, %1240, !dbg !1096
  %1241 = bitcast float %1211 to i32, !dbg !1096
  %1242 = and i32 %1241, 2147483647, !dbg !1096
  %is_zero298 = icmp eq i32 %1242, 0, !dbg !1096
  %1243 = bitcast float %1126 to i32, !dbg !1096
  %1244 = and i32 %1243, 2147483647, !dbg !1096
  %is_zero299 = icmp eq i32 %1244, 0, !dbg !1096
  %1245 = xor i1 %is_zero299, true, !dbg !1096
  %1246 = and i1 true, %1245, !dbg !1096
  %1247 = and i1 %is_zero298, %1246, !dbg !1096
  %is_tiny300 = or i1 %is_subnormal297, %1247, !dbg !1096
  %underflow_cond301 = and i1 %1235, %is_tiny300, !dbg !1096
  br i1 %underflow_cond301, label %1248, label %1250, !dbg !1096

1248:                                             ; preds = %1228
  %1249 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1250, !dbg !1096

1250:                                             ; preds = %1228, %1248
  %1251 = bitcast float %1211 to i32, !dbg !1096
  %1252 = bitcast float %1211 to i32, !dbg !1096
  %1253 = and i32 %1252, 2139095040, !dbg !1096
  %1254 = icmp eq i32 %1253, 2139095040, !dbg !1096
  %1255 = and i32 %1252, 8388607, !dbg !1096
  %1256 = icmp ne i32 %1255, 0, !dbg !1096
  %is_nan302 = and i1 %1254, %1256, !dbg !1096
  %1257 = and i32 %1251, 4194304, !dbg !1096
  %1258 = icmp eq i32 %1257, 0, !dbg !1096
  %is_snan303 = and i1 %is_nan302, %1258, !dbg !1096
  %1259 = bitcast float %1187 to i32, !dbg !1096
  %1260 = bitcast float %1187 to i32, !dbg !1096
  %1261 = and i32 %1260, 2139095040, !dbg !1096
  %1262 = icmp eq i32 %1261, 2139095040, !dbg !1096
  %1263 = and i32 %1260, 8388607, !dbg !1096
  %1264 = icmp ne i32 %1263, 0, !dbg !1096
  %is_nan304 = and i1 %1262, %1264, !dbg !1096
  %1265 = and i32 %1259, 4194304, !dbg !1096
  %1266 = icmp eq i32 %1265, 0, !dbg !1096
  %is_snan305 = and i1 %is_nan304, %1266, !dbg !1096
  %1267 = or i1 %is_snan303, %is_snan305, !dbg !1096
  %1268 = bitcast float %1211 to i32, !dbg !1096
  %1269 = and i32 %1268, 2147483647, !dbg !1096
  %is_zero306 = icmp eq i32 %1269, 0, !dbg !1096
  %1270 = bitcast float %1187 to i32, !dbg !1096
  %1271 = and i32 %1270, 2139095040, !dbg !1096
  %1272 = icmp eq i32 %1271, 2139095040, !dbg !1096
  %1273 = and i32 %1270, 8388607, !dbg !1096
  %1274 = icmp eq i32 %1273, 0, !dbg !1096
  %is_inf307 = and i1 %1272, %1274, !dbg !1096
  %1275 = and i1 %is_zero306, %is_inf307, !dbg !1096
  %1276 = bitcast float %1211 to i32, !dbg !1096
  %1277 = and i32 %1276, 2139095040, !dbg !1096
  %1278 = icmp eq i32 %1277, 2139095040, !dbg !1096
  %1279 = and i32 %1276, 8388607, !dbg !1096
  %1280 = icmp eq i32 %1279, 0, !dbg !1096
  %is_inf308 = and i1 %1278, %1280, !dbg !1096
  %1281 = bitcast float %1187 to i32, !dbg !1096
  %1282 = and i32 %1281, 2147483647, !dbg !1096
  %is_zero309 = icmp eq i32 %1282, 0, !dbg !1096
  %1283 = and i1 %is_inf308, %is_zero309, !dbg !1096
  %1284 = or i1 %1275, %1283, !dbg !1096
  %1285 = or i1 %1267, %1284, !dbg !1096
  br i1 %1285, label %1286, label %1288, !dbg !1096

1286:                                             ; preds = %1250
  %1287 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1288, !dbg !1096

1288:                                             ; preds = %1250, %1286
  %1289 = fmul float %1211, %1187, !dbg !1096
  %1290 = bitcast float %1211 to i32, !dbg !1096
  %1291 = and i32 %1290, 2139095040, !dbg !1096
  %is_finite310 = icmp ne i32 %1291, 2139095040, !dbg !1096
  %1292 = and i1 true, %is_finite310, !dbg !1096
  %1293 = bitcast float %1187 to i32, !dbg !1096
  %1294 = and i32 %1293, 2139095040, !dbg !1096
  %is_finite311 = icmp ne i32 %1294, 2139095040, !dbg !1096
  %1295 = and i1 %1292, %is_finite311, !dbg !1096
  %1296 = bitcast float %1289 to i32, !dbg !1096
  %1297 = and i32 %1296, 2139095040, !dbg !1096
  %1298 = icmp eq i32 %1297, 2139095040, !dbg !1096
  %1299 = and i32 %1296, 8388607, !dbg !1096
  %1300 = icmp eq i32 %1299, 0, !dbg !1096
  %is_inf312 = and i1 %1298, %1300, !dbg !1096
  %1301 = bitcast float %1289 to i32, !dbg !1096
  %1302 = and i32 %1301, 2147483647, !dbg !1096
  %is_maxfinite313 = icmp eq i32 %1302, 2139095039, !dbg !1096
  %1303 = bitcast float %1289 to i32, !dbg !1096
  %1304 = and i32 %1303, -2147483648, !dbg !1096
  %1305 = icmp eq i32 %1304, 0, !dbg !1096
  %1306 = icmp ne i32 %1304, 0, !dbg !1096
  %is_pos_inf314 = and i1 %is_inf312, %1305, !dbg !1096
  %is_neg_inf315 = and i1 %is_inf312, %1306, !dbg !1096
  %is_pos_max316 = and i1 %is_maxfinite313, %1305, !dbg !1096
  %is_neg_max317 = and i1 %is_maxfinite313, %1306, !dbg !1096
  %overflow_cond318 = and i1 %1295, %is_inf312, !dbg !1096
  br i1 %overflow_cond318, label %1307, label %1309, !dbg !1096

1307:                                             ; preds = %1288
  %1308 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1309, !dbg !1096

1309:                                             ; preds = %1288, %1307
  %1310 = bitcast float %1211 to i32, !dbg !1096
  %1311 = and i32 %1310, 2139095040, !dbg !1096
  %1312 = icmp eq i32 %1311, 0, !dbg !1096
  %1313 = and i32 %1310, 8388607, !dbg !1096
  %1314 = icmp ne i32 %1313, 0, !dbg !1096
  %is_subnormal319 = and i1 %1312, %1314, !dbg !1096
  %1315 = xor i1 %is_subnormal319, true, !dbg !1096
  %1316 = and i1 true, %1315, !dbg !1096
  %1317 = bitcast float %1187 to i32, !dbg !1096
  %1318 = and i32 %1317, 2139095040, !dbg !1096
  %1319 = icmp eq i32 %1318, 0, !dbg !1096
  %1320 = and i32 %1317, 8388607, !dbg !1096
  %1321 = icmp ne i32 %1320, 0, !dbg !1096
  %is_subnormal320 = and i1 %1319, %1321, !dbg !1096
  %1322 = xor i1 %is_subnormal320, true, !dbg !1096
  %1323 = and i1 %1316, %1322, !dbg !1096
  %1324 = bitcast float %1289 to i32, !dbg !1096
  %1325 = and i32 %1324, 2139095040, !dbg !1096
  %1326 = icmp eq i32 %1325, 0, !dbg !1096
  %1327 = and i32 %1324, 8388607, !dbg !1096
  %1328 = icmp ne i32 %1327, 0, !dbg !1096
  %is_subnormal321 = and i1 %1326, %1328, !dbg !1096
  %1329 = bitcast float %1289 to i32, !dbg !1096
  %1330 = and i32 %1329, 2147483647, !dbg !1096
  %is_zero322 = icmp eq i32 %1330, 0, !dbg !1096
  %1331 = bitcast float %1211 to i32, !dbg !1096
  %1332 = and i32 %1331, 2147483647, !dbg !1096
  %is_zero323 = icmp eq i32 %1332, 0, !dbg !1096
  %1333 = xor i1 %is_zero323, true, !dbg !1096
  %1334 = bitcast float %1187 to i32, !dbg !1096
  %1335 = and i32 %1334, 2147483647, !dbg !1096
  %is_zero324 = icmp eq i32 %1335, 0, !dbg !1096
  %1336 = xor i1 %is_zero324, true, !dbg !1096
  %1337 = and i1 %1333, %1336, !dbg !1096
  %1338 = and i1 %is_zero322, %1337, !dbg !1096
  %is_tiny325 = or i1 %is_subnormal321, %1338, !dbg !1096
  %underflow_cond326 = and i1 %1323, %is_tiny325, !dbg !1096
  br i1 %underflow_cond326, label %1339, label %1341, !dbg !1096

1339:                                             ; preds = %1309
  %1340 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1341, !dbg !1096

1341:                                             ; preds = %1309, %1339
  %1342 = bitcast float %1289 to i32, !dbg !1096
  %1343 = bitcast float %1289 to i32, !dbg !1096
  %1344 = and i32 %1343, 2139095040, !dbg !1096
  %1345 = icmp eq i32 %1344, 2139095040, !dbg !1096
  %1346 = and i32 %1343, 8388607, !dbg !1096
  %1347 = icmp ne i32 %1346, 0, !dbg !1096
  %is_nan327 = and i1 %1345, %1347, !dbg !1096
  %1348 = and i32 %1342, 4194304, !dbg !1096
  %1349 = icmp eq i32 %1348, 0, !dbg !1096
  %is_snan328 = and i1 %is_nan327, %1349, !dbg !1096
  %1350 = bitcast float %1289 to i32, !dbg !1096
  %1351 = bitcast float %1289 to i32, !dbg !1096
  %1352 = and i32 %1351, 2139095040, !dbg !1096
  %1353 = icmp eq i32 %1352, 2139095040, !dbg !1096
  %1354 = and i32 %1351, 8388607, !dbg !1096
  %1355 = icmp ne i32 %1354, 0, !dbg !1096
  %is_nan329 = and i1 %1353, %1355, !dbg !1096
  %1356 = and i32 %1350, 4194304, !dbg !1096
  %1357 = icmp eq i32 %1356, 0, !dbg !1096
  %is_snan330 = and i1 %is_nan329, %1357, !dbg !1096
  %1358 = or i1 %is_snan328, %is_snan330, !dbg !1096
  %1359 = bitcast float %1289 to i32, !dbg !1096
  %1360 = and i32 %1359, 2147483647, !dbg !1096
  %is_zero331 = icmp eq i32 %1360, 0, !dbg !1096
  %1361 = bitcast float %1289 to i32, !dbg !1096
  %1362 = and i32 %1361, 2139095040, !dbg !1096
  %1363 = icmp eq i32 %1362, 2139095040, !dbg !1096
  %1364 = and i32 %1361, 8388607, !dbg !1096
  %1365 = icmp eq i32 %1364, 0, !dbg !1096
  %is_inf332 = and i1 %1363, %1365, !dbg !1096
  %1366 = and i1 %is_zero331, %is_inf332, !dbg !1096
  %1367 = bitcast float %1289 to i32, !dbg !1096
  %1368 = and i32 %1367, 2139095040, !dbg !1096
  %1369 = icmp eq i32 %1368, 2139095040, !dbg !1096
  %1370 = and i32 %1367, 8388607, !dbg !1096
  %1371 = icmp eq i32 %1370, 0, !dbg !1096
  %is_inf333 = and i1 %1369, %1371, !dbg !1096
  %1372 = bitcast float %1289 to i32, !dbg !1096
  %1373 = and i32 %1372, 2147483647, !dbg !1096
  %is_zero334 = icmp eq i32 %1373, 0, !dbg !1096
  %1374 = and i1 %is_inf333, %is_zero334, !dbg !1096
  %1375 = or i1 %1366, %1374, !dbg !1096
  %1376 = or i1 %1358, %1375, !dbg !1096
  br i1 %1376, label %1377, label %1379, !dbg !1096

1377:                                             ; preds = %1341
  %1378 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1379, !dbg !1096

1379:                                             ; preds = %1341, %1377
  %1380 = fmul float %1289, %1289, !dbg !1096
  %1381 = bitcast float %1289 to i32, !dbg !1096
  %1382 = and i32 %1381, 2139095040, !dbg !1096
  %is_finite335 = icmp ne i32 %1382, 2139095040, !dbg !1096
  %1383 = and i1 true, %is_finite335, !dbg !1096
  %1384 = bitcast float %1289 to i32, !dbg !1096
  %1385 = and i32 %1384, 2139095040, !dbg !1096
  %is_finite336 = icmp ne i32 %1385, 2139095040, !dbg !1096
  %1386 = and i1 %1383, %is_finite336, !dbg !1096
  %1387 = bitcast float %1380 to i32, !dbg !1096
  %1388 = and i32 %1387, 2139095040, !dbg !1096
  %1389 = icmp eq i32 %1388, 2139095040, !dbg !1096
  %1390 = and i32 %1387, 8388607, !dbg !1096
  %1391 = icmp eq i32 %1390, 0, !dbg !1096
  %is_inf337 = and i1 %1389, %1391, !dbg !1096
  %1392 = bitcast float %1380 to i32, !dbg !1096
  %1393 = and i32 %1392, 2147483647, !dbg !1096
  %is_maxfinite338 = icmp eq i32 %1393, 2139095039, !dbg !1096
  %1394 = bitcast float %1380 to i32, !dbg !1096
  %1395 = and i32 %1394, -2147483648, !dbg !1096
  %1396 = icmp eq i32 %1395, 0, !dbg !1096
  %1397 = icmp ne i32 %1395, 0, !dbg !1096
  %is_pos_inf339 = and i1 %is_inf337, %1396, !dbg !1096
  %is_neg_inf340 = and i1 %is_inf337, %1397, !dbg !1096
  %is_pos_max341 = and i1 %is_maxfinite338, %1396, !dbg !1096
  %is_neg_max342 = and i1 %is_maxfinite338, %1397, !dbg !1096
  %overflow_cond343 = and i1 %1386, %is_inf337, !dbg !1096
  br i1 %overflow_cond343, label %1398, label %1400, !dbg !1096

1398:                                             ; preds = %1379
  %1399 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1400, !dbg !1096

1400:                                             ; preds = %1379, %1398
  %1401 = bitcast float %1289 to i32, !dbg !1096
  %1402 = and i32 %1401, 2139095040, !dbg !1096
  %1403 = icmp eq i32 %1402, 0, !dbg !1096
  %1404 = and i32 %1401, 8388607, !dbg !1096
  %1405 = icmp ne i32 %1404, 0, !dbg !1096
  %is_subnormal344 = and i1 %1403, %1405, !dbg !1096
  %1406 = xor i1 %is_subnormal344, true, !dbg !1096
  %1407 = and i1 true, %1406, !dbg !1096
  %1408 = bitcast float %1289 to i32, !dbg !1096
  %1409 = and i32 %1408, 2139095040, !dbg !1096
  %1410 = icmp eq i32 %1409, 0, !dbg !1096
  %1411 = and i32 %1408, 8388607, !dbg !1096
  %1412 = icmp ne i32 %1411, 0, !dbg !1096
  %is_subnormal345 = and i1 %1410, %1412, !dbg !1096
  %1413 = xor i1 %is_subnormal345, true, !dbg !1096
  %1414 = and i1 %1407, %1413, !dbg !1096
  %1415 = bitcast float %1380 to i32, !dbg !1096
  %1416 = and i32 %1415, 2139095040, !dbg !1096
  %1417 = icmp eq i32 %1416, 0, !dbg !1096
  %1418 = and i32 %1415, 8388607, !dbg !1096
  %1419 = icmp ne i32 %1418, 0, !dbg !1096
  %is_subnormal346 = and i1 %1417, %1419, !dbg !1096
  %1420 = bitcast float %1380 to i32, !dbg !1096
  %1421 = and i32 %1420, 2147483647, !dbg !1096
  %is_zero347 = icmp eq i32 %1421, 0, !dbg !1096
  %1422 = bitcast float %1289 to i32, !dbg !1096
  %1423 = and i32 %1422, 2147483647, !dbg !1096
  %is_zero348 = icmp eq i32 %1423, 0, !dbg !1096
  %1424 = xor i1 %is_zero348, true, !dbg !1096
  %1425 = bitcast float %1289 to i32, !dbg !1096
  %1426 = and i32 %1425, 2147483647, !dbg !1096
  %is_zero349 = icmp eq i32 %1426, 0, !dbg !1096
  %1427 = xor i1 %is_zero349, true, !dbg !1096
  %1428 = and i1 %1424, %1427, !dbg !1096
  %1429 = and i1 %is_zero347, %1428, !dbg !1096
  %is_tiny350 = or i1 %is_subnormal346, %1429, !dbg !1096
  %underflow_cond351 = and i1 %1414, %is_tiny350, !dbg !1096
  br i1 %underflow_cond351, label %1430, label %1432, !dbg !1096

1430:                                             ; preds = %1400
  %1431 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1432, !dbg !1096

1432:                                             ; preds = %1400, %1430
  %1433 = bitcast float %1126 to i32, !dbg !1096
  %1434 = bitcast float %1126 to i32, !dbg !1096
  %1435 = and i32 %1434, 2139095040, !dbg !1096
  %1436 = icmp eq i32 %1435, 2139095040, !dbg !1096
  %1437 = and i32 %1434, 8388607, !dbg !1096
  %1438 = icmp ne i32 %1437, 0, !dbg !1096
  %is_nan352 = and i1 %1436, %1438, !dbg !1096
  %1439 = and i32 %1433, 4194304, !dbg !1096
  %1440 = icmp eq i32 %1439, 0, !dbg !1096
  %is_snan353 = and i1 %is_nan352, %1440, !dbg !1096
  %1441 = bitcast float %1289 to i32, !dbg !1096
  %1442 = bitcast float %1289 to i32, !dbg !1096
  %1443 = and i32 %1442, 2139095040, !dbg !1096
  %1444 = icmp eq i32 %1443, 2139095040, !dbg !1096
  %1445 = and i32 %1442, 8388607, !dbg !1096
  %1446 = icmp ne i32 %1445, 0, !dbg !1096
  %is_nan354 = and i1 %1444, %1446, !dbg !1096
  %1447 = and i32 %1441, 4194304, !dbg !1096
  %1448 = icmp eq i32 %1447, 0, !dbg !1096
  %is_snan355 = and i1 %is_nan354, %1448, !dbg !1096
  %1449 = or i1 %is_snan353, %is_snan355, !dbg !1096
  %1450 = bitcast float %1126 to i32, !dbg !1096
  %1451 = and i32 %1450, 2139095040, !dbg !1096
  %1452 = icmp eq i32 %1451, 2139095040, !dbg !1096
  %1453 = and i32 %1450, 8388607, !dbg !1096
  %1454 = icmp eq i32 %1453, 0, !dbg !1096
  %is_inf356 = and i1 %1452, %1454, !dbg !1096
  %1455 = bitcast float %1289 to i32, !dbg !1096
  %1456 = and i32 %1455, 2139095040, !dbg !1096
  %1457 = icmp eq i32 %1456, 2139095040, !dbg !1096
  %1458 = and i32 %1455, 8388607, !dbg !1096
  %1459 = icmp eq i32 %1458, 0, !dbg !1096
  %is_inf357 = and i1 %1457, %1459, !dbg !1096
  %1460 = and i1 %is_inf356, %is_inf357, !dbg !1096
  %1461 = bitcast float %1126 to i32, !dbg !1096
  %1462 = bitcast float %1289 to i32, !dbg !1096
  %1463 = and i32 %1461, -2147483648, !dbg !1096
  %1464 = and i32 %1462, -2147483648, !dbg !1096
  %1465 = icmp eq i32 %1463, %1464, !dbg !1096
  %1466 = and i1 %1460, %1465, !dbg !1096
  %1467 = or i1 %1449, %1466, !dbg !1096
  br i1 %1467, label %1468, label %1470, !dbg !1096

1468:                                             ; preds = %1432
  %1469 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1470, !dbg !1096

1470:                                             ; preds = %1432, %1468
  %1471 = fsub float %1126, %1289, !dbg !1096
  %1472 = bitcast float %1126 to i32, !dbg !1096
  %1473 = and i32 %1472, 2139095040, !dbg !1096
  %is_finite358 = icmp ne i32 %1473, 2139095040, !dbg !1096
  %1474 = and i1 true, %is_finite358, !dbg !1096
  %1475 = bitcast float %1289 to i32, !dbg !1096
  %1476 = and i32 %1475, 2139095040, !dbg !1096
  %is_finite359 = icmp ne i32 %1476, 2139095040, !dbg !1096
  %1477 = and i1 %1474, %is_finite359, !dbg !1096
  %1478 = bitcast float %1471 to i32, !dbg !1096
  %1479 = and i32 %1478, 2139095040, !dbg !1096
  %1480 = icmp eq i32 %1479, 2139095040, !dbg !1096
  %1481 = and i32 %1478, 8388607, !dbg !1096
  %1482 = icmp eq i32 %1481, 0, !dbg !1096
  %is_inf360 = and i1 %1480, %1482, !dbg !1096
  %1483 = bitcast float %1471 to i32, !dbg !1096
  %1484 = and i32 %1483, 2147483647, !dbg !1096
  %is_maxfinite361 = icmp eq i32 %1484, 2139095039, !dbg !1096
  %1485 = bitcast float %1471 to i32, !dbg !1096
  %1486 = and i32 %1485, -2147483648, !dbg !1096
  %1487 = icmp eq i32 %1486, 0, !dbg !1096
  %1488 = icmp ne i32 %1486, 0, !dbg !1096
  %is_pos_inf362 = and i1 %is_inf360, %1487, !dbg !1096
  %is_neg_inf363 = and i1 %is_inf360, %1488, !dbg !1096
  %is_pos_max364 = and i1 %is_maxfinite361, %1487, !dbg !1096
  %is_neg_max365 = and i1 %is_maxfinite361, %1488, !dbg !1096
  %overflow_cond366 = and i1 %1477, %is_inf360, !dbg !1096
  br i1 %overflow_cond366, label %1489, label %1491, !dbg !1096

1489:                                             ; preds = %1470
  %1490 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1491, !dbg !1096

1491:                                             ; preds = %1470, %1489
  %1492 = bitcast float %1471 to i32, !dbg !1096
  %1493 = bitcast float %1471 to i32, !dbg !1096
  %1494 = and i32 %1493, 2139095040, !dbg !1096
  %1495 = icmp eq i32 %1494, 2139095040, !dbg !1096
  %1496 = and i32 %1493, 8388607, !dbg !1096
  %1497 = icmp ne i32 %1496, 0, !dbg !1096
  %is_nan367 = and i1 %1495, %1497, !dbg !1096
  %1498 = and i32 %1492, 4194304, !dbg !1096
  %1499 = icmp eq i32 %1498, 0, !dbg !1096
  %is_snan368 = and i1 %is_nan367, %1499, !dbg !1096
  %1500 = or i1 false, %is_snan368, !dbg !1096
  %1501 = bitcast float %1471 to i32, !dbg !1096
  %1502 = and i32 %1501, 2139095040, !dbg !1096
  %1503 = icmp eq i32 %1502, 2139095040, !dbg !1096
  %1504 = and i32 %1501, 8388607, !dbg !1096
  %1505 = icmp eq i32 %1504, 0, !dbg !1096
  %is_inf369 = and i1 %1503, %1505, !dbg !1096
  %1506 = and i1 false, %is_inf369, !dbg !1096
  %1507 = bitcast float %1471 to i32, !dbg !1096
  %1508 = and i32 %1507, 2147483647, !dbg !1096
  %is_zero370 = icmp eq i32 %1508, 0, !dbg !1096
  %1509 = and i1 false, %is_zero370, !dbg !1096
  %1510 = or i1 %1506, %1509, !dbg !1096
  %1511 = or i1 %1500, %1510, !dbg !1096
  br i1 %1511, label %1512, label %1514, !dbg !1096

1512:                                             ; preds = %1491
  %1513 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1514, !dbg !1096

1514:                                             ; preds = %1491, %1512
  %1515 = fmul float 2.000000e+00, %1471, !dbg !1096
  %1516 = bitcast float %1471 to i32, !dbg !1096
  %1517 = and i32 %1516, 2139095040, !dbg !1096
  %is_finite371 = icmp ne i32 %1517, 2139095040, !dbg !1096
  %1518 = and i1 true, %is_finite371, !dbg !1096
  %1519 = bitcast float %1515 to i32, !dbg !1096
  %1520 = and i32 %1519, 2139095040, !dbg !1096
  %1521 = icmp eq i32 %1520, 2139095040, !dbg !1096
  %1522 = and i32 %1519, 8388607, !dbg !1096
  %1523 = icmp eq i32 %1522, 0, !dbg !1096
  %is_inf372 = and i1 %1521, %1523, !dbg !1096
  %1524 = bitcast float %1515 to i32, !dbg !1096
  %1525 = and i32 %1524, 2147483647, !dbg !1096
  %is_maxfinite373 = icmp eq i32 %1525, 2139095039, !dbg !1096
  %1526 = bitcast float %1515 to i32, !dbg !1096
  %1527 = and i32 %1526, -2147483648, !dbg !1096
  %1528 = icmp eq i32 %1527, 0, !dbg !1096
  %1529 = icmp ne i32 %1527, 0, !dbg !1096
  %is_pos_inf374 = and i1 %is_inf372, %1528, !dbg !1096
  %is_neg_inf375 = and i1 %is_inf372, %1529, !dbg !1096
  %is_pos_max376 = and i1 %is_maxfinite373, %1528, !dbg !1096
  %is_neg_max377 = and i1 %is_maxfinite373, %1529, !dbg !1096
  %overflow_cond378 = and i1 %1518, %is_inf372, !dbg !1096
  br i1 %overflow_cond378, label %1530, label %1532, !dbg !1096

1530:                                             ; preds = %1514
  %1531 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1532, !dbg !1096

1532:                                             ; preds = %1514, %1530
  %1533 = bitcast float %1471 to i32, !dbg !1096
  %1534 = and i32 %1533, 2139095040, !dbg !1096
  %1535 = icmp eq i32 %1534, 0, !dbg !1096
  %1536 = and i32 %1533, 8388607, !dbg !1096
  %1537 = icmp ne i32 %1536, 0, !dbg !1096
  %is_subnormal379 = and i1 %1535, %1537, !dbg !1096
  %1538 = xor i1 %is_subnormal379, true, !dbg !1096
  %1539 = and i1 true, %1538, !dbg !1096
  %1540 = bitcast float %1515 to i32, !dbg !1096
  %1541 = and i32 %1540, 2139095040, !dbg !1096
  %1542 = icmp eq i32 %1541, 0, !dbg !1096
  %1543 = and i32 %1540, 8388607, !dbg !1096
  %1544 = icmp ne i32 %1543, 0, !dbg !1096
  %is_subnormal380 = and i1 %1542, %1544, !dbg !1096
  %1545 = bitcast float %1515 to i32, !dbg !1096
  %1546 = and i32 %1545, 2147483647, !dbg !1096
  %is_zero381 = icmp eq i32 %1546, 0, !dbg !1096
  %1547 = bitcast float %1471 to i32, !dbg !1096
  %1548 = and i32 %1547, 2147483647, !dbg !1096
  %is_zero382 = icmp eq i32 %1548, 0, !dbg !1096
  %1549 = xor i1 %is_zero382, true, !dbg !1096
  %1550 = and i1 true, %1549, !dbg !1096
  %1551 = and i1 %is_zero381, %1550, !dbg !1096
  %is_tiny383 = or i1 %is_subnormal380, %1551, !dbg !1096
  %underflow_cond384 = and i1 %1539, %is_tiny383, !dbg !1096
  br i1 %underflow_cond384, label %1552, label %1554, !dbg !1096

1552:                                             ; preds = %1532
  %1553 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1554, !dbg !1096

1554:                                             ; preds = %1532, %1552
  %1555 = bitcast float %1289 to i32, !dbg !1096
  %1556 = bitcast float %1289 to i32, !dbg !1096
  %1557 = and i32 %1556, 2139095040, !dbg !1096
  %1558 = icmp eq i32 %1557, 2139095040, !dbg !1096
  %1559 = and i32 %1556, 8388607, !dbg !1096
  %1560 = icmp ne i32 %1559, 0, !dbg !1096
  %is_nan385 = and i1 %1558, %1560, !dbg !1096
  %1561 = and i32 %1555, 4194304, !dbg !1096
  %1562 = icmp eq i32 %1561, 0, !dbg !1096
  %is_snan386 = and i1 %is_nan385, %1562, !dbg !1096
  %1563 = or i1 false, %is_snan386, !dbg !1096
  %1564 = bitcast float %1289 to i32, !dbg !1096
  %1565 = and i32 %1564, 2139095040, !dbg !1096
  %1566 = icmp eq i32 %1565, 2139095040, !dbg !1096
  %1567 = and i32 %1564, 8388607, !dbg !1096
  %1568 = icmp eq i32 %1567, 0, !dbg !1096
  %is_inf387 = and i1 %1566, %1568, !dbg !1096
  %1569 = and i1 false, %is_inf387, !dbg !1096
  %1570 = bitcast float %1289 to i32, !dbg !1096
  %1571 = and i32 %1570, -2147483648, !dbg !1096
  %1572 = icmp eq i32 -2147483648, %1571, !dbg !1096
  %1573 = and i1 %1569, %1572, !dbg !1096
  %1574 = or i1 %1563, %1573, !dbg !1096
  br i1 %1574, label %1575, label %1577, !dbg !1096

1575:                                             ; preds = %1554
  %1576 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1577, !dbg !1096

1577:                                             ; preds = %1554, %1575
  %1578 = fsub float -0.000000e+00, %1289, !dbg !1096
  %1579 = bitcast float %1289 to i32, !dbg !1096
  %1580 = and i32 %1579, 2139095040, !dbg !1096
  %is_finite388 = icmp ne i32 %1580, 2139095040, !dbg !1096
  %1581 = and i1 true, %is_finite388, !dbg !1096
  %1582 = bitcast float %1578 to i32, !dbg !1096
  %1583 = and i32 %1582, 2139095040, !dbg !1096
  %1584 = icmp eq i32 %1583, 2139095040, !dbg !1096
  %1585 = and i32 %1582, 8388607, !dbg !1096
  %1586 = icmp eq i32 %1585, 0, !dbg !1096
  %is_inf389 = and i1 %1584, %1586, !dbg !1096
  %1587 = bitcast float %1578 to i32, !dbg !1096
  %1588 = and i32 %1587, 2147483647, !dbg !1096
  %is_maxfinite390 = icmp eq i32 %1588, 2139095039, !dbg !1096
  %1589 = bitcast float %1578 to i32, !dbg !1096
  %1590 = and i32 %1589, -2147483648, !dbg !1096
  %1591 = icmp eq i32 %1590, 0, !dbg !1096
  %1592 = icmp ne i32 %1590, 0, !dbg !1096
  %is_pos_inf391 = and i1 %is_inf389, %1591, !dbg !1096
  %is_neg_inf392 = and i1 %is_inf389, %1592, !dbg !1096
  %is_pos_max393 = and i1 %is_maxfinite390, %1591, !dbg !1096
  %is_neg_max394 = and i1 %is_maxfinite390, %1592, !dbg !1096
  %overflow_cond395 = and i1 %1581, %is_inf389, !dbg !1096
  br i1 %overflow_cond395, label %1593, label %1595, !dbg !1096

1593:                                             ; preds = %1577
  %1594 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1595, !dbg !1096

1595:                                             ; preds = %1577, %1593
  %1596 = bitcast float %1578 to i32, !dbg !1096
  %1597 = bitcast float %1578 to i32, !dbg !1096
  %1598 = and i32 %1597, 2139095040, !dbg !1096
  %1599 = icmp eq i32 %1598, 2139095040, !dbg !1096
  %1600 = and i32 %1597, 8388607, !dbg !1096
  %1601 = icmp ne i32 %1600, 0, !dbg !1096
  %is_nan396 = and i1 %1599, %1601, !dbg !1096
  %1602 = and i32 %1596, 4194304, !dbg !1096
  %1603 = icmp eq i32 %1602, 0, !dbg !1096
  %is_snan397 = and i1 %is_nan396, %1603, !dbg !1096
  %1604 = bitcast float %1126 to i32, !dbg !1096
  %1605 = bitcast float %1126 to i32, !dbg !1096
  %1606 = and i32 %1605, 2139095040, !dbg !1096
  %1607 = icmp eq i32 %1606, 2139095040, !dbg !1096
  %1608 = and i32 %1605, 8388607, !dbg !1096
  %1609 = icmp ne i32 %1608, 0, !dbg !1096
  %is_nan398 = and i1 %1607, %1609, !dbg !1096
  %1610 = and i32 %1604, 4194304, !dbg !1096
  %1611 = icmp eq i32 %1610, 0, !dbg !1096
  %is_snan399 = and i1 %is_nan398, %1611, !dbg !1096
  %1612 = or i1 %is_snan397, %is_snan399, !dbg !1096
  %1613 = bitcast float %1515 to i32, !dbg !1096
  %1614 = bitcast float %1515 to i32, !dbg !1096
  %1615 = and i32 %1614, 2139095040, !dbg !1096
  %1616 = icmp eq i32 %1615, 2139095040, !dbg !1096
  %1617 = and i32 %1614, 8388607, !dbg !1096
  %1618 = icmp ne i32 %1617, 0, !dbg !1096
  %is_nan400 = and i1 %1616, %1618, !dbg !1096
  %1619 = and i32 %1613, 4194304, !dbg !1096
  %1620 = icmp eq i32 %1619, 0, !dbg !1096
  %is_snan401 = and i1 %is_nan400, %1620, !dbg !1096
  %1621 = or i1 %1612, %is_snan401, !dbg !1096
  %1622 = bitcast float %1578 to i32, !dbg !1096
  %1623 = and i32 %1622, 2147483647, !dbg !1096
  %is_zero402 = icmp eq i32 %1623, 0, !dbg !1096
  %1624 = bitcast float %1126 to i32, !dbg !1096
  %1625 = and i32 %1624, 2139095040, !dbg !1096
  %1626 = icmp eq i32 %1625, 2139095040, !dbg !1096
  %1627 = and i32 %1624, 8388607, !dbg !1096
  %1628 = icmp eq i32 %1627, 0, !dbg !1096
  %is_inf403 = and i1 %1626, %1628, !dbg !1096
  %1629 = and i1 %is_zero402, %is_inf403, !dbg !1096
  %1630 = bitcast float %1578 to i32, !dbg !1096
  %1631 = and i32 %1630, 2139095040, !dbg !1096
  %1632 = icmp eq i32 %1631, 2139095040, !dbg !1096
  %1633 = and i32 %1630, 8388607, !dbg !1096
  %1634 = icmp eq i32 %1633, 0, !dbg !1096
  %is_inf404 = and i1 %1632, %1634, !dbg !1096
  %1635 = bitcast float %1126 to i32, !dbg !1096
  %1636 = and i32 %1635, 2147483647, !dbg !1096
  %is_zero405 = icmp eq i32 %1636, 0, !dbg !1096
  %1637 = and i1 %is_inf404, %is_zero405, !dbg !1096
  %1638 = or i1 %1629, %1637, !dbg !1096
  %1639 = or i1 %1621, %1638, !dbg !1096
  br i1 %1639, label %1640, label %1642, !dbg !1096

1640:                                             ; preds = %1595
  %1641 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1642, !dbg !1096

1642:                                             ; preds = %1595, %1640
  %1643 = call float @llvm.nvvm.fma.rn.f(float %1578, float %1126, float %1515) #5, !dbg !1096
  %1644 = bitcast float %1578 to i32, !dbg !1096
  %1645 = and i32 %1644, 2139095040, !dbg !1096
  %is_finite406 = icmp ne i32 %1645, 2139095040, !dbg !1096
  %1646 = and i1 true, %is_finite406, !dbg !1096
  %1647 = bitcast float %1126 to i32, !dbg !1096
  %1648 = and i32 %1647, 2139095040, !dbg !1096
  %is_finite407 = icmp ne i32 %1648, 2139095040, !dbg !1096
  %1649 = and i1 %1646, %is_finite407, !dbg !1096
  %1650 = bitcast float %1643 to i32, !dbg !1096
  %1651 = and i32 %1650, 2139095040, !dbg !1096
  %1652 = icmp eq i32 %1651, 2139095040, !dbg !1096
  %1653 = and i32 %1650, 8388607, !dbg !1096
  %1654 = icmp eq i32 %1653, 0, !dbg !1096
  %is_inf408 = and i1 %1652, %1654, !dbg !1096
  %1655 = bitcast float %1643 to i32, !dbg !1096
  %1656 = and i32 %1655, 2147483647, !dbg !1096
  %is_maxfinite409 = icmp eq i32 %1656, 2139095039, !dbg !1096
  %1657 = bitcast float %1643 to i32, !dbg !1096
  %1658 = and i32 %1657, -2147483648, !dbg !1096
  %1659 = icmp eq i32 %1658, 0, !dbg !1096
  %1660 = icmp ne i32 %1658, 0, !dbg !1096
  %is_pos_inf410 = and i1 %is_inf408, %1659, !dbg !1096
  %is_neg_inf411 = and i1 %is_inf408, %1660, !dbg !1096
  %is_pos_max412 = and i1 %is_maxfinite409, %1659, !dbg !1096
  %is_neg_max413 = and i1 %is_maxfinite409, %1660, !dbg !1096
  %overflow_cond414 = and i1 %1649, %is_inf408, !dbg !1096
  br i1 %overflow_cond414, label %1661, label %1663, !dbg !1096

1661:                                             ; preds = %1642
  %1662 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1663, !dbg !1096

1663:                                             ; preds = %1642, %1661
  %1664 = bitcast float %1578 to i32, !dbg !1096
  %1665 = and i32 %1664, 2139095040, !dbg !1096
  %1666 = icmp eq i32 %1665, 0, !dbg !1096
  %1667 = and i32 %1664, 8388607, !dbg !1096
  %1668 = icmp ne i32 %1667, 0, !dbg !1096
  %is_subnormal415 = and i1 %1666, %1668, !dbg !1096
  %1669 = xor i1 %is_subnormal415, true, !dbg !1096
  %1670 = and i1 true, %1669, !dbg !1096
  %1671 = bitcast float %1126 to i32, !dbg !1096
  %1672 = and i32 %1671, 2139095040, !dbg !1096
  %1673 = icmp eq i32 %1672, 0, !dbg !1096
  %1674 = and i32 %1671, 8388607, !dbg !1096
  %1675 = icmp ne i32 %1674, 0, !dbg !1096
  %is_subnormal416 = and i1 %1673, %1675, !dbg !1096
  %1676 = xor i1 %is_subnormal416, true, !dbg !1096
  %1677 = and i1 %1670, %1676, !dbg !1096
  %1678 = bitcast float %1515 to i32, !dbg !1096
  %1679 = and i32 %1678, 2139095040, !dbg !1096
  %1680 = icmp eq i32 %1679, 0, !dbg !1096
  %1681 = and i32 %1678, 8388607, !dbg !1096
  %1682 = icmp ne i32 %1681, 0, !dbg !1096
  %is_subnormal417 = and i1 %1680, %1682, !dbg !1096
  %1683 = xor i1 %is_subnormal417, true, !dbg !1096
  %1684 = and i1 %1677, %1683, !dbg !1096
  %1685 = bitcast float %1643 to i32, !dbg !1096
  %1686 = and i32 %1685, 2139095040, !dbg !1096
  %1687 = icmp eq i32 %1686, 0, !dbg !1096
  %1688 = and i32 %1685, 8388607, !dbg !1096
  %1689 = icmp ne i32 %1688, 0, !dbg !1096
  %is_subnormal418 = and i1 %1687, %1689, !dbg !1096
  %is_tiny419 = or i1 %is_subnormal418, false, !dbg !1096
  %underflow_cond420 = and i1 %1684, %is_tiny419, !dbg !1096
  br i1 %underflow_cond420, label %1690, label %1692, !dbg !1096

1690:                                             ; preds = %1663
  %1691 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1692, !dbg !1096

1692:                                             ; preds = %1663, %1690
  %1693 = call float @llvm.nvvm.mul.rn.f(float %1187, float %1643) #5, !dbg !1096
  %1694 = bitcast float %1380 to i32, !dbg !1096
  %1695 = bitcast float %1380 to i32, !dbg !1096
  %1696 = and i32 %1695, 2139095040, !dbg !1096
  %1697 = icmp eq i32 %1696, 2139095040, !dbg !1096
  %1698 = and i32 %1695, 8388607, !dbg !1096
  %1699 = icmp ne i32 %1698, 0, !dbg !1096
  %is_nan421 = and i1 %1697, %1699, !dbg !1096
  %1700 = and i32 %1694, 4194304, !dbg !1096
  %1701 = icmp eq i32 %1700, 0, !dbg !1096
  %is_snan422 = and i1 %is_nan421, %1701, !dbg !1096
  %1702 = or i1 false, %is_snan422, !dbg !1096
  %1703 = or i1 %1702, false, !dbg !1096
  %1704 = bitcast float %1380 to i32, !dbg !1096
  %1705 = and i32 %1704, 2139095040, !dbg !1096
  %1706 = icmp eq i32 %1705, 2139095040, !dbg !1096
  %1707 = and i32 %1704, 8388607, !dbg !1096
  %1708 = icmp eq i32 %1707, 0, !dbg !1096
  %is_inf423 = and i1 %1706, %1708, !dbg !1096
  %1709 = and i1 false, %is_inf423, !dbg !1096
  %1710 = bitcast float %1380 to i32, !dbg !1096
  %1711 = and i32 %1710, 2147483647, !dbg !1096
  %is_zero424 = icmp eq i32 %1711, 0, !dbg !1096
  %1712 = and i1 false, %is_zero424, !dbg !1096
  %1713 = or i1 %1709, %1712, !dbg !1096
  %1714 = or i1 %1703, %1713, !dbg !1096
  br i1 %1714, label %1715, label %1717, !dbg !1096

1715:                                             ; preds = %1692
  %1716 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1717, !dbg !1096

1717:                                             ; preds = %1692, %1715
  %1718 = call float @llvm.nvvm.fma.rn.f(float 0x3F45865C80000000, float %1380, float 0x3F6A5CFB60000000) #5, !dbg !1096
  %1719 = bitcast float %1380 to i32, !dbg !1096
  %1720 = and i32 %1719, 2139095040, !dbg !1096
  %is_finite425 = icmp ne i32 %1720, 2139095040, !dbg !1096
  %1721 = and i1 true, %is_finite425, !dbg !1096
  %1722 = bitcast float %1718 to i32, !dbg !1096
  %1723 = and i32 %1722, 2139095040, !dbg !1096
  %1724 = icmp eq i32 %1723, 2139095040, !dbg !1096
  %1725 = and i32 %1722, 8388607, !dbg !1096
  %1726 = icmp eq i32 %1725, 0, !dbg !1096
  %is_inf426 = and i1 %1724, %1726, !dbg !1096
  %1727 = bitcast float %1718 to i32, !dbg !1096
  %1728 = and i32 %1727, 2147483647, !dbg !1096
  %is_maxfinite427 = icmp eq i32 %1728, 2139095039, !dbg !1096
  %1729 = bitcast float %1718 to i32, !dbg !1096
  %1730 = and i32 %1729, -2147483648, !dbg !1096
  %1731 = icmp eq i32 %1730, 0, !dbg !1096
  %1732 = icmp ne i32 %1730, 0, !dbg !1096
  %is_pos_inf428 = and i1 %is_inf426, %1731, !dbg !1096
  %is_neg_inf429 = and i1 %is_inf426, %1732, !dbg !1096
  %is_pos_max430 = and i1 %is_maxfinite427, %1731, !dbg !1096
  %is_neg_max431 = and i1 %is_maxfinite427, %1732, !dbg !1096
  %overflow_cond432 = and i1 %1721, %is_inf426, !dbg !1096
  br i1 %overflow_cond432, label %1733, label %1735, !dbg !1096

1733:                                             ; preds = %1717
  %1734 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1735, !dbg !1096

1735:                                             ; preds = %1717, %1733
  %1736 = bitcast float %1380 to i32, !dbg !1096
  %1737 = and i32 %1736, 2139095040, !dbg !1096
  %1738 = icmp eq i32 %1737, 0, !dbg !1096
  %1739 = and i32 %1736, 8388607, !dbg !1096
  %1740 = icmp ne i32 %1739, 0, !dbg !1096
  %is_subnormal433 = and i1 %1738, %1740, !dbg !1096
  %1741 = xor i1 %is_subnormal433, true, !dbg !1096
  %1742 = and i1 true, %1741, !dbg !1096
  %1743 = and i1 %1742, true, !dbg !1096
  %1744 = bitcast float %1718 to i32, !dbg !1096
  %1745 = and i32 %1744, 2139095040, !dbg !1096
  %1746 = icmp eq i32 %1745, 0, !dbg !1096
  %1747 = and i32 %1744, 8388607, !dbg !1096
  %1748 = icmp ne i32 %1747, 0, !dbg !1096
  %is_subnormal434 = and i1 %1746, %1748, !dbg !1096
  %is_tiny435 = or i1 %is_subnormal434, false, !dbg !1096
  %underflow_cond436 = and i1 %1743, %is_tiny435, !dbg !1096
  br i1 %underflow_cond436, label %1749, label %1751, !dbg !1096

1749:                                             ; preds = %1735
  %1750 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1751, !dbg !1096

1751:                                             ; preds = %1735, %1749
  %1752 = bitcast float %1718 to i32, !dbg !1096
  %1753 = bitcast float %1718 to i32, !dbg !1096
  %1754 = and i32 %1753, 2139095040, !dbg !1096
  %1755 = icmp eq i32 %1754, 2139095040, !dbg !1096
  %1756 = and i32 %1753, 8388607, !dbg !1096
  %1757 = icmp ne i32 %1756, 0, !dbg !1096
  %is_nan437 = and i1 %1755, %1757, !dbg !1096
  %1758 = and i32 %1752, 4194304, !dbg !1096
  %1759 = icmp eq i32 %1758, 0, !dbg !1096
  %is_snan438 = and i1 %is_nan437, %1759, !dbg !1096
  %1760 = bitcast float %1380 to i32, !dbg !1096
  %1761 = bitcast float %1380 to i32, !dbg !1096
  %1762 = and i32 %1761, 2139095040, !dbg !1096
  %1763 = icmp eq i32 %1762, 2139095040, !dbg !1096
  %1764 = and i32 %1761, 8388607, !dbg !1096
  %1765 = icmp ne i32 %1764, 0, !dbg !1096
  %is_nan439 = and i1 %1763, %1765, !dbg !1096
  %1766 = and i32 %1760, 4194304, !dbg !1096
  %1767 = icmp eq i32 %1766, 0, !dbg !1096
  %is_snan440 = and i1 %is_nan439, %1767, !dbg !1096
  %1768 = or i1 %is_snan438, %is_snan440, !dbg !1096
  %1769 = or i1 %1768, false, !dbg !1096
  %1770 = bitcast float %1718 to i32, !dbg !1096
  %1771 = and i32 %1770, 2147483647, !dbg !1096
  %is_zero441 = icmp eq i32 %1771, 0, !dbg !1096
  %1772 = bitcast float %1380 to i32, !dbg !1096
  %1773 = and i32 %1772, 2139095040, !dbg !1096
  %1774 = icmp eq i32 %1773, 2139095040, !dbg !1096
  %1775 = and i32 %1772, 8388607, !dbg !1096
  %1776 = icmp eq i32 %1775, 0, !dbg !1096
  %is_inf442 = and i1 %1774, %1776, !dbg !1096
  %1777 = and i1 %is_zero441, %is_inf442, !dbg !1096
  %1778 = bitcast float %1718 to i32, !dbg !1096
  %1779 = and i32 %1778, 2139095040, !dbg !1096
  %1780 = icmp eq i32 %1779, 2139095040, !dbg !1096
  %1781 = and i32 %1778, 8388607, !dbg !1096
  %1782 = icmp eq i32 %1781, 0, !dbg !1096
  %is_inf443 = and i1 %1780, %1782, !dbg !1096
  %1783 = bitcast float %1380 to i32, !dbg !1096
  %1784 = and i32 %1783, 2147483647, !dbg !1096
  %is_zero444 = icmp eq i32 %1784, 0, !dbg !1096
  %1785 = and i1 %is_inf443, %is_zero444, !dbg !1096
  %1786 = or i1 %1777, %1785, !dbg !1096
  %1787 = or i1 %1769, %1786, !dbg !1096
  br i1 %1787, label %1788, label %1790, !dbg !1096

1788:                                             ; preds = %1751
  %1789 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1790, !dbg !1096

1790:                                             ; preds = %1751, %1788
  %1791 = call float @llvm.nvvm.fma.rn.f(float %1718, float %1380, float 0x3F92776E60000000) #5, !dbg !1096
  %1792 = bitcast float %1718 to i32, !dbg !1096
  %1793 = and i32 %1792, 2139095040, !dbg !1096
  %is_finite445 = icmp ne i32 %1793, 2139095040, !dbg !1096
  %1794 = and i1 true, %is_finite445, !dbg !1096
  %1795 = bitcast float %1380 to i32, !dbg !1096
  %1796 = and i32 %1795, 2139095040, !dbg !1096
  %is_finite446 = icmp ne i32 %1796, 2139095040, !dbg !1096
  %1797 = and i1 %1794, %is_finite446, !dbg !1096
  %1798 = bitcast float %1791 to i32, !dbg !1096
  %1799 = and i32 %1798, 2139095040, !dbg !1096
  %1800 = icmp eq i32 %1799, 2139095040, !dbg !1096
  %1801 = and i32 %1798, 8388607, !dbg !1096
  %1802 = icmp eq i32 %1801, 0, !dbg !1096
  %is_inf447 = and i1 %1800, %1802, !dbg !1096
  %1803 = bitcast float %1791 to i32, !dbg !1096
  %1804 = and i32 %1803, 2147483647, !dbg !1096
  %is_maxfinite448 = icmp eq i32 %1804, 2139095039, !dbg !1096
  %1805 = bitcast float %1791 to i32, !dbg !1096
  %1806 = and i32 %1805, -2147483648, !dbg !1096
  %1807 = icmp eq i32 %1806, 0, !dbg !1096
  %1808 = icmp ne i32 %1806, 0, !dbg !1096
  %is_pos_inf449 = and i1 %is_inf447, %1807, !dbg !1096
  %is_neg_inf450 = and i1 %is_inf447, %1808, !dbg !1096
  %is_pos_max451 = and i1 %is_maxfinite448, %1807, !dbg !1096
  %is_neg_max452 = and i1 %is_maxfinite448, %1808, !dbg !1096
  %overflow_cond453 = and i1 %1797, %is_inf447, !dbg !1096
  br i1 %overflow_cond453, label %1809, label %1811, !dbg !1096

1809:                                             ; preds = %1790
  %1810 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1811, !dbg !1096

1811:                                             ; preds = %1790, %1809
  %1812 = bitcast float %1718 to i32, !dbg !1096
  %1813 = and i32 %1812, 2139095040, !dbg !1096
  %1814 = icmp eq i32 %1813, 0, !dbg !1096
  %1815 = and i32 %1812, 8388607, !dbg !1096
  %1816 = icmp ne i32 %1815, 0, !dbg !1096
  %is_subnormal454 = and i1 %1814, %1816, !dbg !1096
  %1817 = xor i1 %is_subnormal454, true, !dbg !1096
  %1818 = and i1 true, %1817, !dbg !1096
  %1819 = bitcast float %1380 to i32, !dbg !1096
  %1820 = and i32 %1819, 2139095040, !dbg !1096
  %1821 = icmp eq i32 %1820, 0, !dbg !1096
  %1822 = and i32 %1819, 8388607, !dbg !1096
  %1823 = icmp ne i32 %1822, 0, !dbg !1096
  %is_subnormal455 = and i1 %1821, %1823, !dbg !1096
  %1824 = xor i1 %is_subnormal455, true, !dbg !1096
  %1825 = and i1 %1818, %1824, !dbg !1096
  %1826 = and i1 %1825, true, !dbg !1096
  %1827 = bitcast float %1791 to i32, !dbg !1096
  %1828 = and i32 %1827, 2139095040, !dbg !1096
  %1829 = icmp eq i32 %1828, 0, !dbg !1096
  %1830 = and i32 %1827, 8388607, !dbg !1096
  %1831 = icmp ne i32 %1830, 0, !dbg !1096
  %is_subnormal456 = and i1 %1829, %1831, !dbg !1096
  %is_tiny457 = or i1 %is_subnormal456, false, !dbg !1096
  %underflow_cond458 = and i1 %1826, %is_tiny457, !dbg !1096
  br i1 %underflow_cond458, label %1832, label %1834, !dbg !1096

1832:                                             ; preds = %1811
  %1833 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1834, !dbg !1096

1834:                                             ; preds = %1811, %1832
  %1835 = bitcast float %1791 to i32, !dbg !1096
  %1836 = bitcast float %1791 to i32, !dbg !1096
  %1837 = and i32 %1836, 2139095040, !dbg !1096
  %1838 = icmp eq i32 %1837, 2139095040, !dbg !1096
  %1839 = and i32 %1836, 8388607, !dbg !1096
  %1840 = icmp ne i32 %1839, 0, !dbg !1096
  %is_nan459 = and i1 %1838, %1840, !dbg !1096
  %1841 = and i32 %1835, 4194304, !dbg !1096
  %1842 = icmp eq i32 %1841, 0, !dbg !1096
  %is_snan460 = and i1 %is_nan459, %1842, !dbg !1096
  %1843 = bitcast float %1380 to i32, !dbg !1096
  %1844 = bitcast float %1380 to i32, !dbg !1096
  %1845 = and i32 %1844, 2139095040, !dbg !1096
  %1846 = icmp eq i32 %1845, 2139095040, !dbg !1096
  %1847 = and i32 %1844, 8388607, !dbg !1096
  %1848 = icmp ne i32 %1847, 0, !dbg !1096
  %is_nan461 = and i1 %1846, %1848, !dbg !1096
  %1849 = and i32 %1843, 4194304, !dbg !1096
  %1850 = icmp eq i32 %1849, 0, !dbg !1096
  %is_snan462 = and i1 %is_nan461, %1850, !dbg !1096
  %1851 = or i1 %is_snan460, %is_snan462, !dbg !1096
  %1852 = or i1 %1851, false, !dbg !1096
  %1853 = bitcast float %1791 to i32, !dbg !1096
  %1854 = and i32 %1853, 2147483647, !dbg !1096
  %is_zero463 = icmp eq i32 %1854, 0, !dbg !1096
  %1855 = bitcast float %1380 to i32, !dbg !1096
  %1856 = and i32 %1855, 2139095040, !dbg !1096
  %1857 = icmp eq i32 %1856, 2139095040, !dbg !1096
  %1858 = and i32 %1855, 8388607, !dbg !1096
  %1859 = icmp eq i32 %1858, 0, !dbg !1096
  %is_inf464 = and i1 %1857, %1859, !dbg !1096
  %1860 = and i1 %is_zero463, %is_inf464, !dbg !1096
  %1861 = bitcast float %1791 to i32, !dbg !1096
  %1862 = and i32 %1861, 2139095040, !dbg !1096
  %1863 = icmp eq i32 %1862, 2139095040, !dbg !1096
  %1864 = and i32 %1861, 8388607, !dbg !1096
  %1865 = icmp eq i32 %1864, 0, !dbg !1096
  %is_inf465 = and i1 %1863, %1865, !dbg !1096
  %1866 = bitcast float %1380 to i32, !dbg !1096
  %1867 = and i32 %1866, 2147483647, !dbg !1096
  %is_zero466 = icmp eq i32 %1867, 0, !dbg !1096
  %1868 = and i1 %is_inf465, %is_zero466, !dbg !1096
  %1869 = or i1 %1860, %1868, !dbg !1096
  %1870 = or i1 %1852, %1869, !dbg !1096
  br i1 %1870, label %1871, label %1873, !dbg !1096

1871:                                             ; preds = %1834
  %1872 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1873, !dbg !1096

1873:                                             ; preds = %1834, %1871
  %1874 = call float @llvm.nvvm.fma.rn.f(float %1791, float %1380, float 0x3FBEC709E0000000) #5, !dbg !1096
  %1875 = bitcast float %1791 to i32, !dbg !1096
  %1876 = and i32 %1875, 2139095040, !dbg !1096
  %is_finite467 = icmp ne i32 %1876, 2139095040, !dbg !1096
  %1877 = and i1 true, %is_finite467, !dbg !1096
  %1878 = bitcast float %1380 to i32, !dbg !1096
  %1879 = and i32 %1878, 2139095040, !dbg !1096
  %is_finite468 = icmp ne i32 %1879, 2139095040, !dbg !1096
  %1880 = and i1 %1877, %is_finite468, !dbg !1096
  %1881 = bitcast float %1874 to i32, !dbg !1096
  %1882 = and i32 %1881, 2139095040, !dbg !1096
  %1883 = icmp eq i32 %1882, 2139095040, !dbg !1096
  %1884 = and i32 %1881, 8388607, !dbg !1096
  %1885 = icmp eq i32 %1884, 0, !dbg !1096
  %is_inf469 = and i1 %1883, %1885, !dbg !1096
  %1886 = bitcast float %1874 to i32, !dbg !1096
  %1887 = and i32 %1886, 2147483647, !dbg !1096
  %is_maxfinite470 = icmp eq i32 %1887, 2139095039, !dbg !1096
  %1888 = bitcast float %1874 to i32, !dbg !1096
  %1889 = and i32 %1888, -2147483648, !dbg !1096
  %1890 = icmp eq i32 %1889, 0, !dbg !1096
  %1891 = icmp ne i32 %1889, 0, !dbg !1096
  %is_pos_inf471 = and i1 %is_inf469, %1890, !dbg !1096
  %is_neg_inf472 = and i1 %is_inf469, %1891, !dbg !1096
  %is_pos_max473 = and i1 %is_maxfinite470, %1890, !dbg !1096
  %is_neg_max474 = and i1 %is_maxfinite470, %1891, !dbg !1096
  %overflow_cond475 = and i1 %1880, %is_inf469, !dbg !1096
  br i1 %overflow_cond475, label %1892, label %1894, !dbg !1096

1892:                                             ; preds = %1873
  %1893 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1894, !dbg !1096

1894:                                             ; preds = %1873, %1892
  %1895 = bitcast float %1791 to i32, !dbg !1096
  %1896 = and i32 %1895, 2139095040, !dbg !1096
  %1897 = icmp eq i32 %1896, 0, !dbg !1096
  %1898 = and i32 %1895, 8388607, !dbg !1096
  %1899 = icmp ne i32 %1898, 0, !dbg !1096
  %is_subnormal476 = and i1 %1897, %1899, !dbg !1096
  %1900 = xor i1 %is_subnormal476, true, !dbg !1096
  %1901 = and i1 true, %1900, !dbg !1096
  %1902 = bitcast float %1380 to i32, !dbg !1096
  %1903 = and i32 %1902, 2139095040, !dbg !1096
  %1904 = icmp eq i32 %1903, 0, !dbg !1096
  %1905 = and i32 %1902, 8388607, !dbg !1096
  %1906 = icmp ne i32 %1905, 0, !dbg !1096
  %is_subnormal477 = and i1 %1904, %1906, !dbg !1096
  %1907 = xor i1 %is_subnormal477, true, !dbg !1096
  %1908 = and i1 %1901, %1907, !dbg !1096
  %1909 = and i1 %1908, true, !dbg !1096
  %1910 = bitcast float %1874 to i32, !dbg !1096
  %1911 = and i32 %1910, 2139095040, !dbg !1096
  %1912 = icmp eq i32 %1911, 0, !dbg !1096
  %1913 = and i32 %1910, 8388607, !dbg !1096
  %1914 = icmp ne i32 %1913, 0, !dbg !1096
  %is_subnormal478 = and i1 %1912, %1914, !dbg !1096
  %is_tiny479 = or i1 %is_subnormal478, false, !dbg !1096
  %underflow_cond480 = and i1 %1909, %is_tiny479, !dbg !1096
  br i1 %underflow_cond480, label %1915, label %1917, !dbg !1096

1915:                                             ; preds = %1894
  %1916 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1917, !dbg !1096

1917:                                             ; preds = %1894, %1915
  %1918 = call float @llvm.nvvm.mul.rn.f(float %1874, float %1380) #5, !dbg !1096
  %1919 = bitcast float %1289 to i32, !dbg !1096
  %1920 = bitcast float %1289 to i32, !dbg !1096
  %1921 = and i32 %1920, 2139095040, !dbg !1096
  %1922 = icmp eq i32 %1921, 2139095040, !dbg !1096
  %1923 = and i32 %1920, 8388607, !dbg !1096
  %1924 = icmp ne i32 %1923, 0, !dbg !1096
  %is_nan481 = and i1 %1922, %1924, !dbg !1096
  %1925 = and i32 %1919, 4194304, !dbg !1096
  %1926 = icmp eq i32 %1925, 0, !dbg !1096
  %is_snan482 = and i1 %is_nan481, %1926, !dbg !1096
  %1927 = or i1 %is_snan482, false, !dbg !1096
  %1928 = bitcast float %1061 to i32, !dbg !1096
  %1929 = bitcast float %1061 to i32, !dbg !1096
  %1930 = and i32 %1929, 2139095040, !dbg !1096
  %1931 = icmp eq i32 %1930, 2139095040, !dbg !1096
  %1932 = and i32 %1929, 8388607, !dbg !1096
  %1933 = icmp ne i32 %1932, 0, !dbg !1096
  %is_nan483 = and i1 %1931, %1933, !dbg !1096
  %1934 = and i32 %1928, 4194304, !dbg !1096
  %1935 = icmp eq i32 %1934, 0, !dbg !1096
  %is_snan484 = and i1 %is_nan483, %1935, !dbg !1096
  %1936 = or i1 %1927, %is_snan484, !dbg !1096
  %1937 = bitcast float %1289 to i32, !dbg !1096
  %1938 = and i32 %1937, 2147483647, !dbg !1096
  %is_zero485 = icmp eq i32 %1938, 0, !dbg !1096
  %1939 = and i1 %is_zero485, false, !dbg !1096
  %1940 = bitcast float %1289 to i32, !dbg !1096
  %1941 = and i32 %1940, 2139095040, !dbg !1096
  %1942 = icmp eq i32 %1941, 2139095040, !dbg !1096
  %1943 = and i32 %1940, 8388607, !dbg !1096
  %1944 = icmp eq i32 %1943, 0, !dbg !1096
  %is_inf486 = and i1 %1942, %1944, !dbg !1096
  %1945 = and i1 %is_inf486, false, !dbg !1096
  %1946 = or i1 %1939, %1945, !dbg !1096
  %1947 = or i1 %1936, %1946, !dbg !1096
  br i1 %1947, label %1948, label %1950, !dbg !1096

1948:                                             ; preds = %1917
  %1949 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1950, !dbg !1096

1950:                                             ; preds = %1917, %1948
  %1951 = call float @llvm.nvvm.fma.rn.f(float %1289, float 0x3FF7154760000000, float %1061) #5, !dbg !1096
  %1952 = bitcast float %1289 to i32, !dbg !1096
  %1953 = and i32 %1952, 2139095040, !dbg !1096
  %is_finite487 = icmp ne i32 %1953, 2139095040, !dbg !1096
  %1954 = and i1 true, %is_finite487, !dbg !1096
  %1955 = and i1 %1954, true, !dbg !1096
  %1956 = bitcast float %1951 to i32, !dbg !1096
  %1957 = and i32 %1956, 2139095040, !dbg !1096
  %1958 = icmp eq i32 %1957, 2139095040, !dbg !1096
  %1959 = and i32 %1956, 8388607, !dbg !1096
  %1960 = icmp eq i32 %1959, 0, !dbg !1096
  %is_inf488 = and i1 %1958, %1960, !dbg !1096
  %1961 = bitcast float %1951 to i32, !dbg !1096
  %1962 = and i32 %1961, 2147483647, !dbg !1096
  %is_maxfinite489 = icmp eq i32 %1962, 2139095039, !dbg !1096
  %1963 = bitcast float %1951 to i32, !dbg !1096
  %1964 = and i32 %1963, -2147483648, !dbg !1096
  %1965 = icmp eq i32 %1964, 0, !dbg !1096
  %1966 = icmp ne i32 %1964, 0, !dbg !1096
  %is_pos_inf490 = and i1 %is_inf488, %1965, !dbg !1096
  %is_neg_inf491 = and i1 %is_inf488, %1966, !dbg !1096
  %is_pos_max492 = and i1 %is_maxfinite489, %1965, !dbg !1096
  %is_neg_max493 = and i1 %is_maxfinite489, %1966, !dbg !1096
  %overflow_cond494 = and i1 %1955, %is_inf488, !dbg !1096
  br i1 %overflow_cond494, label %1967, label %1969, !dbg !1096

1967:                                             ; preds = %1950
  %1968 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1969, !dbg !1096

1969:                                             ; preds = %1950, %1967
  %1970 = bitcast float %1289 to i32, !dbg !1096
  %1971 = and i32 %1970, 2139095040, !dbg !1096
  %1972 = icmp eq i32 %1971, 0, !dbg !1096
  %1973 = and i32 %1970, 8388607, !dbg !1096
  %1974 = icmp ne i32 %1973, 0, !dbg !1096
  %is_subnormal495 = and i1 %1972, %1974, !dbg !1096
  %1975 = xor i1 %is_subnormal495, true, !dbg !1096
  %1976 = and i1 true, %1975, !dbg !1096
  %1977 = and i1 %1976, true, !dbg !1096
  %1978 = bitcast float %1061 to i32, !dbg !1096
  %1979 = and i32 %1978, 2139095040, !dbg !1096
  %1980 = icmp eq i32 %1979, 0, !dbg !1096
  %1981 = and i32 %1978, 8388607, !dbg !1096
  %1982 = icmp ne i32 %1981, 0, !dbg !1096
  %is_subnormal496 = and i1 %1980, %1982, !dbg !1096
  %1983 = xor i1 %is_subnormal496, true, !dbg !1096
  %1984 = and i1 %1977, %1983, !dbg !1096
  %1985 = bitcast float %1951 to i32, !dbg !1096
  %1986 = and i32 %1985, 2139095040, !dbg !1096
  %1987 = icmp eq i32 %1986, 0, !dbg !1096
  %1988 = and i32 %1985, 8388607, !dbg !1096
  %1989 = icmp ne i32 %1988, 0, !dbg !1096
  %is_subnormal497 = and i1 %1987, %1989, !dbg !1096
  %is_tiny498 = or i1 %is_subnormal497, false, !dbg !1096
  %underflow_cond499 = and i1 %1984, %is_tiny498, !dbg !1096
  br i1 %underflow_cond499, label %1990, label %1992, !dbg !1096

1990:                                             ; preds = %1969
  %1991 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1992, !dbg !1096

1992:                                             ; preds = %1969, %1990
  %1993 = bitcast float %1061 to i32, !dbg !1096
  %1994 = bitcast float %1061 to i32, !dbg !1096
  %1995 = and i32 %1994, 2139095040, !dbg !1096
  %1996 = icmp eq i32 %1995, 2139095040, !dbg !1096
  %1997 = and i32 %1994, 8388607, !dbg !1096
  %1998 = icmp ne i32 %1997, 0, !dbg !1096
  %is_nan500 = and i1 %1996, %1998, !dbg !1096
  %1999 = and i32 %1993, 4194304, !dbg !1096
  %2000 = icmp eq i32 %1999, 0, !dbg !1096
  %is_snan501 = and i1 %is_nan500, %2000, !dbg !1096
  %2001 = bitcast float %1951 to i32, !dbg !1096
  %2002 = bitcast float %1951 to i32, !dbg !1096
  %2003 = and i32 %2002, 2139095040, !dbg !1096
  %2004 = icmp eq i32 %2003, 2139095040, !dbg !1096
  %2005 = and i32 %2002, 8388607, !dbg !1096
  %2006 = icmp ne i32 %2005, 0, !dbg !1096
  %is_nan502 = and i1 %2004, %2006, !dbg !1096
  %2007 = and i32 %2001, 4194304, !dbg !1096
  %2008 = icmp eq i32 %2007, 0, !dbg !1096
  %is_snan503 = and i1 %is_nan502, %2008, !dbg !1096
  %2009 = or i1 %is_snan501, %is_snan503, !dbg !1096
  %2010 = bitcast float %1061 to i32, !dbg !1096
  %2011 = and i32 %2010, 2139095040, !dbg !1096
  %2012 = icmp eq i32 %2011, 2139095040, !dbg !1096
  %2013 = and i32 %2010, 8388607, !dbg !1096
  %2014 = icmp eq i32 %2013, 0, !dbg !1096
  %is_inf504 = and i1 %2012, %2014, !dbg !1096
  %2015 = bitcast float %1951 to i32, !dbg !1096
  %2016 = and i32 %2015, 2139095040, !dbg !1096
  %2017 = icmp eq i32 %2016, 2139095040, !dbg !1096
  %2018 = and i32 %2015, 8388607, !dbg !1096
  %2019 = icmp eq i32 %2018, 0, !dbg !1096
  %is_inf505 = and i1 %2017, %2019, !dbg !1096
  %2020 = and i1 %is_inf504, %is_inf505, !dbg !1096
  %2021 = bitcast float %1061 to i32, !dbg !1096
  %2022 = bitcast float %1951 to i32, !dbg !1096
  %2023 = and i32 %2021, -2147483648, !dbg !1096
  %2024 = and i32 %2022, -2147483648, !dbg !1096
  %2025 = icmp eq i32 %2023, %2024, !dbg !1096
  %2026 = and i1 %2020, %2025, !dbg !1096
  %2027 = or i1 %2009, %2026, !dbg !1096
  br i1 %2027, label %2028, label %2030, !dbg !1096

2028:                                             ; preds = %1992
  %2029 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2030, !dbg !1096

2030:                                             ; preds = %1992, %2028
  %2031 = fsub float %1061, %1951, !dbg !1096
  %2032 = bitcast float %1061 to i32, !dbg !1096
  %2033 = and i32 %2032, 2139095040, !dbg !1096
  %is_finite506 = icmp ne i32 %2033, 2139095040, !dbg !1096
  %2034 = and i1 true, %is_finite506, !dbg !1096
  %2035 = bitcast float %1951 to i32, !dbg !1096
  %2036 = and i32 %2035, 2139095040, !dbg !1096
  %is_finite507 = icmp ne i32 %2036, 2139095040, !dbg !1096
  %2037 = and i1 %2034, %is_finite507, !dbg !1096
  %2038 = bitcast float %2031 to i32, !dbg !1096
  %2039 = and i32 %2038, 2139095040, !dbg !1096
  %2040 = icmp eq i32 %2039, 2139095040, !dbg !1096
  %2041 = and i32 %2038, 8388607, !dbg !1096
  %2042 = icmp eq i32 %2041, 0, !dbg !1096
  %is_inf508 = and i1 %2040, %2042, !dbg !1096
  %2043 = bitcast float %2031 to i32, !dbg !1096
  %2044 = and i32 %2043, 2147483647, !dbg !1096
  %is_maxfinite509 = icmp eq i32 %2044, 2139095039, !dbg !1096
  %2045 = bitcast float %2031 to i32, !dbg !1096
  %2046 = and i32 %2045, -2147483648, !dbg !1096
  %2047 = icmp eq i32 %2046, 0, !dbg !1096
  %2048 = icmp ne i32 %2046, 0, !dbg !1096
  %is_pos_inf510 = and i1 %is_inf508, %2047, !dbg !1096
  %is_neg_inf511 = and i1 %is_inf508, %2048, !dbg !1096
  %is_pos_max512 = and i1 %is_maxfinite509, %2047, !dbg !1096
  %is_neg_max513 = and i1 %is_maxfinite509, %2048, !dbg !1096
  %overflow_cond514 = and i1 %2037, %is_inf508, !dbg !1096
  br i1 %overflow_cond514, label %2049, label %2051, !dbg !1096

2049:                                             ; preds = %2030
  %2050 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2051, !dbg !1096

2051:                                             ; preds = %2030, %2049
  %2052 = bitcast float %1289 to i32, !dbg !1096
  %2053 = bitcast float %1289 to i32, !dbg !1096
  %2054 = and i32 %2053, 2139095040, !dbg !1096
  %2055 = icmp eq i32 %2054, 2139095040, !dbg !1096
  %2056 = and i32 %2053, 8388607, !dbg !1096
  %2057 = icmp ne i32 %2056, 0, !dbg !1096
  %is_nan515 = and i1 %2055, %2057, !dbg !1096
  %2058 = and i32 %2052, 4194304, !dbg !1096
  %2059 = icmp eq i32 %2058, 0, !dbg !1096
  %is_snan516 = and i1 %is_nan515, %2059, !dbg !1096
  %2060 = or i1 %is_snan516, false, !dbg !1096
  %2061 = bitcast float %2031 to i32, !dbg !1096
  %2062 = bitcast float %2031 to i32, !dbg !1096
  %2063 = and i32 %2062, 2139095040, !dbg !1096
  %2064 = icmp eq i32 %2063, 2139095040, !dbg !1096
  %2065 = and i32 %2062, 8388607, !dbg !1096
  %2066 = icmp ne i32 %2065, 0, !dbg !1096
  %is_nan517 = and i1 %2064, %2066, !dbg !1096
  %2067 = and i32 %2061, 4194304, !dbg !1096
  %2068 = icmp eq i32 %2067, 0, !dbg !1096
  %is_snan518 = and i1 %is_nan517, %2068, !dbg !1096
  %2069 = or i1 %2060, %is_snan518, !dbg !1096
  %2070 = bitcast float %1289 to i32, !dbg !1096
  %2071 = and i32 %2070, 2147483647, !dbg !1096
  %is_zero519 = icmp eq i32 %2071, 0, !dbg !1096
  %2072 = and i1 %is_zero519, false, !dbg !1096
  %2073 = bitcast float %1289 to i32, !dbg !1096
  %2074 = and i32 %2073, 2139095040, !dbg !1096
  %2075 = icmp eq i32 %2074, 2139095040, !dbg !1096
  %2076 = and i32 %2073, 8388607, !dbg !1096
  %2077 = icmp eq i32 %2076, 0, !dbg !1096
  %is_inf520 = and i1 %2075, %2077, !dbg !1096
  %2078 = and i1 %is_inf520, false, !dbg !1096
  %2079 = or i1 %2072, %2078, !dbg !1096
  %2080 = or i1 %2069, %2079, !dbg !1096
  br i1 %2080, label %2081, label %2083, !dbg !1096

2081:                                             ; preds = %2051
  %2082 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2083, !dbg !1096

2083:                                             ; preds = %2051, %2081
  %2084 = call float @llvm.nvvm.fma.rn.f(float %1289, float 0x3FF7154760000000, float %2031) #5, !dbg !1096
  %2085 = bitcast float %1289 to i32, !dbg !1096
  %2086 = and i32 %2085, 2139095040, !dbg !1096
  %is_finite521 = icmp ne i32 %2086, 2139095040, !dbg !1096
  %2087 = and i1 true, %is_finite521, !dbg !1096
  %2088 = and i1 %2087, true, !dbg !1096
  %2089 = bitcast float %2084 to i32, !dbg !1096
  %2090 = and i32 %2089, 2139095040, !dbg !1096
  %2091 = icmp eq i32 %2090, 2139095040, !dbg !1096
  %2092 = and i32 %2089, 8388607, !dbg !1096
  %2093 = icmp eq i32 %2092, 0, !dbg !1096
  %is_inf522 = and i1 %2091, %2093, !dbg !1096
  %2094 = bitcast float %2084 to i32, !dbg !1096
  %2095 = and i32 %2094, 2147483647, !dbg !1096
  %is_maxfinite523 = icmp eq i32 %2095, 2139095039, !dbg !1096
  %2096 = bitcast float %2084 to i32, !dbg !1096
  %2097 = and i32 %2096, -2147483648, !dbg !1096
  %2098 = icmp eq i32 %2097, 0, !dbg !1096
  %2099 = icmp ne i32 %2097, 0, !dbg !1096
  %is_pos_inf524 = and i1 %is_inf522, %2098, !dbg !1096
  %is_neg_inf525 = and i1 %is_inf522, %2099, !dbg !1096
  %is_pos_max526 = and i1 %is_maxfinite523, %2098, !dbg !1096
  %is_neg_max527 = and i1 %is_maxfinite523, %2099, !dbg !1096
  %overflow_cond528 = and i1 %2088, %is_inf522, !dbg !1096
  br i1 %overflow_cond528, label %2100, label %2102, !dbg !1096

2100:                                             ; preds = %2083
  %2101 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2102, !dbg !1096

2102:                                             ; preds = %2083, %2100
  %2103 = bitcast float %1289 to i32, !dbg !1096
  %2104 = and i32 %2103, 2139095040, !dbg !1096
  %2105 = icmp eq i32 %2104, 0, !dbg !1096
  %2106 = and i32 %2103, 8388607, !dbg !1096
  %2107 = icmp ne i32 %2106, 0, !dbg !1096
  %is_subnormal529 = and i1 %2105, %2107, !dbg !1096
  %2108 = xor i1 %is_subnormal529, true, !dbg !1096
  %2109 = and i1 true, %2108, !dbg !1096
  %2110 = and i1 %2109, true, !dbg !1096
  %2111 = bitcast float %2031 to i32, !dbg !1096
  %2112 = and i32 %2111, 2139095040, !dbg !1096
  %2113 = icmp eq i32 %2112, 0, !dbg !1096
  %2114 = and i32 %2111, 8388607, !dbg !1096
  %2115 = icmp ne i32 %2114, 0, !dbg !1096
  %is_subnormal530 = and i1 %2113, %2115, !dbg !1096
  %2116 = xor i1 %is_subnormal530, true, !dbg !1096
  %2117 = and i1 %2110, %2116, !dbg !1096
  %2118 = bitcast float %2084 to i32, !dbg !1096
  %2119 = and i32 %2118, 2139095040, !dbg !1096
  %2120 = icmp eq i32 %2119, 0, !dbg !1096
  %2121 = and i32 %2118, 8388607, !dbg !1096
  %2122 = icmp ne i32 %2121, 0, !dbg !1096
  %is_subnormal531 = and i1 %2120, %2122, !dbg !1096
  %is_tiny532 = or i1 %is_subnormal531, false, !dbg !1096
  %underflow_cond533 = and i1 %2117, %is_tiny532, !dbg !1096
  br i1 %underflow_cond533, label %2123, label %2125, !dbg !1096

2123:                                             ; preds = %2102
  %2124 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2125, !dbg !1096

2125:                                             ; preds = %2102, %2123
  %insert87.i = insertvalue %struct.float2 undef, float %1951, 0, !dbg !1096
  %insert89.i = insertvalue %struct.float2 %insert87.i, float %2084, 1, !dbg !1096
  %2126 = bitcast float %1693 to i32, !dbg !1096
  %2127 = bitcast float %1693 to i32, !dbg !1096
  %2128 = and i32 %2127, 2139095040, !dbg !1096
  %2129 = icmp eq i32 %2128, 2139095040, !dbg !1096
  %2130 = and i32 %2127, 8388607, !dbg !1096
  %2131 = icmp ne i32 %2130, 0, !dbg !1096
  %is_nan534 = and i1 %2129, %2131, !dbg !1096
  %2132 = and i32 %2126, 4194304, !dbg !1096
  %2133 = icmp eq i32 %2132, 0, !dbg !1096
  %is_snan535 = and i1 %is_nan534, %2133, !dbg !1096
  %2134 = or i1 %is_snan535, false, !dbg !1096
  %2135 = bitcast float %2084 to i32, !dbg !1096
  %2136 = bitcast float %2084 to i32, !dbg !1096
  %2137 = and i32 %2136, 2139095040, !dbg !1096
  %2138 = icmp eq i32 %2137, 2139095040, !dbg !1096
  %2139 = and i32 %2136, 8388607, !dbg !1096
  %2140 = icmp ne i32 %2139, 0, !dbg !1096
  %is_nan536 = and i1 %2138, %2140, !dbg !1096
  %2141 = and i32 %2135, 4194304, !dbg !1096
  %2142 = icmp eq i32 %2141, 0, !dbg !1096
  %is_snan537 = and i1 %is_nan536, %2142, !dbg !1096
  %2143 = or i1 %2134, %is_snan537, !dbg !1096
  %2144 = bitcast float %1693 to i32, !dbg !1096
  %2145 = and i32 %2144, 2147483647, !dbg !1096
  %is_zero538 = icmp eq i32 %2145, 0, !dbg !1096
  %2146 = and i1 %is_zero538, false, !dbg !1096
  %2147 = bitcast float %1693 to i32, !dbg !1096
  %2148 = and i32 %2147, 2139095040, !dbg !1096
  %2149 = icmp eq i32 %2148, 2139095040, !dbg !1096
  %2150 = and i32 %2147, 8388607, !dbg !1096
  %2151 = icmp eq i32 %2150, 0, !dbg !1096
  %is_inf539 = and i1 %2149, %2151, !dbg !1096
  %2152 = and i1 %is_inf539, false, !dbg !1096
  %2153 = or i1 %2146, %2152, !dbg !1096
  %2154 = or i1 %2143, %2153, !dbg !1096
  br i1 %2154, label %2155, label %2157, !dbg !1096

2155:                                             ; preds = %2125
  %2156 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2157, !dbg !1096

2157:                                             ; preds = %2125, %2155
  %2158 = call float @llvm.nvvm.fma.rn.f(float %1693, float 0x3FF7154760000000, float %2084) #5, !dbg !1096
  %2159 = bitcast float %1693 to i32, !dbg !1096
  %2160 = and i32 %2159, 2139095040, !dbg !1096
  %is_finite540 = icmp ne i32 %2160, 2139095040, !dbg !1096
  %2161 = and i1 true, %is_finite540, !dbg !1096
  %2162 = and i1 %2161, true, !dbg !1096
  %2163 = bitcast float %2158 to i32, !dbg !1096
  %2164 = and i32 %2163, 2139095040, !dbg !1096
  %2165 = icmp eq i32 %2164, 2139095040, !dbg !1096
  %2166 = and i32 %2163, 8388607, !dbg !1096
  %2167 = icmp eq i32 %2166, 0, !dbg !1096
  %is_inf541 = and i1 %2165, %2167, !dbg !1096
  %2168 = bitcast float %2158 to i32, !dbg !1096
  %2169 = and i32 %2168, 2147483647, !dbg !1096
  %is_maxfinite542 = icmp eq i32 %2169, 2139095039, !dbg !1096
  %2170 = bitcast float %2158 to i32, !dbg !1096
  %2171 = and i32 %2170, -2147483648, !dbg !1096
  %2172 = icmp eq i32 %2171, 0, !dbg !1096
  %2173 = icmp ne i32 %2171, 0, !dbg !1096
  %is_pos_inf543 = and i1 %is_inf541, %2172, !dbg !1096
  %is_neg_inf544 = and i1 %is_inf541, %2173, !dbg !1096
  %is_pos_max545 = and i1 %is_maxfinite542, %2172, !dbg !1096
  %is_neg_max546 = and i1 %is_maxfinite542, %2173, !dbg !1096
  %overflow_cond547 = and i1 %2162, %is_inf541, !dbg !1096
  br i1 %overflow_cond547, label %2174, label %2176, !dbg !1096

2174:                                             ; preds = %2157
  %2175 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2176, !dbg !1096

2176:                                             ; preds = %2157, %2174
  %2177 = bitcast float %1693 to i32, !dbg !1096
  %2178 = and i32 %2177, 2139095040, !dbg !1096
  %2179 = icmp eq i32 %2178, 0, !dbg !1096
  %2180 = and i32 %2177, 8388607, !dbg !1096
  %2181 = icmp ne i32 %2180, 0, !dbg !1096
  %is_subnormal548 = and i1 %2179, %2181, !dbg !1096
  %2182 = xor i1 %is_subnormal548, true, !dbg !1096
  %2183 = and i1 true, %2182, !dbg !1096
  %2184 = and i1 %2183, true, !dbg !1096
  %2185 = bitcast float %2084 to i32, !dbg !1096
  %2186 = and i32 %2185, 2139095040, !dbg !1096
  %2187 = icmp eq i32 %2186, 0, !dbg !1096
  %2188 = and i32 %2185, 8388607, !dbg !1096
  %2189 = icmp ne i32 %2188, 0, !dbg !1096
  %is_subnormal549 = and i1 %2187, %2189, !dbg !1096
  %2190 = xor i1 %is_subnormal549, true, !dbg !1096
  %2191 = and i1 %2184, %2190, !dbg !1096
  %2192 = bitcast float %2158 to i32, !dbg !1096
  %2193 = and i32 %2192, 2139095040, !dbg !1096
  %2194 = icmp eq i32 %2193, 0, !dbg !1096
  %2195 = and i32 %2192, 8388607, !dbg !1096
  %2196 = icmp ne i32 %2195, 0, !dbg !1096
  %is_subnormal550 = and i1 %2194, %2196, !dbg !1096
  %is_tiny551 = or i1 %is_subnormal550, false, !dbg !1096
  %underflow_cond552 = and i1 %2191, %is_tiny551, !dbg !1096
  br i1 %underflow_cond552, label %2197, label %2199, !dbg !1096

2197:                                             ; preds = %2176
  %2198 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2199, !dbg !1096

2199:                                             ; preds = %2176, %2197
  %2200 = bitcast float %1289 to i32, !dbg !1096
  %2201 = bitcast float %1289 to i32, !dbg !1096
  %2202 = and i32 %2201, 2139095040, !dbg !1096
  %2203 = icmp eq i32 %2202, 2139095040, !dbg !1096
  %2204 = and i32 %2201, 8388607, !dbg !1096
  %2205 = icmp ne i32 %2204, 0, !dbg !1096
  %is_nan553 = and i1 %2203, %2205, !dbg !1096
  %2206 = and i32 %2200, 4194304, !dbg !1096
  %2207 = icmp eq i32 %2206, 0, !dbg !1096
  %is_snan554 = and i1 %is_nan553, %2207, !dbg !1096
  %2208 = or i1 %is_snan554, false, !dbg !1096
  %2209 = bitcast float %2158 to i32, !dbg !1096
  %2210 = bitcast float %2158 to i32, !dbg !1096
  %2211 = and i32 %2210, 2139095040, !dbg !1096
  %2212 = icmp eq i32 %2211, 2139095040, !dbg !1096
  %2213 = and i32 %2210, 8388607, !dbg !1096
  %2214 = icmp ne i32 %2213, 0, !dbg !1096
  %is_nan555 = and i1 %2212, %2214, !dbg !1096
  %2215 = and i32 %2209, 4194304, !dbg !1096
  %2216 = icmp eq i32 %2215, 0, !dbg !1096
  %is_snan556 = and i1 %is_nan555, %2216, !dbg !1096
  %2217 = or i1 %2208, %is_snan556, !dbg !1096
  %2218 = bitcast float %1289 to i32, !dbg !1096
  %2219 = and i32 %2218, 2147483647, !dbg !1096
  %is_zero557 = icmp eq i32 %2219, 0, !dbg !1096
  %2220 = and i1 %is_zero557, false, !dbg !1096
  %2221 = bitcast float %1289 to i32, !dbg !1096
  %2222 = and i32 %2221, 2139095040, !dbg !1096
  %2223 = icmp eq i32 %2222, 2139095040, !dbg !1096
  %2224 = and i32 %2221, 8388607, !dbg !1096
  %2225 = icmp eq i32 %2224, 0, !dbg !1096
  %is_inf558 = and i1 %2223, %2225, !dbg !1096
  %2226 = and i1 %is_inf558, false, !dbg !1096
  %2227 = or i1 %2220, %2226, !dbg !1096
  %2228 = or i1 %2217, %2227, !dbg !1096
  br i1 %2228, label %2229, label %2231, !dbg !1096

2229:                                             ; preds = %2199
  %2230 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2231, !dbg !1096

2231:                                             ; preds = %2199, %2229
  %2232 = call float @llvm.nvvm.fma.rn.f(float %1289, float 0x3E54ABC680000000, float %2158) #5, !dbg !1096
  %2233 = bitcast float %1289 to i32, !dbg !1096
  %2234 = and i32 %2233, 2139095040, !dbg !1096
  %is_finite559 = icmp ne i32 %2234, 2139095040, !dbg !1096
  %2235 = and i1 true, %is_finite559, !dbg !1096
  %2236 = and i1 %2235, true, !dbg !1096
  %2237 = bitcast float %2232 to i32, !dbg !1096
  %2238 = and i32 %2237, 2139095040, !dbg !1096
  %2239 = icmp eq i32 %2238, 2139095040, !dbg !1096
  %2240 = and i32 %2237, 8388607, !dbg !1096
  %2241 = icmp eq i32 %2240, 0, !dbg !1096
  %is_inf560 = and i1 %2239, %2241, !dbg !1096
  %2242 = bitcast float %2232 to i32, !dbg !1096
  %2243 = and i32 %2242, 2147483647, !dbg !1096
  %is_maxfinite561 = icmp eq i32 %2243, 2139095039, !dbg !1096
  %2244 = bitcast float %2232 to i32, !dbg !1096
  %2245 = and i32 %2244, -2147483648, !dbg !1096
  %2246 = icmp eq i32 %2245, 0, !dbg !1096
  %2247 = icmp ne i32 %2245, 0, !dbg !1096
  %is_pos_inf562 = and i1 %is_inf560, %2246, !dbg !1096
  %is_neg_inf563 = and i1 %is_inf560, %2247, !dbg !1096
  %is_pos_max564 = and i1 %is_maxfinite561, %2246, !dbg !1096
  %is_neg_max565 = and i1 %is_maxfinite561, %2247, !dbg !1096
  %overflow_cond566 = and i1 %2236, %is_inf560, !dbg !1096
  br i1 %overflow_cond566, label %2248, label %2250, !dbg !1096

2248:                                             ; preds = %2231
  %2249 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2250, !dbg !1096

2250:                                             ; preds = %2231, %2248
  %2251 = bitcast float %1289 to i32, !dbg !1096
  %2252 = and i32 %2251, 2139095040, !dbg !1096
  %2253 = icmp eq i32 %2252, 0, !dbg !1096
  %2254 = and i32 %2251, 8388607, !dbg !1096
  %2255 = icmp ne i32 %2254, 0, !dbg !1096
  %is_subnormal567 = and i1 %2253, %2255, !dbg !1096
  %2256 = xor i1 %is_subnormal567, true, !dbg !1096
  %2257 = and i1 true, %2256, !dbg !1096
  %2258 = and i1 %2257, true, !dbg !1096
  %2259 = bitcast float %2158 to i32, !dbg !1096
  %2260 = and i32 %2259, 2139095040, !dbg !1096
  %2261 = icmp eq i32 %2260, 0, !dbg !1096
  %2262 = and i32 %2259, 8388607, !dbg !1096
  %2263 = icmp ne i32 %2262, 0, !dbg !1096
  %is_subnormal568 = and i1 %2261, %2263, !dbg !1096
  %2264 = xor i1 %is_subnormal568, true, !dbg !1096
  %2265 = and i1 %2258, %2264, !dbg !1096
  %2266 = bitcast float %2232 to i32, !dbg !1096
  %2267 = and i32 %2266, 2139095040, !dbg !1096
  %2268 = icmp eq i32 %2267, 0, !dbg !1096
  %2269 = and i32 %2266, 8388607, !dbg !1096
  %2270 = icmp ne i32 %2269, 0, !dbg !1096
  %is_subnormal569 = and i1 %2268, %2270, !dbg !1096
  %is_tiny570 = or i1 %is_subnormal569, false, !dbg !1096
  %underflow_cond571 = and i1 %2265, %is_tiny570, !dbg !1096
  br i1 %underflow_cond571, label %2271, label %2273, !dbg !1096

2271:                                             ; preds = %2250
  %2272 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2273, !dbg !1096

2273:                                             ; preds = %2250, %2271
  %2274 = bitcast float %1918 to i32, !dbg !1096
  %2275 = bitcast float %1918 to i32, !dbg !1096
  %2276 = and i32 %2275, 2139095040, !dbg !1096
  %2277 = icmp eq i32 %2276, 2139095040, !dbg !1096
  %2278 = and i32 %2275, 8388607, !dbg !1096
  %2279 = icmp ne i32 %2278, 0, !dbg !1096
  %is_nan572 = and i1 %2277, %2279, !dbg !1096
  %2280 = and i32 %2274, 4194304, !dbg !1096
  %2281 = icmp eq i32 %2280, 0, !dbg !1096
  %is_snan573 = and i1 %is_nan572, %2281, !dbg !1096
  %2282 = or i1 false, %is_snan573, !dbg !1096
  %2283 = bitcast float %1918 to i32, !dbg !1096
  %2284 = and i32 %2283, 2139095040, !dbg !1096
  %2285 = icmp eq i32 %2284, 2139095040, !dbg !1096
  %2286 = and i32 %2283, 8388607, !dbg !1096
  %2287 = icmp eq i32 %2286, 0, !dbg !1096
  %is_inf574 = and i1 %2285, %2287, !dbg !1096
  %2288 = and i1 false, %is_inf574, !dbg !1096
  %2289 = bitcast float %1918 to i32, !dbg !1096
  %2290 = and i32 %2289, 2147483647, !dbg !1096
  %is_zero575 = icmp eq i32 %2290, 0, !dbg !1096
  %2291 = and i1 false, %is_zero575, !dbg !1096
  %2292 = or i1 %2288, %2291, !dbg !1096
  %2293 = or i1 %2282, %2292, !dbg !1096
  br i1 %2293, label %2294, label %2296, !dbg !1096

2294:                                             ; preds = %2273
  %2295 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2296, !dbg !1096

2296:                                             ; preds = %2273, %2294
  %2297 = fmul float 3.000000e+00, %1918, !dbg !1096
  %2298 = bitcast float %1918 to i32, !dbg !1096
  %2299 = and i32 %2298, 2139095040, !dbg !1096
  %is_finite576 = icmp ne i32 %2299, 2139095040, !dbg !1096
  %2300 = and i1 true, %is_finite576, !dbg !1096
  %2301 = bitcast float %2297 to i32, !dbg !1096
  %2302 = and i32 %2301, 2139095040, !dbg !1096
  %2303 = icmp eq i32 %2302, 2139095040, !dbg !1096
  %2304 = and i32 %2301, 8388607, !dbg !1096
  %2305 = icmp eq i32 %2304, 0, !dbg !1096
  %is_inf577 = and i1 %2303, %2305, !dbg !1096
  %2306 = bitcast float %2297 to i32, !dbg !1096
  %2307 = and i32 %2306, 2147483647, !dbg !1096
  %is_maxfinite578 = icmp eq i32 %2307, 2139095039, !dbg !1096
  %2308 = bitcast float %2297 to i32, !dbg !1096
  %2309 = and i32 %2308, -2147483648, !dbg !1096
  %2310 = icmp eq i32 %2309, 0, !dbg !1096
  %2311 = icmp ne i32 %2309, 0, !dbg !1096
  %is_pos_inf579 = and i1 %is_inf577, %2310, !dbg !1096
  %is_neg_inf580 = and i1 %is_inf577, %2311, !dbg !1096
  %is_pos_max581 = and i1 %is_maxfinite578, %2310, !dbg !1096
  %is_neg_max582 = and i1 %is_maxfinite578, %2311, !dbg !1096
  %overflow_cond583 = and i1 %2300, %is_inf577, !dbg !1096
  br i1 %overflow_cond583, label %2312, label %2314, !dbg !1096

2312:                                             ; preds = %2296
  %2313 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2314, !dbg !1096

2314:                                             ; preds = %2296, %2312
  %2315 = bitcast float %1918 to i32, !dbg !1096
  %2316 = and i32 %2315, 2139095040, !dbg !1096
  %2317 = icmp eq i32 %2316, 0, !dbg !1096
  %2318 = and i32 %2315, 8388607, !dbg !1096
  %2319 = icmp ne i32 %2318, 0, !dbg !1096
  %is_subnormal584 = and i1 %2317, %2319, !dbg !1096
  %2320 = xor i1 %is_subnormal584, true, !dbg !1096
  %2321 = and i1 true, %2320, !dbg !1096
  %2322 = bitcast float %2297 to i32, !dbg !1096
  %2323 = and i32 %2322, 2139095040, !dbg !1096
  %2324 = icmp eq i32 %2323, 0, !dbg !1096
  %2325 = and i32 %2322, 8388607, !dbg !1096
  %2326 = icmp ne i32 %2325, 0, !dbg !1096
  %is_subnormal585 = and i1 %2324, %2326, !dbg !1096
  %2327 = bitcast float %2297 to i32, !dbg !1096
  %2328 = and i32 %2327, 2147483647, !dbg !1096
  %is_zero586 = icmp eq i32 %2328, 0, !dbg !1096
  %2329 = bitcast float %1918 to i32, !dbg !1096
  %2330 = and i32 %2329, 2147483647, !dbg !1096
  %is_zero587 = icmp eq i32 %2330, 0, !dbg !1096
  %2331 = xor i1 %is_zero587, true, !dbg !1096
  %2332 = and i1 true, %2331, !dbg !1096
  %2333 = and i1 %is_zero586, %2332, !dbg !1096
  %is_tiny588 = or i1 %is_subnormal585, %2333, !dbg !1096
  %underflow_cond589 = and i1 %2321, %is_tiny588, !dbg !1096
  br i1 %underflow_cond589, label %2334, label %2336, !dbg !1096

2334:                                             ; preds = %2314
  %2335 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2336, !dbg !1096

2336:                                             ; preds = %2314, %2334
  %2337 = bitcast float %2297 to i32, !dbg !1096
  %2338 = bitcast float %2297 to i32, !dbg !1096
  %2339 = and i32 %2338, 2139095040, !dbg !1096
  %2340 = icmp eq i32 %2339, 2139095040, !dbg !1096
  %2341 = and i32 %2338, 8388607, !dbg !1096
  %2342 = icmp ne i32 %2341, 0, !dbg !1096
  %is_nan590 = and i1 %2340, %2342, !dbg !1096
  %2343 = and i32 %2337, 4194304, !dbg !1096
  %2344 = icmp eq i32 %2343, 0, !dbg !1096
  %is_snan591 = and i1 %is_nan590, %2344, !dbg !1096
  %2345 = bitcast float %1693 to i32, !dbg !1096
  %2346 = bitcast float %1693 to i32, !dbg !1096
  %2347 = and i32 %2346, 2139095040, !dbg !1096
  %2348 = icmp eq i32 %2347, 2139095040, !dbg !1096
  %2349 = and i32 %2346, 8388607, !dbg !1096
  %2350 = icmp ne i32 %2349, 0, !dbg !1096
  %is_nan592 = and i1 %2348, %2350, !dbg !1096
  %2351 = and i32 %2345, 4194304, !dbg !1096
  %2352 = icmp eq i32 %2351, 0, !dbg !1096
  %is_snan593 = and i1 %is_nan592, %2352, !dbg !1096
  %2353 = or i1 %is_snan591, %is_snan593, !dbg !1096
  %2354 = bitcast float %2232 to i32, !dbg !1096
  %2355 = bitcast float %2232 to i32, !dbg !1096
  %2356 = and i32 %2355, 2139095040, !dbg !1096
  %2357 = icmp eq i32 %2356, 2139095040, !dbg !1096
  %2358 = and i32 %2355, 8388607, !dbg !1096
  %2359 = icmp ne i32 %2358, 0, !dbg !1096
  %is_nan594 = and i1 %2357, %2359, !dbg !1096
  %2360 = and i32 %2354, 4194304, !dbg !1096
  %2361 = icmp eq i32 %2360, 0, !dbg !1096
  %is_snan595 = and i1 %is_nan594, %2361, !dbg !1096
  %2362 = or i1 %2353, %is_snan595, !dbg !1096
  %2363 = bitcast float %2297 to i32, !dbg !1096
  %2364 = and i32 %2363, 2147483647, !dbg !1096
  %is_zero596 = icmp eq i32 %2364, 0, !dbg !1096
  %2365 = bitcast float %1693 to i32, !dbg !1096
  %2366 = and i32 %2365, 2139095040, !dbg !1096
  %2367 = icmp eq i32 %2366, 2139095040, !dbg !1096
  %2368 = and i32 %2365, 8388607, !dbg !1096
  %2369 = icmp eq i32 %2368, 0, !dbg !1096
  %is_inf597 = and i1 %2367, %2369, !dbg !1096
  %2370 = and i1 %is_zero596, %is_inf597, !dbg !1096
  %2371 = bitcast float %2297 to i32, !dbg !1096
  %2372 = and i32 %2371, 2139095040, !dbg !1096
  %2373 = icmp eq i32 %2372, 2139095040, !dbg !1096
  %2374 = and i32 %2371, 8388607, !dbg !1096
  %2375 = icmp eq i32 %2374, 0, !dbg !1096
  %is_inf598 = and i1 %2373, %2375, !dbg !1096
  %2376 = bitcast float %1693 to i32, !dbg !1096
  %2377 = and i32 %2376, 2147483647, !dbg !1096
  %is_zero599 = icmp eq i32 %2377, 0, !dbg !1096
  %2378 = and i1 %is_inf598, %is_zero599, !dbg !1096
  %2379 = or i1 %2370, %2378, !dbg !1096
  %2380 = or i1 %2362, %2379, !dbg !1096
  br i1 %2380, label %2381, label %2383, !dbg !1096

2381:                                             ; preds = %2336
  %2382 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2383, !dbg !1096

2383:                                             ; preds = %2336, %2381
  %2384 = call float @llvm.nvvm.fma.rn.f(float %2297, float %1693, float %2232) #5, !dbg !1096
  %2385 = bitcast float %2297 to i32, !dbg !1096
  %2386 = and i32 %2385, 2139095040, !dbg !1096
  %is_finite600 = icmp ne i32 %2386, 2139095040, !dbg !1096
  %2387 = and i1 true, %is_finite600, !dbg !1096
  %2388 = bitcast float %1693 to i32, !dbg !1096
  %2389 = and i32 %2388, 2139095040, !dbg !1096
  %is_finite601 = icmp ne i32 %2389, 2139095040, !dbg !1096
  %2390 = and i1 %2387, %is_finite601, !dbg !1096
  %2391 = bitcast float %2384 to i32, !dbg !1096
  %2392 = and i32 %2391, 2139095040, !dbg !1096
  %2393 = icmp eq i32 %2392, 2139095040, !dbg !1096
  %2394 = and i32 %2391, 8388607, !dbg !1096
  %2395 = icmp eq i32 %2394, 0, !dbg !1096
  %is_inf602 = and i1 %2393, %2395, !dbg !1096
  %2396 = bitcast float %2384 to i32, !dbg !1096
  %2397 = and i32 %2396, 2147483647, !dbg !1096
  %is_maxfinite603 = icmp eq i32 %2397, 2139095039, !dbg !1096
  %2398 = bitcast float %2384 to i32, !dbg !1096
  %2399 = and i32 %2398, -2147483648, !dbg !1096
  %2400 = icmp eq i32 %2399, 0, !dbg !1096
  %2401 = icmp ne i32 %2399, 0, !dbg !1096
  %is_pos_inf604 = and i1 %is_inf602, %2400, !dbg !1096
  %is_neg_inf605 = and i1 %is_inf602, %2401, !dbg !1096
  %is_pos_max606 = and i1 %is_maxfinite603, %2400, !dbg !1096
  %is_neg_max607 = and i1 %is_maxfinite603, %2401, !dbg !1096
  %overflow_cond608 = and i1 %2390, %is_inf602, !dbg !1096
  br i1 %overflow_cond608, label %2402, label %2404, !dbg !1096

2402:                                             ; preds = %2383
  %2403 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2404, !dbg !1096

2404:                                             ; preds = %2383, %2402
  %2405 = bitcast float %2297 to i32, !dbg !1096
  %2406 = and i32 %2405, 2139095040, !dbg !1096
  %2407 = icmp eq i32 %2406, 0, !dbg !1096
  %2408 = and i32 %2405, 8388607, !dbg !1096
  %2409 = icmp ne i32 %2408, 0, !dbg !1096
  %is_subnormal609 = and i1 %2407, %2409, !dbg !1096
  %2410 = xor i1 %is_subnormal609, true, !dbg !1096
  %2411 = and i1 true, %2410, !dbg !1096
  %2412 = bitcast float %1693 to i32, !dbg !1096
  %2413 = and i32 %2412, 2139095040, !dbg !1096
  %2414 = icmp eq i32 %2413, 0, !dbg !1096
  %2415 = and i32 %2412, 8388607, !dbg !1096
  %2416 = icmp ne i32 %2415, 0, !dbg !1096
  %is_subnormal610 = and i1 %2414, %2416, !dbg !1096
  %2417 = xor i1 %is_subnormal610, true, !dbg !1096
  %2418 = and i1 %2411, %2417, !dbg !1096
  %2419 = bitcast float %2232 to i32, !dbg !1096
  %2420 = and i32 %2419, 2139095040, !dbg !1096
  %2421 = icmp eq i32 %2420, 0, !dbg !1096
  %2422 = and i32 %2419, 8388607, !dbg !1096
  %2423 = icmp ne i32 %2422, 0, !dbg !1096
  %is_subnormal611 = and i1 %2421, %2423, !dbg !1096
  %2424 = xor i1 %is_subnormal611, true, !dbg !1096
  %2425 = and i1 %2418, %2424, !dbg !1096
  %2426 = bitcast float %2384 to i32, !dbg !1096
  %2427 = and i32 %2426, 2139095040, !dbg !1096
  %2428 = icmp eq i32 %2427, 0, !dbg !1096
  %2429 = and i32 %2426, 8388607, !dbg !1096
  %2430 = icmp ne i32 %2429, 0, !dbg !1096
  %is_subnormal612 = and i1 %2428, %2430, !dbg !1096
  %is_tiny613 = or i1 %is_subnormal612, false, !dbg !1096
  %underflow_cond614 = and i1 %2425, %is_tiny613, !dbg !1096
  br i1 %underflow_cond614, label %2431, label %2433, !dbg !1096

2431:                                             ; preds = %2404
  %2432 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2433, !dbg !1096

2433:                                             ; preds = %2404, %2431
  %2434 = bitcast float %1918 to i32, !dbg !1096
  %2435 = bitcast float %1918 to i32, !dbg !1096
  %2436 = and i32 %2435, 2139095040, !dbg !1096
  %2437 = icmp eq i32 %2436, 2139095040, !dbg !1096
  %2438 = and i32 %2435, 8388607, !dbg !1096
  %2439 = icmp ne i32 %2438, 0, !dbg !1096
  %is_nan615 = and i1 %2437, %2439, !dbg !1096
  %2440 = and i32 %2434, 4194304, !dbg !1096
  %2441 = icmp eq i32 %2440, 0, !dbg !1096
  %is_snan616 = and i1 %is_nan615, %2441, !dbg !1096
  %2442 = bitcast float %1289 to i32, !dbg !1096
  %2443 = bitcast float %1289 to i32, !dbg !1096
  %2444 = and i32 %2443, 2139095040, !dbg !1096
  %2445 = icmp eq i32 %2444, 2139095040, !dbg !1096
  %2446 = and i32 %2443, 8388607, !dbg !1096
  %2447 = icmp ne i32 %2446, 0, !dbg !1096
  %is_nan617 = and i1 %2445, %2447, !dbg !1096
  %2448 = and i32 %2442, 4194304, !dbg !1096
  %2449 = icmp eq i32 %2448, 0, !dbg !1096
  %is_snan618 = and i1 %is_nan617, %2449, !dbg !1096
  %2450 = or i1 %is_snan616, %is_snan618, !dbg !1096
  %2451 = bitcast float %2384 to i32, !dbg !1096
  %2452 = bitcast float %2384 to i32, !dbg !1096
  %2453 = and i32 %2452, 2139095040, !dbg !1096
  %2454 = icmp eq i32 %2453, 2139095040, !dbg !1096
  %2455 = and i32 %2452, 8388607, !dbg !1096
  %2456 = icmp ne i32 %2455, 0, !dbg !1096
  %is_nan619 = and i1 %2454, %2456, !dbg !1096
  %2457 = and i32 %2451, 4194304, !dbg !1096
  %2458 = icmp eq i32 %2457, 0, !dbg !1096
  %is_snan620 = and i1 %is_nan619, %2458, !dbg !1096
  %2459 = or i1 %2450, %is_snan620, !dbg !1096
  %2460 = bitcast float %1918 to i32, !dbg !1096
  %2461 = and i32 %2460, 2147483647, !dbg !1096
  %is_zero621 = icmp eq i32 %2461, 0, !dbg !1096
  %2462 = bitcast float %1289 to i32, !dbg !1096
  %2463 = and i32 %2462, 2139095040, !dbg !1096
  %2464 = icmp eq i32 %2463, 2139095040, !dbg !1096
  %2465 = and i32 %2462, 8388607, !dbg !1096
  %2466 = icmp eq i32 %2465, 0, !dbg !1096
  %is_inf622 = and i1 %2464, %2466, !dbg !1096
  %2467 = and i1 %is_zero621, %is_inf622, !dbg !1096
  %2468 = bitcast float %1918 to i32, !dbg !1096
  %2469 = and i32 %2468, 2139095040, !dbg !1096
  %2470 = icmp eq i32 %2469, 2139095040, !dbg !1096
  %2471 = and i32 %2468, 8388607, !dbg !1096
  %2472 = icmp eq i32 %2471, 0, !dbg !1096
  %is_inf623 = and i1 %2470, %2472, !dbg !1096
  %2473 = bitcast float %1289 to i32, !dbg !1096
  %2474 = and i32 %2473, 2147483647, !dbg !1096
  %is_zero624 = icmp eq i32 %2474, 0, !dbg !1096
  %2475 = and i1 %is_inf623, %is_zero624, !dbg !1096
  %2476 = or i1 %2467, %2475, !dbg !1096
  %2477 = or i1 %2459, %2476, !dbg !1096
  br i1 %2477, label %2478, label %2480, !dbg !1096

2478:                                             ; preds = %2433
  %2479 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2480, !dbg !1096

2480:                                             ; preds = %2433, %2478
  %2481 = call float @llvm.nvvm.fma.rn.f(float %1918, float %1289, float %2384) #5, !dbg !1096
  %2482 = bitcast float %1918 to i32, !dbg !1096
  %2483 = and i32 %2482, 2139095040, !dbg !1096
  %is_finite625 = icmp ne i32 %2483, 2139095040, !dbg !1096
  %2484 = and i1 true, %is_finite625, !dbg !1096
  %2485 = bitcast float %1289 to i32, !dbg !1096
  %2486 = and i32 %2485, 2139095040, !dbg !1096
  %is_finite626 = icmp ne i32 %2486, 2139095040, !dbg !1096
  %2487 = and i1 %2484, %is_finite626, !dbg !1096
  %2488 = bitcast float %2481 to i32, !dbg !1096
  %2489 = and i32 %2488, 2139095040, !dbg !1096
  %2490 = icmp eq i32 %2489, 2139095040, !dbg !1096
  %2491 = and i32 %2488, 8388607, !dbg !1096
  %2492 = icmp eq i32 %2491, 0, !dbg !1096
  %is_inf627 = and i1 %2490, %2492, !dbg !1096
  %2493 = bitcast float %2481 to i32, !dbg !1096
  %2494 = and i32 %2493, 2147483647, !dbg !1096
  %is_maxfinite628 = icmp eq i32 %2494, 2139095039, !dbg !1096
  %2495 = bitcast float %2481 to i32, !dbg !1096
  %2496 = and i32 %2495, -2147483648, !dbg !1096
  %2497 = icmp eq i32 %2496, 0, !dbg !1096
  %2498 = icmp ne i32 %2496, 0, !dbg !1096
  %is_pos_inf629 = and i1 %is_inf627, %2497, !dbg !1096
  %is_neg_inf630 = and i1 %is_inf627, %2498, !dbg !1096
  %is_pos_max631 = and i1 %is_maxfinite628, %2497, !dbg !1096
  %is_neg_max632 = and i1 %is_maxfinite628, %2498, !dbg !1096
  %overflow_cond633 = and i1 %2487, %is_inf627, !dbg !1096
  br i1 %overflow_cond633, label %2499, label %2501, !dbg !1096

2499:                                             ; preds = %2480
  %2500 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2501, !dbg !1096

2501:                                             ; preds = %2480, %2499
  %2502 = bitcast float %1918 to i32, !dbg !1096
  %2503 = and i32 %2502, 2139095040, !dbg !1096
  %2504 = icmp eq i32 %2503, 0, !dbg !1096
  %2505 = and i32 %2502, 8388607, !dbg !1096
  %2506 = icmp ne i32 %2505, 0, !dbg !1096
  %is_subnormal634 = and i1 %2504, %2506, !dbg !1096
  %2507 = xor i1 %is_subnormal634, true, !dbg !1096
  %2508 = and i1 true, %2507, !dbg !1096
  %2509 = bitcast float %1289 to i32, !dbg !1096
  %2510 = and i32 %2509, 2139095040, !dbg !1096
  %2511 = icmp eq i32 %2510, 0, !dbg !1096
  %2512 = and i32 %2509, 8388607, !dbg !1096
  %2513 = icmp ne i32 %2512, 0, !dbg !1096
  %is_subnormal635 = and i1 %2511, %2513, !dbg !1096
  %2514 = xor i1 %is_subnormal635, true, !dbg !1096
  %2515 = and i1 %2508, %2514, !dbg !1096
  %2516 = bitcast float %2384 to i32, !dbg !1096
  %2517 = and i32 %2516, 2139095040, !dbg !1096
  %2518 = icmp eq i32 %2517, 0, !dbg !1096
  %2519 = and i32 %2516, 8388607, !dbg !1096
  %2520 = icmp ne i32 %2519, 0, !dbg !1096
  %is_subnormal636 = and i1 %2518, %2520, !dbg !1096
  %2521 = xor i1 %is_subnormal636, true, !dbg !1096
  %2522 = and i1 %2515, %2521, !dbg !1096
  %2523 = bitcast float %2481 to i32, !dbg !1096
  %2524 = and i32 %2523, 2139095040, !dbg !1096
  %2525 = icmp eq i32 %2524, 0, !dbg !1096
  %2526 = and i32 %2523, 8388607, !dbg !1096
  %2527 = icmp ne i32 %2526, 0, !dbg !1096
  %is_subnormal637 = and i1 %2525, %2527, !dbg !1096
  %is_tiny638 = or i1 %is_subnormal637, false, !dbg !1096
  %underflow_cond639 = and i1 %2522, %is_tiny638, !dbg !1096
  br i1 %underflow_cond639, label %2528, label %2530, !dbg !1096

2528:                                             ; preds = %2501
  %2529 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2530, !dbg !1096

2530:                                             ; preds = %2501, %2528
  %2531 = call float @llvm.nvvm.add.rn.f(float %1951, float %2481) #5, !dbg !1096
  %2532 = bitcast float %1951 to i32, !dbg !1096
  %2533 = bitcast float %1951 to i32, !dbg !1096
  %2534 = and i32 %2533, 2139095040, !dbg !1096
  %2535 = icmp eq i32 %2534, 2139095040, !dbg !1096
  %2536 = and i32 %2533, 8388607, !dbg !1096
  %2537 = icmp ne i32 %2536, 0, !dbg !1096
  %is_nan640 = and i1 %2535, %2537, !dbg !1096
  %2538 = and i32 %2532, 4194304, !dbg !1096
  %2539 = icmp eq i32 %2538, 0, !dbg !1096
  %is_snan641 = and i1 %is_nan640, %2539, !dbg !1096
  %2540 = or i1 false, %is_snan641, !dbg !1096
  %2541 = bitcast float %1951 to i32, !dbg !1096
  %2542 = and i32 %2541, 2139095040, !dbg !1096
  %2543 = icmp eq i32 %2542, 2139095040, !dbg !1096
  %2544 = and i32 %2541, 8388607, !dbg !1096
  %2545 = icmp eq i32 %2544, 0, !dbg !1096
  %is_inf642 = and i1 %2543, %2545, !dbg !1096
  %2546 = and i1 false, %is_inf642, !dbg !1096
  %2547 = bitcast float %1951 to i32, !dbg !1096
  %2548 = and i32 %2547, -2147483648, !dbg !1096
  %2549 = icmp eq i32 -2147483648, %2548, !dbg !1096
  %2550 = and i1 %2546, %2549, !dbg !1096
  %2551 = or i1 %2540, %2550, !dbg !1096
  br i1 %2551, label %2552, label %2554, !dbg !1096

2552:                                             ; preds = %2530
  %2553 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2554, !dbg !1096

2554:                                             ; preds = %2530, %2552
  %2555 = fsub float -0.000000e+00, %1951, !dbg !1096
  %2556 = bitcast float %1951 to i32, !dbg !1096
  %2557 = and i32 %2556, 2139095040, !dbg !1096
  %is_finite643 = icmp ne i32 %2557, 2139095040, !dbg !1096
  %2558 = and i1 true, %is_finite643, !dbg !1096
  %2559 = bitcast float %2555 to i32, !dbg !1096
  %2560 = and i32 %2559, 2139095040, !dbg !1096
  %2561 = icmp eq i32 %2560, 2139095040, !dbg !1096
  %2562 = and i32 %2559, 8388607, !dbg !1096
  %2563 = icmp eq i32 %2562, 0, !dbg !1096
  %is_inf644 = and i1 %2561, %2563, !dbg !1096
  %2564 = bitcast float %2555 to i32, !dbg !1096
  %2565 = and i32 %2564, 2147483647, !dbg !1096
  %is_maxfinite645 = icmp eq i32 %2565, 2139095039, !dbg !1096
  %2566 = bitcast float %2555 to i32, !dbg !1096
  %2567 = and i32 %2566, -2147483648, !dbg !1096
  %2568 = icmp eq i32 %2567, 0, !dbg !1096
  %2569 = icmp ne i32 %2567, 0, !dbg !1096
  %is_pos_inf646 = and i1 %is_inf644, %2568, !dbg !1096
  %is_neg_inf647 = and i1 %is_inf644, %2569, !dbg !1096
  %is_pos_max648 = and i1 %is_maxfinite645, %2568, !dbg !1096
  %is_neg_max649 = and i1 %is_maxfinite645, %2569, !dbg !1096
  %overflow_cond650 = and i1 %2558, %is_inf644, !dbg !1096
  br i1 %overflow_cond650, label %2570, label %2572, !dbg !1096

2570:                                             ; preds = %2554
  %2571 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2572, !dbg !1096

2572:                                             ; preds = %2554, %2570
  %2573 = call float @llvm.nvvm.add.rn.f(float %2531, float %2555) #5, !dbg !1096
  %2574 = bitcast float %2573 to i32, !dbg !1096
  %2575 = bitcast float %2573 to i32, !dbg !1096
  %2576 = and i32 %2575, 2139095040, !dbg !1096
  %2577 = icmp eq i32 %2576, 2139095040, !dbg !1096
  %2578 = and i32 %2575, 8388607, !dbg !1096
  %2579 = icmp ne i32 %2578, 0, !dbg !1096
  %is_nan651 = and i1 %2577, %2579, !dbg !1096
  %2580 = and i32 %2574, 4194304, !dbg !1096
  %2581 = icmp eq i32 %2580, 0, !dbg !1096
  %is_snan652 = and i1 %is_nan651, %2581, !dbg !1096
  %2582 = or i1 false, %is_snan652, !dbg !1096
  %2583 = bitcast float %2573 to i32, !dbg !1096
  %2584 = and i32 %2583, 2139095040, !dbg !1096
  %2585 = icmp eq i32 %2584, 2139095040, !dbg !1096
  %2586 = and i32 %2583, 8388607, !dbg !1096
  %2587 = icmp eq i32 %2586, 0, !dbg !1096
  %is_inf653 = and i1 %2585, %2587, !dbg !1096
  %2588 = and i1 false, %is_inf653, !dbg !1096
  %2589 = bitcast float %2573 to i32, !dbg !1096
  %2590 = and i32 %2589, -2147483648, !dbg !1096
  %2591 = icmp eq i32 -2147483648, %2590, !dbg !1096
  %2592 = and i1 %2588, %2591, !dbg !1096
  %2593 = or i1 %2582, %2592, !dbg !1096
  br i1 %2593, label %2594, label %2596, !dbg !1096

2594:                                             ; preds = %2572
  %2595 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2596, !dbg !1096

2596:                                             ; preds = %2572, %2594
  %2597 = fsub float -0.000000e+00, %2573, !dbg !1096
  %2598 = bitcast float %2573 to i32, !dbg !1096
  %2599 = and i32 %2598, 2139095040, !dbg !1096
  %is_finite654 = icmp ne i32 %2599, 2139095040, !dbg !1096
  %2600 = and i1 true, %is_finite654, !dbg !1096
  %2601 = bitcast float %2597 to i32, !dbg !1096
  %2602 = and i32 %2601, 2139095040, !dbg !1096
  %2603 = icmp eq i32 %2602, 2139095040, !dbg !1096
  %2604 = and i32 %2601, 8388607, !dbg !1096
  %2605 = icmp eq i32 %2604, 0, !dbg !1096
  %is_inf655 = and i1 %2603, %2605, !dbg !1096
  %2606 = bitcast float %2597 to i32, !dbg !1096
  %2607 = and i32 %2606, 2147483647, !dbg !1096
  %is_maxfinite656 = icmp eq i32 %2607, 2139095039, !dbg !1096
  %2608 = bitcast float %2597 to i32, !dbg !1096
  %2609 = and i32 %2608, -2147483648, !dbg !1096
  %2610 = icmp eq i32 %2609, 0, !dbg !1096
  %2611 = icmp ne i32 %2609, 0, !dbg !1096
  %is_pos_inf657 = and i1 %is_inf655, %2610, !dbg !1096
  %is_neg_inf658 = and i1 %is_inf655, %2611, !dbg !1096
  %is_pos_max659 = and i1 %is_maxfinite656, %2610, !dbg !1096
  %is_neg_max660 = and i1 %is_maxfinite656, %2611, !dbg !1096
  %overflow_cond661 = and i1 %2600, %is_inf655, !dbg !1096
  br i1 %overflow_cond661, label %2612, label %2614, !dbg !1096

2612:                                             ; preds = %2596
  %2613 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2614, !dbg !1096

2614:                                             ; preds = %2596, %2612
  %2615 = call float @llvm.nvvm.add.rn.f(float %2481, float %2597) #5, !dbg !1096
  %insert77.i = insertvalue %struct.float2 undef, float %2531, 0, !dbg !1096
  %insert79.i = insertvalue %struct.float2 %insert77.i, float %2615, 1, !dbg !1096
  %insert.i = insertvalue %struct.float2 undef, float %2531, 0, !dbg !1096
  %insert69.i = insertvalue %struct.float2 %insert.i, float %2615, 1, !dbg !1096
  %2616 = call float @llvm.nvvm.mul.rn.f(float %2531, float %763) #5, !dbg !1096
  %2617 = bitcast float %2616 to i32, !dbg !1096
  %2618 = bitcast float %2616 to i32, !dbg !1096
  %2619 = and i32 %2618, 2139095040, !dbg !1096
  %2620 = icmp eq i32 %2619, 2139095040, !dbg !1096
  %2621 = and i32 %2618, 8388607, !dbg !1096
  %2622 = icmp ne i32 %2621, 0, !dbg !1096
  %is_nan662 = and i1 %2620, %2622, !dbg !1096
  %2623 = and i32 %2617, 4194304, !dbg !1096
  %2624 = icmp eq i32 %2623, 0, !dbg !1096
  %is_snan663 = and i1 %is_nan662, %2624, !dbg !1096
  %2625 = or i1 false, %is_snan663, !dbg !1096
  %2626 = bitcast float %2616 to i32, !dbg !1096
  %2627 = and i32 %2626, 2139095040, !dbg !1096
  %2628 = icmp eq i32 %2627, 2139095040, !dbg !1096
  %2629 = and i32 %2626, 8388607, !dbg !1096
  %2630 = icmp eq i32 %2629, 0, !dbg !1096
  %is_inf664 = and i1 %2628, %2630, !dbg !1096
  %2631 = and i1 false, %is_inf664, !dbg !1096
  %2632 = bitcast float %2616 to i32, !dbg !1096
  %2633 = and i32 %2632, -2147483648, !dbg !1096
  %2634 = icmp eq i32 -2147483648, %2633, !dbg !1096
  %2635 = and i1 %2631, %2634, !dbg !1096
  %2636 = or i1 %2625, %2635, !dbg !1096
  br i1 %2636, label %2637, label %2639, !dbg !1096

2637:                                             ; preds = %2614
  %2638 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2639, !dbg !1096

2639:                                             ; preds = %2614, %2637
  %2640 = fsub float -0.000000e+00, %2616, !dbg !1096
  %2641 = bitcast float %2616 to i32, !dbg !1096
  %2642 = and i32 %2641, 2139095040, !dbg !1096
  %is_finite665 = icmp ne i32 %2642, 2139095040, !dbg !1096
  %2643 = and i1 true, %is_finite665, !dbg !1096
  %2644 = bitcast float %2640 to i32, !dbg !1096
  %2645 = and i32 %2644, 2139095040, !dbg !1096
  %2646 = icmp eq i32 %2645, 2139095040, !dbg !1096
  %2647 = and i32 %2644, 8388607, !dbg !1096
  %2648 = icmp eq i32 %2647, 0, !dbg !1096
  %is_inf666 = and i1 %2646, %2648, !dbg !1096
  %2649 = bitcast float %2640 to i32, !dbg !1096
  %2650 = and i32 %2649, 2147483647, !dbg !1096
  %is_maxfinite667 = icmp eq i32 %2650, 2139095039, !dbg !1096
  %2651 = bitcast float %2640 to i32, !dbg !1096
  %2652 = and i32 %2651, -2147483648, !dbg !1096
  %2653 = icmp eq i32 %2652, 0, !dbg !1096
  %2654 = icmp ne i32 %2652, 0, !dbg !1096
  %is_pos_inf668 = and i1 %is_inf666, %2653, !dbg !1096
  %is_neg_inf669 = and i1 %is_inf666, %2654, !dbg !1096
  %is_pos_max670 = and i1 %is_maxfinite667, %2653, !dbg !1096
  %is_neg_max671 = and i1 %is_maxfinite667, %2654, !dbg !1096
  %overflow_cond672 = and i1 %2643, %is_inf666, !dbg !1096
  br i1 %overflow_cond672, label %2655, label %2657, !dbg !1096

2655:                                             ; preds = %2639
  %2656 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2657, !dbg !1096

2657:                                             ; preds = %2639, %2655
  %2658 = bitcast float %2531 to i32, !dbg !1096
  %2659 = bitcast float %2531 to i32, !dbg !1096
  %2660 = and i32 %2659, 2139095040, !dbg !1096
  %2661 = icmp eq i32 %2660, 2139095040, !dbg !1096
  %2662 = and i32 %2659, 8388607, !dbg !1096
  %2663 = icmp ne i32 %2662, 0, !dbg !1096
  %is_nan673 = and i1 %2661, %2663, !dbg !1096
  %2664 = and i32 %2658, 4194304, !dbg !1096
  %2665 = icmp eq i32 %2664, 0, !dbg !1096
  %is_snan674 = and i1 %is_nan673, %2665, !dbg !1096
  %2666 = bitcast float %763 to i32, !dbg !1096
  %2667 = bitcast float %763 to i32, !dbg !1096
  %2668 = and i32 %2667, 2139095040, !dbg !1096
  %2669 = icmp eq i32 %2668, 2139095040, !dbg !1096
  %2670 = and i32 %2667, 8388607, !dbg !1096
  %2671 = icmp ne i32 %2670, 0, !dbg !1096
  %is_nan675 = and i1 %2669, %2671, !dbg !1096
  %2672 = and i32 %2666, 4194304, !dbg !1096
  %2673 = icmp eq i32 %2672, 0, !dbg !1096
  %is_snan676 = and i1 %is_nan675, %2673, !dbg !1096
  %2674 = or i1 %is_snan674, %is_snan676, !dbg !1096
  %2675 = bitcast float %2640 to i32, !dbg !1096
  %2676 = bitcast float %2640 to i32, !dbg !1096
  %2677 = and i32 %2676, 2139095040, !dbg !1096
  %2678 = icmp eq i32 %2677, 2139095040, !dbg !1096
  %2679 = and i32 %2676, 8388607, !dbg !1096
  %2680 = icmp ne i32 %2679, 0, !dbg !1096
  %is_nan677 = and i1 %2678, %2680, !dbg !1096
  %2681 = and i32 %2675, 4194304, !dbg !1096
  %2682 = icmp eq i32 %2681, 0, !dbg !1096
  %is_snan678 = and i1 %is_nan677, %2682, !dbg !1096
  %2683 = or i1 %2674, %is_snan678, !dbg !1096
  %2684 = bitcast float %2531 to i32, !dbg !1096
  %2685 = and i32 %2684, 2147483647, !dbg !1096
  %is_zero679 = icmp eq i32 %2685, 0, !dbg !1096
  %2686 = bitcast float %763 to i32, !dbg !1096
  %2687 = and i32 %2686, 2139095040, !dbg !1096
  %2688 = icmp eq i32 %2687, 2139095040, !dbg !1096
  %2689 = and i32 %2686, 8388607, !dbg !1096
  %2690 = icmp eq i32 %2689, 0, !dbg !1096
  %is_inf680 = and i1 %2688, %2690, !dbg !1096
  %2691 = and i1 %is_zero679, %is_inf680, !dbg !1096
  %2692 = bitcast float %2531 to i32, !dbg !1096
  %2693 = and i32 %2692, 2139095040, !dbg !1096
  %2694 = icmp eq i32 %2693, 2139095040, !dbg !1096
  %2695 = and i32 %2692, 8388607, !dbg !1096
  %2696 = icmp eq i32 %2695, 0, !dbg !1096
  %is_inf681 = and i1 %2694, %2696, !dbg !1096
  %2697 = bitcast float %763 to i32, !dbg !1096
  %2698 = and i32 %2697, 2147483647, !dbg !1096
  %is_zero682 = icmp eq i32 %2698, 0, !dbg !1096
  %2699 = and i1 %is_inf681, %is_zero682, !dbg !1096
  %2700 = or i1 %2691, %2699, !dbg !1096
  %2701 = or i1 %2683, %2700, !dbg !1096
  br i1 %2701, label %2702, label %2704, !dbg !1096

2702:                                             ; preds = %2657
  %2703 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2704, !dbg !1096

2704:                                             ; preds = %2657, %2702
  %2705 = call float @llvm.nvvm.fma.rn.f(float %2531, float %763, float %2640) #5, !dbg !1096
  %2706 = bitcast float %2531 to i32, !dbg !1096
  %2707 = and i32 %2706, 2139095040, !dbg !1096
  %is_finite683 = icmp ne i32 %2707, 2139095040, !dbg !1096
  %2708 = and i1 true, %is_finite683, !dbg !1096
  %2709 = bitcast float %763 to i32, !dbg !1096
  %2710 = and i32 %2709, 2139095040, !dbg !1096
  %is_finite684 = icmp ne i32 %2710, 2139095040, !dbg !1096
  %2711 = and i1 %2708, %is_finite684, !dbg !1096
  %2712 = bitcast float %2705 to i32, !dbg !1096
  %2713 = and i32 %2712, 2139095040, !dbg !1096
  %2714 = icmp eq i32 %2713, 2139095040, !dbg !1096
  %2715 = and i32 %2712, 8388607, !dbg !1096
  %2716 = icmp eq i32 %2715, 0, !dbg !1096
  %is_inf685 = and i1 %2714, %2716, !dbg !1096
  %2717 = bitcast float %2705 to i32, !dbg !1096
  %2718 = and i32 %2717, 2147483647, !dbg !1096
  %is_maxfinite686 = icmp eq i32 %2718, 2139095039, !dbg !1096
  %2719 = bitcast float %2705 to i32, !dbg !1096
  %2720 = and i32 %2719, -2147483648, !dbg !1096
  %2721 = icmp eq i32 %2720, 0, !dbg !1096
  %2722 = icmp ne i32 %2720, 0, !dbg !1096
  %is_pos_inf687 = and i1 %is_inf685, %2721, !dbg !1096
  %is_neg_inf688 = and i1 %is_inf685, %2722, !dbg !1096
  %is_pos_max689 = and i1 %is_maxfinite686, %2721, !dbg !1096
  %is_neg_max690 = and i1 %is_maxfinite686, %2722, !dbg !1096
  %overflow_cond691 = and i1 %2711, %is_inf685, !dbg !1096
  br i1 %overflow_cond691, label %2723, label %2725, !dbg !1096

2723:                                             ; preds = %2704
  %2724 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2725, !dbg !1096

2725:                                             ; preds = %2704, %2723
  %2726 = bitcast float %2531 to i32, !dbg !1096
  %2727 = and i32 %2726, 2139095040, !dbg !1096
  %2728 = icmp eq i32 %2727, 0, !dbg !1096
  %2729 = and i32 %2726, 8388607, !dbg !1096
  %2730 = icmp ne i32 %2729, 0, !dbg !1096
  %is_subnormal692 = and i1 %2728, %2730, !dbg !1096
  %2731 = xor i1 %is_subnormal692, true, !dbg !1096
  %2732 = and i1 true, %2731, !dbg !1096
  %2733 = bitcast float %763 to i32, !dbg !1096
  %2734 = and i32 %2733, 2139095040, !dbg !1096
  %2735 = icmp eq i32 %2734, 0, !dbg !1096
  %2736 = and i32 %2733, 8388607, !dbg !1096
  %2737 = icmp ne i32 %2736, 0, !dbg !1096
  %is_subnormal693 = and i1 %2735, %2737, !dbg !1096
  %2738 = xor i1 %is_subnormal693, true, !dbg !1096
  %2739 = and i1 %2732, %2738, !dbg !1096
  %2740 = bitcast float %2640 to i32, !dbg !1096
  %2741 = and i32 %2740, 2139095040, !dbg !1096
  %2742 = icmp eq i32 %2741, 0, !dbg !1096
  %2743 = and i32 %2740, 8388607, !dbg !1096
  %2744 = icmp ne i32 %2743, 0, !dbg !1096
  %is_subnormal694 = and i1 %2742, %2744, !dbg !1096
  %2745 = xor i1 %is_subnormal694, true, !dbg !1096
  %2746 = and i1 %2739, %2745, !dbg !1096
  %2747 = bitcast float %2705 to i32, !dbg !1096
  %2748 = and i32 %2747, 2139095040, !dbg !1096
  %2749 = icmp eq i32 %2748, 0, !dbg !1096
  %2750 = and i32 %2747, 8388607, !dbg !1096
  %2751 = icmp ne i32 %2750, 0, !dbg !1096
  %is_subnormal695 = and i1 %2749, %2751, !dbg !1096
  %is_tiny696 = or i1 %is_subnormal695, false, !dbg !1096
  %underflow_cond697 = and i1 %2746, %is_tiny696, !dbg !1096
  br i1 %underflow_cond697, label %2752, label %2754, !dbg !1096

2752:                                             ; preds = %2725
  %2753 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2754, !dbg !1096

2754:                                             ; preds = %2725, %2752
  %insert97.i = insertvalue %struct.float2 undef, float %2616, 0, !dbg !1096
  %insert99.i = insertvalue %struct.float2 %insert97.i, float %2705, 1, !dbg !1096
  %2755 = bitcast float %2615 to i32, !dbg !1096
  %2756 = bitcast float %2615 to i32, !dbg !1096
  %2757 = and i32 %2756, 2139095040, !dbg !1096
  %2758 = icmp eq i32 %2757, 2139095040, !dbg !1096
  %2759 = and i32 %2756, 8388607, !dbg !1096
  %2760 = icmp ne i32 %2759, 0, !dbg !1096
  %is_nan698 = and i1 %2758, %2760, !dbg !1096
  %2761 = and i32 %2755, 4194304, !dbg !1096
  %2762 = icmp eq i32 %2761, 0, !dbg !1096
  %is_snan699 = and i1 %is_nan698, %2762, !dbg !1096
  %2763 = bitcast float %763 to i32, !dbg !1096
  %2764 = bitcast float %763 to i32, !dbg !1096
  %2765 = and i32 %2764, 2139095040, !dbg !1096
  %2766 = icmp eq i32 %2765, 2139095040, !dbg !1096
  %2767 = and i32 %2764, 8388607, !dbg !1096
  %2768 = icmp ne i32 %2767, 0, !dbg !1096
  %is_nan700 = and i1 %2766, %2768, !dbg !1096
  %2769 = and i32 %2763, 4194304, !dbg !1096
  %2770 = icmp eq i32 %2769, 0, !dbg !1096
  %is_snan701 = and i1 %is_nan700, %2770, !dbg !1096
  %2771 = or i1 %is_snan699, %is_snan701, !dbg !1096
  %2772 = bitcast float %2705 to i32, !dbg !1096
  %2773 = bitcast float %2705 to i32, !dbg !1096
  %2774 = and i32 %2773, 2139095040, !dbg !1096
  %2775 = icmp eq i32 %2774, 2139095040, !dbg !1096
  %2776 = and i32 %2773, 8388607, !dbg !1096
  %2777 = icmp ne i32 %2776, 0, !dbg !1096
  %is_nan702 = and i1 %2775, %2777, !dbg !1096
  %2778 = and i32 %2772, 4194304, !dbg !1096
  %2779 = icmp eq i32 %2778, 0, !dbg !1096
  %is_snan703 = and i1 %is_nan702, %2779, !dbg !1096
  %2780 = or i1 %2771, %is_snan703, !dbg !1096
  %2781 = bitcast float %2615 to i32, !dbg !1096
  %2782 = and i32 %2781, 2147483647, !dbg !1096
  %is_zero704 = icmp eq i32 %2782, 0, !dbg !1096
  %2783 = bitcast float %763 to i32, !dbg !1096
  %2784 = and i32 %2783, 2139095040, !dbg !1096
  %2785 = icmp eq i32 %2784, 2139095040, !dbg !1096
  %2786 = and i32 %2783, 8388607, !dbg !1096
  %2787 = icmp eq i32 %2786, 0, !dbg !1096
  %is_inf705 = and i1 %2785, %2787, !dbg !1096
  %2788 = and i1 %is_zero704, %is_inf705, !dbg !1096
  %2789 = bitcast float %2615 to i32, !dbg !1096
  %2790 = and i32 %2789, 2139095040, !dbg !1096
  %2791 = icmp eq i32 %2790, 2139095040, !dbg !1096
  %2792 = and i32 %2789, 8388607, !dbg !1096
  %2793 = icmp eq i32 %2792, 0, !dbg !1096
  %is_inf706 = and i1 %2791, %2793, !dbg !1096
  %2794 = bitcast float %763 to i32, !dbg !1096
  %2795 = and i32 %2794, 2147483647, !dbg !1096
  %is_zero707 = icmp eq i32 %2795, 0, !dbg !1096
  %2796 = and i1 %is_inf706, %is_zero707, !dbg !1096
  %2797 = or i1 %2788, %2796, !dbg !1096
  %2798 = or i1 %2780, %2797, !dbg !1096
  br i1 %2798, label %2799, label %2801, !dbg !1096

2799:                                             ; preds = %2754
  %2800 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2801, !dbg !1096

2801:                                             ; preds = %2754, %2799
  %2802 = call float @llvm.nvvm.fma.rn.f(float %2615, float %763, float %2705) #5, !dbg !1096
  %2803 = bitcast float %2615 to i32, !dbg !1096
  %2804 = and i32 %2803, 2139095040, !dbg !1096
  %is_finite708 = icmp ne i32 %2804, 2139095040, !dbg !1096
  %2805 = and i1 true, %is_finite708, !dbg !1096
  %2806 = bitcast float %763 to i32, !dbg !1096
  %2807 = and i32 %2806, 2139095040, !dbg !1096
  %is_finite709 = icmp ne i32 %2807, 2139095040, !dbg !1096
  %2808 = and i1 %2805, %is_finite709, !dbg !1096
  %2809 = bitcast float %2802 to i32, !dbg !1096
  %2810 = and i32 %2809, 2139095040, !dbg !1096
  %2811 = icmp eq i32 %2810, 2139095040, !dbg !1096
  %2812 = and i32 %2809, 8388607, !dbg !1096
  %2813 = icmp eq i32 %2812, 0, !dbg !1096
  %is_inf710 = and i1 %2811, %2813, !dbg !1096
  %2814 = bitcast float %2802 to i32, !dbg !1096
  %2815 = and i32 %2814, 2147483647, !dbg !1096
  %is_maxfinite711 = icmp eq i32 %2815, 2139095039, !dbg !1096
  %2816 = bitcast float %2802 to i32, !dbg !1096
  %2817 = and i32 %2816, -2147483648, !dbg !1096
  %2818 = icmp eq i32 %2817, 0, !dbg !1096
  %2819 = icmp ne i32 %2817, 0, !dbg !1096
  %is_pos_inf712 = and i1 %is_inf710, %2818, !dbg !1096
  %is_neg_inf713 = and i1 %is_inf710, %2819, !dbg !1096
  %is_pos_max714 = and i1 %is_maxfinite711, %2818, !dbg !1096
  %is_neg_max715 = and i1 %is_maxfinite711, %2819, !dbg !1096
  %overflow_cond716 = and i1 %2808, %is_inf710, !dbg !1096
  br i1 %overflow_cond716, label %2820, label %2822, !dbg !1096

2820:                                             ; preds = %2801
  %2821 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2822, !dbg !1096

2822:                                             ; preds = %2801, %2820
  %2823 = bitcast float %2615 to i32, !dbg !1096
  %2824 = and i32 %2823, 2139095040, !dbg !1096
  %2825 = icmp eq i32 %2824, 0, !dbg !1096
  %2826 = and i32 %2823, 8388607, !dbg !1096
  %2827 = icmp ne i32 %2826, 0, !dbg !1096
  %is_subnormal717 = and i1 %2825, %2827, !dbg !1096
  %2828 = xor i1 %is_subnormal717, true, !dbg !1096
  %2829 = and i1 true, %2828, !dbg !1096
  %2830 = bitcast float %763 to i32, !dbg !1096
  %2831 = and i32 %2830, 2139095040, !dbg !1096
  %2832 = icmp eq i32 %2831, 0, !dbg !1096
  %2833 = and i32 %2830, 8388607, !dbg !1096
  %2834 = icmp ne i32 %2833, 0, !dbg !1096
  %is_subnormal718 = and i1 %2832, %2834, !dbg !1096
  %2835 = xor i1 %is_subnormal718, true, !dbg !1096
  %2836 = and i1 %2829, %2835, !dbg !1096
  %2837 = bitcast float %2705 to i32, !dbg !1096
  %2838 = and i32 %2837, 2139095040, !dbg !1096
  %2839 = icmp eq i32 %2838, 0, !dbg !1096
  %2840 = and i32 %2837, 8388607, !dbg !1096
  %2841 = icmp ne i32 %2840, 0, !dbg !1096
  %is_subnormal719 = and i1 %2839, %2841, !dbg !1096
  %2842 = xor i1 %is_subnormal719, true, !dbg !1096
  %2843 = and i1 %2836, %2842, !dbg !1096
  %2844 = bitcast float %2802 to i32, !dbg !1096
  %2845 = and i32 %2844, 2139095040, !dbg !1096
  %2846 = icmp eq i32 %2845, 0, !dbg !1096
  %2847 = and i32 %2844, 8388607, !dbg !1096
  %2848 = icmp ne i32 %2847, 0, !dbg !1096
  %is_subnormal720 = and i1 %2846, %2848, !dbg !1096
  %is_tiny721 = or i1 %is_subnormal720, false, !dbg !1096
  %underflow_cond722 = and i1 %2843, %is_tiny721, !dbg !1096
  br i1 %underflow_cond722, label %2849, label %2851, !dbg !1096

2849:                                             ; preds = %2822
  %2850 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2851, !dbg !1096

2851:                                             ; preds = %2822, %2849
  %2852 = call float @llvm.nvvm.round.f(float %2616) #5, !dbg !1096
  %2853 = bitcast float %2616 to i32, !dbg !1096
  %2854 = bitcast float %2616 to i32, !dbg !1096
  %2855 = and i32 %2854, 2139095040, !dbg !1096
  %2856 = icmp eq i32 %2855, 2139095040, !dbg !1096
  %2857 = and i32 %2854, 8388607, !dbg !1096
  %2858 = icmp ne i32 %2857, 0, !dbg !1096
  %is_nan723 = and i1 %2856, %2858, !dbg !1096
  %2859 = and i32 %2853, 4194304, !dbg !1096
  %2860 = icmp eq i32 %2859, 0, !dbg !1096
  %is_snan724 = and i1 %is_nan723, %2860, !dbg !1096
  %2861 = bitcast float %2852 to i32, !dbg !1096
  %2862 = bitcast float %2852 to i32, !dbg !1096
  %2863 = and i32 %2862, 2139095040, !dbg !1096
  %2864 = icmp eq i32 %2863, 2139095040, !dbg !1096
  %2865 = and i32 %2862, 8388607, !dbg !1096
  %2866 = icmp ne i32 %2865, 0, !dbg !1096
  %is_nan725 = and i1 %2864, %2866, !dbg !1096
  %2867 = and i32 %2861, 4194304, !dbg !1096
  %2868 = icmp eq i32 %2867, 0, !dbg !1096
  %is_snan726 = and i1 %is_nan725, %2868, !dbg !1096
  %2869 = or i1 %is_snan724, %is_snan726, !dbg !1096
  %2870 = bitcast float %2616 to i32, !dbg !1096
  %2871 = and i32 %2870, 2139095040, !dbg !1096
  %2872 = icmp eq i32 %2871, 2139095040, !dbg !1096
  %2873 = and i32 %2870, 8388607, !dbg !1096
  %2874 = icmp eq i32 %2873, 0, !dbg !1096
  %is_inf727 = and i1 %2872, %2874, !dbg !1096
  %2875 = bitcast float %2852 to i32, !dbg !1096
  %2876 = and i32 %2875, 2139095040, !dbg !1096
  %2877 = icmp eq i32 %2876, 2139095040, !dbg !1096
  %2878 = and i32 %2875, 8388607, !dbg !1096
  %2879 = icmp eq i32 %2878, 0, !dbg !1096
  %is_inf728 = and i1 %2877, %2879, !dbg !1096
  %2880 = and i1 %is_inf727, %is_inf728, !dbg !1096
  %2881 = bitcast float %2616 to i32, !dbg !1096
  %2882 = bitcast float %2852 to i32, !dbg !1096
  %2883 = and i32 %2881, -2147483648, !dbg !1096
  %2884 = and i32 %2882, -2147483648, !dbg !1096
  %2885 = icmp eq i32 %2883, %2884, !dbg !1096
  %2886 = and i1 %2880, %2885, !dbg !1096
  %2887 = or i1 %2869, %2886, !dbg !1096
  br i1 %2887, label %2888, label %2890, !dbg !1096

2888:                                             ; preds = %2851
  %2889 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2890, !dbg !1096

2890:                                             ; preds = %2851, %2888
  %2891 = fsub float %2616, %2852, !dbg !1096
  %2892 = bitcast float %2616 to i32, !dbg !1096
  %2893 = and i32 %2892, 2139095040, !dbg !1096
  %is_finite729 = icmp ne i32 %2893, 2139095040, !dbg !1096
  %2894 = and i1 true, %is_finite729, !dbg !1096
  %2895 = bitcast float %2852 to i32, !dbg !1096
  %2896 = and i32 %2895, 2139095040, !dbg !1096
  %is_finite730 = icmp ne i32 %2896, 2139095040, !dbg !1096
  %2897 = and i1 %2894, %is_finite730, !dbg !1096
  %2898 = bitcast float %2891 to i32, !dbg !1096
  %2899 = and i32 %2898, 2139095040, !dbg !1096
  %2900 = icmp eq i32 %2899, 2139095040, !dbg !1096
  %2901 = and i32 %2898, 8388607, !dbg !1096
  %2902 = icmp eq i32 %2901, 0, !dbg !1096
  %is_inf731 = and i1 %2900, %2902, !dbg !1096
  %2903 = bitcast float %2891 to i32, !dbg !1096
  %2904 = and i32 %2903, 2147483647, !dbg !1096
  %is_maxfinite732 = icmp eq i32 %2904, 2139095039, !dbg !1096
  %2905 = bitcast float %2891 to i32, !dbg !1096
  %2906 = and i32 %2905, -2147483648, !dbg !1096
  %2907 = icmp eq i32 %2906, 0, !dbg !1096
  %2908 = icmp ne i32 %2906, 0, !dbg !1096
  %is_pos_inf733 = and i1 %is_inf731, %2907, !dbg !1096
  %is_neg_inf734 = and i1 %is_inf731, %2908, !dbg !1096
  %is_pos_max735 = and i1 %is_maxfinite732, %2907, !dbg !1096
  %is_neg_max736 = and i1 %is_maxfinite732, %2908, !dbg !1096
  %overflow_cond737 = and i1 %2897, %is_inf731, !dbg !1096
  br i1 %overflow_cond737, label %2909, label %2911, !dbg !1096

2909:                                             ; preds = %2890
  %2910 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2911, !dbg !1096

2911:                                             ; preds = %2890, %2909
  %2912 = bitcast float %2891 to i32, !dbg !1096
  %2913 = bitcast float %2891 to i32, !dbg !1096
  %2914 = and i32 %2913, 2139095040, !dbg !1096
  %2915 = icmp eq i32 %2914, 2139095040, !dbg !1096
  %2916 = and i32 %2913, 8388607, !dbg !1096
  %2917 = icmp ne i32 %2916, 0, !dbg !1096
  %is_nan738 = and i1 %2915, %2917, !dbg !1096
  %2918 = and i32 %2912, 4194304, !dbg !1096
  %2919 = icmp eq i32 %2918, 0, !dbg !1096
  %is_snan739 = and i1 %is_nan738, %2919, !dbg !1096
  %2920 = bitcast float %2802 to i32, !dbg !1096
  %2921 = bitcast float %2802 to i32, !dbg !1096
  %2922 = and i32 %2921, 2139095040, !dbg !1096
  %2923 = icmp eq i32 %2922, 2139095040, !dbg !1096
  %2924 = and i32 %2921, 8388607, !dbg !1096
  %2925 = icmp ne i32 %2924, 0, !dbg !1096
  %is_nan740 = and i1 %2923, %2925, !dbg !1096
  %2926 = and i32 %2920, 4194304, !dbg !1096
  %2927 = icmp eq i32 %2926, 0, !dbg !1096
  %is_snan741 = and i1 %is_nan740, %2927, !dbg !1096
  %2928 = or i1 %is_snan739, %is_snan741, !dbg !1096
  %2929 = bitcast float %2891 to i32, !dbg !1096
  %2930 = and i32 %2929, 2139095040, !dbg !1096
  %2931 = icmp eq i32 %2930, 2139095040, !dbg !1096
  %2932 = and i32 %2929, 8388607, !dbg !1096
  %2933 = icmp eq i32 %2932, 0, !dbg !1096
  %is_inf742 = and i1 %2931, %2933, !dbg !1096
  %2934 = bitcast float %2802 to i32, !dbg !1096
  %2935 = and i32 %2934, 2139095040, !dbg !1096
  %2936 = icmp eq i32 %2935, 2139095040, !dbg !1096
  %2937 = and i32 %2934, 8388607, !dbg !1096
  %2938 = icmp eq i32 %2937, 0, !dbg !1096
  %is_inf743 = and i1 %2936, %2938, !dbg !1096
  %2939 = and i1 %is_inf742, %is_inf743, !dbg !1096
  %2940 = bitcast float %2891 to i32, !dbg !1096
  %2941 = bitcast float %2802 to i32, !dbg !1096
  %2942 = and i32 %2940, -2147483648, !dbg !1096
  %2943 = and i32 %2941, -2147483648, !dbg !1096
  %2944 = icmp ne i32 %2942, %2943, !dbg !1096
  %2945 = and i1 %2939, %2944, !dbg !1096
  %2946 = or i1 %2928, %2945, !dbg !1096
  br i1 %2946, label %2947, label %2949, !dbg !1096

2947:                                             ; preds = %2911
  %2948 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2949, !dbg !1096

2949:                                             ; preds = %2911, %2947
  %2950 = fadd float %2891, %2802, !dbg !1096
  %2951 = bitcast float %2891 to i32, !dbg !1096
  %2952 = and i32 %2951, 2139095040, !dbg !1096
  %is_finite744 = icmp ne i32 %2952, 2139095040, !dbg !1096
  %2953 = and i1 true, %is_finite744, !dbg !1096
  %2954 = bitcast float %2802 to i32, !dbg !1096
  %2955 = and i32 %2954, 2139095040, !dbg !1096
  %is_finite745 = icmp ne i32 %2955, 2139095040, !dbg !1096
  %2956 = and i1 %2953, %is_finite745, !dbg !1096
  %2957 = bitcast float %2950 to i32, !dbg !1096
  %2958 = and i32 %2957, 2139095040, !dbg !1096
  %2959 = icmp eq i32 %2958, 2139095040, !dbg !1096
  %2960 = and i32 %2957, 8388607, !dbg !1096
  %2961 = icmp eq i32 %2960, 0, !dbg !1096
  %is_inf746 = and i1 %2959, %2961, !dbg !1096
  %2962 = bitcast float %2950 to i32, !dbg !1096
  %2963 = and i32 %2962, 2147483647, !dbg !1096
  %is_maxfinite747 = icmp eq i32 %2963, 2139095039, !dbg !1096
  %2964 = bitcast float %2950 to i32, !dbg !1096
  %2965 = and i32 %2964, -2147483648, !dbg !1096
  %2966 = icmp eq i32 %2965, 0, !dbg !1096
  %2967 = icmp ne i32 %2965, 0, !dbg !1096
  %is_pos_inf748 = and i1 %is_inf746, %2966, !dbg !1096
  %is_neg_inf749 = and i1 %is_inf746, %2967, !dbg !1096
  %is_pos_max750 = and i1 %is_maxfinite747, %2966, !dbg !1096
  %is_neg_max751 = and i1 %is_maxfinite747, %2967, !dbg !1096
  %overflow_cond752 = and i1 %2956, %is_inf746, !dbg !1096
  br i1 %overflow_cond752, label %2968, label %2970, !dbg !1096

2968:                                             ; preds = %2949
  %2969 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2970, !dbg !1096

2970:                                             ; preds = %2949, %2968
  %2971 = bitcast float %2950 to i32, !dbg !1096
  %2972 = bitcast float %2950 to i32, !dbg !1096
  %2973 = and i32 %2972, 2139095040, !dbg !1096
  %2974 = icmp eq i32 %2973, 2139095040, !dbg !1096
  %2975 = and i32 %2972, 8388607, !dbg !1096
  %2976 = icmp ne i32 %2975, 0, !dbg !1096
  %is_nan753 = and i1 %2974, %2976, !dbg !1096
  %2977 = and i32 %2971, 4194304, !dbg !1096
  %2978 = icmp eq i32 %2977, 0, !dbg !1096
  %is_snan754 = and i1 %is_nan753, %2978, !dbg !1096
  %2979 = or i1 false, %is_snan754, !dbg !1096
  %2980 = or i1 %2979, false, !dbg !1096
  %2981 = bitcast float %2950 to i32, !dbg !1096
  %2982 = and i32 %2981, 2139095040, !dbg !1096
  %2983 = icmp eq i32 %2982, 2139095040, !dbg !1096
  %2984 = and i32 %2981, 8388607, !dbg !1096
  %2985 = icmp eq i32 %2984, 0, !dbg !1096
  %is_inf755 = and i1 %2983, %2985, !dbg !1096
  %2986 = and i1 false, %is_inf755, !dbg !1096
  %2987 = bitcast float %2950 to i32, !dbg !1096
  %2988 = and i32 %2987, 2147483647, !dbg !1096
  %is_zero756 = icmp eq i32 %2988, 0, !dbg !1096
  %2989 = and i1 false, %is_zero756, !dbg !1096
  %2990 = or i1 %2986, %2989, !dbg !1096
  %2991 = or i1 %2980, %2990, !dbg !1096
  br i1 %2991, label %2992, label %2994, !dbg !1096

2992:                                             ; preds = %2970
  %2993 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2994, !dbg !1096

2994:                                             ; preds = %2970, %2992
  %2995 = call float @llvm.nvvm.fma.rn.f(float 0x3F23F971C0000000, float %2950, float 0x3F55F0BDA0000000) #5, !dbg !1096
  %2996 = bitcast float %2950 to i32, !dbg !1096
  %2997 = and i32 %2996, 2139095040, !dbg !1096
  %is_finite757 = icmp ne i32 %2997, 2139095040, !dbg !1096
  %2998 = and i1 true, %is_finite757, !dbg !1096
  %2999 = bitcast float %2995 to i32, !dbg !1096
  %3000 = and i32 %2999, 2139095040, !dbg !1096
  %3001 = icmp eq i32 %3000, 2139095040, !dbg !1096
  %3002 = and i32 %2999, 8388607, !dbg !1096
  %3003 = icmp eq i32 %3002, 0, !dbg !1096
  %is_inf758 = and i1 %3001, %3003, !dbg !1096
  %3004 = bitcast float %2995 to i32, !dbg !1096
  %3005 = and i32 %3004, 2147483647, !dbg !1096
  %is_maxfinite759 = icmp eq i32 %3005, 2139095039, !dbg !1096
  %3006 = bitcast float %2995 to i32, !dbg !1096
  %3007 = and i32 %3006, -2147483648, !dbg !1096
  %3008 = icmp eq i32 %3007, 0, !dbg !1096
  %3009 = icmp ne i32 %3007, 0, !dbg !1096
  %is_pos_inf760 = and i1 %is_inf758, %3008, !dbg !1096
  %is_neg_inf761 = and i1 %is_inf758, %3009, !dbg !1096
  %is_pos_max762 = and i1 %is_maxfinite759, %3008, !dbg !1096
  %is_neg_max763 = and i1 %is_maxfinite759, %3009, !dbg !1096
  %overflow_cond764 = and i1 %2998, %is_inf758, !dbg !1096
  br i1 %overflow_cond764, label %3010, label %3012, !dbg !1096

3010:                                             ; preds = %2994
  %3011 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3012, !dbg !1096

3012:                                             ; preds = %2994, %3010
  %3013 = bitcast float %2950 to i32, !dbg !1096
  %3014 = and i32 %3013, 2139095040, !dbg !1096
  %3015 = icmp eq i32 %3014, 0, !dbg !1096
  %3016 = and i32 %3013, 8388607, !dbg !1096
  %3017 = icmp ne i32 %3016, 0, !dbg !1096
  %is_subnormal765 = and i1 %3015, %3017, !dbg !1096
  %3018 = xor i1 %is_subnormal765, true, !dbg !1096
  %3019 = and i1 true, %3018, !dbg !1096
  %3020 = and i1 %3019, true, !dbg !1096
  %3021 = bitcast float %2995 to i32, !dbg !1096
  %3022 = and i32 %3021, 2139095040, !dbg !1096
  %3023 = icmp eq i32 %3022, 0, !dbg !1096
  %3024 = and i32 %3021, 8388607, !dbg !1096
  %3025 = icmp ne i32 %3024, 0, !dbg !1096
  %is_subnormal766 = and i1 %3023, %3025, !dbg !1096
  %is_tiny767 = or i1 %is_subnormal766, false, !dbg !1096
  %underflow_cond768 = and i1 %3020, %is_tiny767, !dbg !1096
  br i1 %underflow_cond768, label %3026, label %3028, !dbg !1096

3026:                                             ; preds = %3012
  %3027 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3028, !dbg !1096

3028:                                             ; preds = %3012, %3026
  %3029 = bitcast float %2995 to i32, !dbg !1096
  %3030 = bitcast float %2995 to i32, !dbg !1096
  %3031 = and i32 %3030, 2139095040, !dbg !1096
  %3032 = icmp eq i32 %3031, 2139095040, !dbg !1096
  %3033 = and i32 %3030, 8388607, !dbg !1096
  %3034 = icmp ne i32 %3033, 0, !dbg !1096
  %is_nan769 = and i1 %3032, %3034, !dbg !1096
  %3035 = and i32 %3029, 4194304, !dbg !1096
  %3036 = icmp eq i32 %3035, 0, !dbg !1096
  %is_snan770 = and i1 %is_nan769, %3036, !dbg !1096
  %3037 = bitcast float %2950 to i32, !dbg !1096
  %3038 = bitcast float %2950 to i32, !dbg !1096
  %3039 = and i32 %3038, 2139095040, !dbg !1096
  %3040 = icmp eq i32 %3039, 2139095040, !dbg !1096
  %3041 = and i32 %3038, 8388607, !dbg !1096
  %3042 = icmp ne i32 %3041, 0, !dbg !1096
  %is_nan771 = and i1 %3040, %3042, !dbg !1096
  %3043 = and i32 %3037, 4194304, !dbg !1096
  %3044 = icmp eq i32 %3043, 0, !dbg !1096
  %is_snan772 = and i1 %is_nan771, %3044, !dbg !1096
  %3045 = or i1 %is_snan770, %is_snan772, !dbg !1096
  %3046 = or i1 %3045, false, !dbg !1096
  %3047 = bitcast float %2995 to i32, !dbg !1096
  %3048 = and i32 %3047, 2147483647, !dbg !1096
  %is_zero773 = icmp eq i32 %3048, 0, !dbg !1096
  %3049 = bitcast float %2950 to i32, !dbg !1096
  %3050 = and i32 %3049, 2139095040, !dbg !1096
  %3051 = icmp eq i32 %3050, 2139095040, !dbg !1096
  %3052 = and i32 %3049, 8388607, !dbg !1096
  %3053 = icmp eq i32 %3052, 0, !dbg !1096
  %is_inf774 = and i1 %3051, %3053, !dbg !1096
  %3054 = and i1 %is_zero773, %is_inf774, !dbg !1096
  %3055 = bitcast float %2995 to i32, !dbg !1096
  %3056 = and i32 %3055, 2139095040, !dbg !1096
  %3057 = icmp eq i32 %3056, 2139095040, !dbg !1096
  %3058 = and i32 %3055, 8388607, !dbg !1096
  %3059 = icmp eq i32 %3058, 0, !dbg !1096
  %is_inf775 = and i1 %3057, %3059, !dbg !1096
  %3060 = bitcast float %2950 to i32, !dbg !1096
  %3061 = and i32 %3060, 2147483647, !dbg !1096
  %is_zero776 = icmp eq i32 %3061, 0, !dbg !1096
  %3062 = and i1 %is_inf775, %is_zero776, !dbg !1096
  %3063 = or i1 %3054, %3062, !dbg !1096
  %3064 = or i1 %3046, %3063, !dbg !1096
  br i1 %3064, label %3065, label %3067, !dbg !1096

3065:                                             ; preds = %3028
  %3066 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3067, !dbg !1096

3067:                                             ; preds = %3028, %3065
  %3068 = call float @llvm.nvvm.fma.rn.f(float %2995, float %2950, float 0x3F83B30AC0000000) #5, !dbg !1096
  %3069 = bitcast float %2995 to i32, !dbg !1096
  %3070 = and i32 %3069, 2139095040, !dbg !1096
  %is_finite777 = icmp ne i32 %3070, 2139095040, !dbg !1096
  %3071 = and i1 true, %is_finite777, !dbg !1096
  %3072 = bitcast float %2950 to i32, !dbg !1096
  %3073 = and i32 %3072, 2139095040, !dbg !1096
  %is_finite778 = icmp ne i32 %3073, 2139095040, !dbg !1096
  %3074 = and i1 %3071, %is_finite778, !dbg !1096
  %3075 = bitcast float %3068 to i32, !dbg !1096
  %3076 = and i32 %3075, 2139095040, !dbg !1096
  %3077 = icmp eq i32 %3076, 2139095040, !dbg !1096
  %3078 = and i32 %3075, 8388607, !dbg !1096
  %3079 = icmp eq i32 %3078, 0, !dbg !1096
  %is_inf779 = and i1 %3077, %3079, !dbg !1096
  %3080 = bitcast float %3068 to i32, !dbg !1096
  %3081 = and i32 %3080, 2147483647, !dbg !1096
  %is_maxfinite780 = icmp eq i32 %3081, 2139095039, !dbg !1096
  %3082 = bitcast float %3068 to i32, !dbg !1096
  %3083 = and i32 %3082, -2147483648, !dbg !1096
  %3084 = icmp eq i32 %3083, 0, !dbg !1096
  %3085 = icmp ne i32 %3083, 0, !dbg !1096
  %is_pos_inf781 = and i1 %is_inf779, %3084, !dbg !1096
  %is_neg_inf782 = and i1 %is_inf779, %3085, !dbg !1096
  %is_pos_max783 = and i1 %is_maxfinite780, %3084, !dbg !1096
  %is_neg_max784 = and i1 %is_maxfinite780, %3085, !dbg !1096
  %overflow_cond785 = and i1 %3074, %is_inf779, !dbg !1096
  br i1 %overflow_cond785, label %3086, label %3088, !dbg !1096

3086:                                             ; preds = %3067
  %3087 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3088, !dbg !1096

3088:                                             ; preds = %3067, %3086
  %3089 = bitcast float %2995 to i32, !dbg !1096
  %3090 = and i32 %3089, 2139095040, !dbg !1096
  %3091 = icmp eq i32 %3090, 0, !dbg !1096
  %3092 = and i32 %3089, 8388607, !dbg !1096
  %3093 = icmp ne i32 %3092, 0, !dbg !1096
  %is_subnormal786 = and i1 %3091, %3093, !dbg !1096
  %3094 = xor i1 %is_subnormal786, true, !dbg !1096
  %3095 = and i1 true, %3094, !dbg !1096
  %3096 = bitcast float %2950 to i32, !dbg !1096
  %3097 = and i32 %3096, 2139095040, !dbg !1096
  %3098 = icmp eq i32 %3097, 0, !dbg !1096
  %3099 = and i32 %3096, 8388607, !dbg !1096
  %3100 = icmp ne i32 %3099, 0, !dbg !1096
  %is_subnormal787 = and i1 %3098, %3100, !dbg !1096
  %3101 = xor i1 %is_subnormal787, true, !dbg !1096
  %3102 = and i1 %3095, %3101, !dbg !1096
  %3103 = and i1 %3102, true, !dbg !1096
  %3104 = bitcast float %3068 to i32, !dbg !1096
  %3105 = and i32 %3104, 2139095040, !dbg !1096
  %3106 = icmp eq i32 %3105, 0, !dbg !1096
  %3107 = and i32 %3104, 8388607, !dbg !1096
  %3108 = icmp ne i32 %3107, 0, !dbg !1096
  %is_subnormal788 = and i1 %3106, %3108, !dbg !1096
  %is_tiny789 = or i1 %is_subnormal788, false, !dbg !1096
  %underflow_cond790 = and i1 %3103, %is_tiny789, !dbg !1096
  br i1 %underflow_cond790, label %3109, label %3111, !dbg !1096

3109:                                             ; preds = %3088
  %3110 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3111, !dbg !1096

3111:                                             ; preds = %3088, %3109
  %3112 = bitcast float %3068 to i32, !dbg !1096
  %3113 = bitcast float %3068 to i32, !dbg !1096
  %3114 = and i32 %3113, 2139095040, !dbg !1096
  %3115 = icmp eq i32 %3114, 2139095040, !dbg !1096
  %3116 = and i32 %3113, 8388607, !dbg !1096
  %3117 = icmp ne i32 %3116, 0, !dbg !1096
  %is_nan791 = and i1 %3115, %3117, !dbg !1096
  %3118 = and i32 %3112, 4194304, !dbg !1096
  %3119 = icmp eq i32 %3118, 0, !dbg !1096
  %is_snan792 = and i1 %is_nan791, %3119, !dbg !1096
  %3120 = bitcast float %2950 to i32, !dbg !1096
  %3121 = bitcast float %2950 to i32, !dbg !1096
  %3122 = and i32 %3121, 2139095040, !dbg !1096
  %3123 = icmp eq i32 %3122, 2139095040, !dbg !1096
  %3124 = and i32 %3121, 8388607, !dbg !1096
  %3125 = icmp ne i32 %3124, 0, !dbg !1096
  %is_nan793 = and i1 %3123, %3125, !dbg !1096
  %3126 = and i32 %3120, 4194304, !dbg !1096
  %3127 = icmp eq i32 %3126, 0, !dbg !1096
  %is_snan794 = and i1 %is_nan793, %3127, !dbg !1096
  %3128 = or i1 %is_snan792, %is_snan794, !dbg !1096
  %3129 = or i1 %3128, false, !dbg !1096
  %3130 = bitcast float %3068 to i32, !dbg !1096
  %3131 = and i32 %3130, 2147483647, !dbg !1096
  %is_zero795 = icmp eq i32 %3131, 0, !dbg !1096
  %3132 = bitcast float %2950 to i32, !dbg !1096
  %3133 = and i32 %3132, 2139095040, !dbg !1096
  %3134 = icmp eq i32 %3133, 2139095040, !dbg !1096
  %3135 = and i32 %3132, 8388607, !dbg !1096
  %3136 = icmp eq i32 %3135, 0, !dbg !1096
  %is_inf796 = and i1 %3134, %3136, !dbg !1096
  %3137 = and i1 %is_zero795, %is_inf796, !dbg !1096
  %3138 = bitcast float %3068 to i32, !dbg !1096
  %3139 = and i32 %3138, 2139095040, !dbg !1096
  %3140 = icmp eq i32 %3139, 2139095040, !dbg !1096
  %3141 = and i32 %3138, 8388607, !dbg !1096
  %3142 = icmp eq i32 %3141, 0, !dbg !1096
  %is_inf797 = and i1 %3140, %3142, !dbg !1096
  %3143 = bitcast float %2950 to i32, !dbg !1096
  %3144 = and i32 %3143, 2147483647, !dbg !1096
  %is_zero798 = icmp eq i32 %3144, 0, !dbg !1096
  %3145 = and i1 %is_inf797, %is_zero798, !dbg !1096
  %3146 = or i1 %3137, %3145, !dbg !1096
  %3147 = or i1 %3129, %3146, !dbg !1096
  br i1 %3147, label %3148, label %3150, !dbg !1096

3148:                                             ; preds = %3111
  %3149 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3150, !dbg !1096

3150:                                             ; preds = %3111, %3148
  %3151 = call float @llvm.nvvm.fma.rn.f(float %3068, float %2950, float 0x3FAC6AF760000000) #5, !dbg !1096
  %3152 = bitcast float %3068 to i32, !dbg !1096
  %3153 = and i32 %3152, 2139095040, !dbg !1096
  %is_finite799 = icmp ne i32 %3153, 2139095040, !dbg !1096
  %3154 = and i1 true, %is_finite799, !dbg !1096
  %3155 = bitcast float %2950 to i32, !dbg !1096
  %3156 = and i32 %3155, 2139095040, !dbg !1096
  %is_finite800 = icmp ne i32 %3156, 2139095040, !dbg !1096
  %3157 = and i1 %3154, %is_finite800, !dbg !1096
  %3158 = bitcast float %3151 to i32, !dbg !1096
  %3159 = and i32 %3158, 2139095040, !dbg !1096
  %3160 = icmp eq i32 %3159, 2139095040, !dbg !1096
  %3161 = and i32 %3158, 8388607, !dbg !1096
  %3162 = icmp eq i32 %3161, 0, !dbg !1096
  %is_inf801 = and i1 %3160, %3162, !dbg !1096
  %3163 = bitcast float %3151 to i32, !dbg !1096
  %3164 = and i32 %3163, 2147483647, !dbg !1096
  %is_maxfinite802 = icmp eq i32 %3164, 2139095039, !dbg !1096
  %3165 = bitcast float %3151 to i32, !dbg !1096
  %3166 = and i32 %3165, -2147483648, !dbg !1096
  %3167 = icmp eq i32 %3166, 0, !dbg !1096
  %3168 = icmp ne i32 %3166, 0, !dbg !1096
  %is_pos_inf803 = and i1 %is_inf801, %3167, !dbg !1096
  %is_neg_inf804 = and i1 %is_inf801, %3168, !dbg !1096
  %is_pos_max805 = and i1 %is_maxfinite802, %3167, !dbg !1096
  %is_neg_max806 = and i1 %is_maxfinite802, %3168, !dbg !1096
  %overflow_cond807 = and i1 %3157, %is_inf801, !dbg !1096
  br i1 %overflow_cond807, label %3169, label %3171, !dbg !1096

3169:                                             ; preds = %3150
  %3170 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3171, !dbg !1096

3171:                                             ; preds = %3150, %3169
  %3172 = bitcast float %3068 to i32, !dbg !1096
  %3173 = and i32 %3172, 2139095040, !dbg !1096
  %3174 = icmp eq i32 %3173, 0, !dbg !1096
  %3175 = and i32 %3172, 8388607, !dbg !1096
  %3176 = icmp ne i32 %3175, 0, !dbg !1096
  %is_subnormal808 = and i1 %3174, %3176, !dbg !1096
  %3177 = xor i1 %is_subnormal808, true, !dbg !1096
  %3178 = and i1 true, %3177, !dbg !1096
  %3179 = bitcast float %2950 to i32, !dbg !1096
  %3180 = and i32 %3179, 2139095040, !dbg !1096
  %3181 = icmp eq i32 %3180, 0, !dbg !1096
  %3182 = and i32 %3179, 8388607, !dbg !1096
  %3183 = icmp ne i32 %3182, 0, !dbg !1096
  %is_subnormal809 = and i1 %3181, %3183, !dbg !1096
  %3184 = xor i1 %is_subnormal809, true, !dbg !1096
  %3185 = and i1 %3178, %3184, !dbg !1096
  %3186 = and i1 %3185, true, !dbg !1096
  %3187 = bitcast float %3151 to i32, !dbg !1096
  %3188 = and i32 %3187, 2139095040, !dbg !1096
  %3189 = icmp eq i32 %3188, 0, !dbg !1096
  %3190 = and i32 %3187, 8388607, !dbg !1096
  %3191 = icmp ne i32 %3190, 0, !dbg !1096
  %is_subnormal810 = and i1 %3189, %3191, !dbg !1096
  %is_tiny811 = or i1 %is_subnormal810, false, !dbg !1096
  %underflow_cond812 = and i1 %3186, %is_tiny811, !dbg !1096
  br i1 %underflow_cond812, label %3192, label %3194, !dbg !1096

3192:                                             ; preds = %3171
  %3193 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3194, !dbg !1096

3194:                                             ; preds = %3171, %3192
  %3195 = bitcast float %3151 to i32, !dbg !1096
  %3196 = bitcast float %3151 to i32, !dbg !1096
  %3197 = and i32 %3196, 2139095040, !dbg !1096
  %3198 = icmp eq i32 %3197, 2139095040, !dbg !1096
  %3199 = and i32 %3196, 8388607, !dbg !1096
  %3200 = icmp ne i32 %3199, 0, !dbg !1096
  %is_nan813 = and i1 %3198, %3200, !dbg !1096
  %3201 = and i32 %3195, 4194304, !dbg !1096
  %3202 = icmp eq i32 %3201, 0, !dbg !1096
  %is_snan814 = and i1 %is_nan813, %3202, !dbg !1096
  %3203 = bitcast float %2950 to i32, !dbg !1096
  %3204 = bitcast float %2950 to i32, !dbg !1096
  %3205 = and i32 %3204, 2139095040, !dbg !1096
  %3206 = icmp eq i32 %3205, 2139095040, !dbg !1096
  %3207 = and i32 %3204, 8388607, !dbg !1096
  %3208 = icmp ne i32 %3207, 0, !dbg !1096
  %is_nan815 = and i1 %3206, %3208, !dbg !1096
  %3209 = and i32 %3203, 4194304, !dbg !1096
  %3210 = icmp eq i32 %3209, 0, !dbg !1096
  %is_snan816 = and i1 %is_nan815, %3210, !dbg !1096
  %3211 = or i1 %is_snan814, %is_snan816, !dbg !1096
  %3212 = or i1 %3211, false, !dbg !1096
  %3213 = bitcast float %3151 to i32, !dbg !1096
  %3214 = and i32 %3213, 2147483647, !dbg !1096
  %is_zero817 = icmp eq i32 %3214, 0, !dbg !1096
  %3215 = bitcast float %2950 to i32, !dbg !1096
  %3216 = and i32 %3215, 2139095040, !dbg !1096
  %3217 = icmp eq i32 %3216, 2139095040, !dbg !1096
  %3218 = and i32 %3215, 8388607, !dbg !1096
  %3219 = icmp eq i32 %3218, 0, !dbg !1096
  %is_inf818 = and i1 %3217, %3219, !dbg !1096
  %3220 = and i1 %is_zero817, %is_inf818, !dbg !1096
  %3221 = bitcast float %3151 to i32, !dbg !1096
  %3222 = and i32 %3221, 2139095040, !dbg !1096
  %3223 = icmp eq i32 %3222, 2139095040, !dbg !1096
  %3224 = and i32 %3221, 8388607, !dbg !1096
  %3225 = icmp eq i32 %3224, 0, !dbg !1096
  %is_inf819 = and i1 %3223, %3225, !dbg !1096
  %3226 = bitcast float %2950 to i32, !dbg !1096
  %3227 = and i32 %3226, 2147483647, !dbg !1096
  %is_zero820 = icmp eq i32 %3227, 0, !dbg !1096
  %3228 = and i1 %is_inf819, %is_zero820, !dbg !1096
  %3229 = or i1 %3220, %3228, !dbg !1096
  %3230 = or i1 %3212, %3229, !dbg !1096
  br i1 %3230, label %3231, label %3233, !dbg !1096

3231:                                             ; preds = %3194
  %3232 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3233, !dbg !1096

3233:                                             ; preds = %3194, %3231
  %3234 = call float @llvm.nvvm.fma.rn.f(float %3151, float %2950, float 0x3FCEBFBD80000000) #5, !dbg !1096
  %3235 = bitcast float %3151 to i32, !dbg !1096
  %3236 = and i32 %3235, 2139095040, !dbg !1096
  %is_finite821 = icmp ne i32 %3236, 2139095040, !dbg !1096
  %3237 = and i1 true, %is_finite821, !dbg !1096
  %3238 = bitcast float %2950 to i32, !dbg !1096
  %3239 = and i32 %3238, 2139095040, !dbg !1096
  %is_finite822 = icmp ne i32 %3239, 2139095040, !dbg !1096
  %3240 = and i1 %3237, %is_finite822, !dbg !1096
  %3241 = bitcast float %3234 to i32, !dbg !1096
  %3242 = and i32 %3241, 2139095040, !dbg !1096
  %3243 = icmp eq i32 %3242, 2139095040, !dbg !1096
  %3244 = and i32 %3241, 8388607, !dbg !1096
  %3245 = icmp eq i32 %3244, 0, !dbg !1096
  %is_inf823 = and i1 %3243, %3245, !dbg !1096
  %3246 = bitcast float %3234 to i32, !dbg !1096
  %3247 = and i32 %3246, 2147483647, !dbg !1096
  %is_maxfinite824 = icmp eq i32 %3247, 2139095039, !dbg !1096
  %3248 = bitcast float %3234 to i32, !dbg !1096
  %3249 = and i32 %3248, -2147483648, !dbg !1096
  %3250 = icmp eq i32 %3249, 0, !dbg !1096
  %3251 = icmp ne i32 %3249, 0, !dbg !1096
  %is_pos_inf825 = and i1 %is_inf823, %3250, !dbg !1096
  %is_neg_inf826 = and i1 %is_inf823, %3251, !dbg !1096
  %is_pos_max827 = and i1 %is_maxfinite824, %3250, !dbg !1096
  %is_neg_max828 = and i1 %is_maxfinite824, %3251, !dbg !1096
  %overflow_cond829 = and i1 %3240, %is_inf823, !dbg !1096
  br i1 %overflow_cond829, label %3252, label %3254, !dbg !1096

3252:                                             ; preds = %3233
  %3253 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3254, !dbg !1096

3254:                                             ; preds = %3233, %3252
  %3255 = bitcast float %3151 to i32, !dbg !1096
  %3256 = and i32 %3255, 2139095040, !dbg !1096
  %3257 = icmp eq i32 %3256, 0, !dbg !1096
  %3258 = and i32 %3255, 8388607, !dbg !1096
  %3259 = icmp ne i32 %3258, 0, !dbg !1096
  %is_subnormal830 = and i1 %3257, %3259, !dbg !1096
  %3260 = xor i1 %is_subnormal830, true, !dbg !1096
  %3261 = and i1 true, %3260, !dbg !1096
  %3262 = bitcast float %2950 to i32, !dbg !1096
  %3263 = and i32 %3262, 2139095040, !dbg !1096
  %3264 = icmp eq i32 %3263, 0, !dbg !1096
  %3265 = and i32 %3262, 8388607, !dbg !1096
  %3266 = icmp ne i32 %3265, 0, !dbg !1096
  %is_subnormal831 = and i1 %3264, %3266, !dbg !1096
  %3267 = xor i1 %is_subnormal831, true, !dbg !1096
  %3268 = and i1 %3261, %3267, !dbg !1096
  %3269 = and i1 %3268, true, !dbg !1096
  %3270 = bitcast float %3234 to i32, !dbg !1096
  %3271 = and i32 %3270, 2139095040, !dbg !1096
  %3272 = icmp eq i32 %3271, 0, !dbg !1096
  %3273 = and i32 %3270, 8388607, !dbg !1096
  %3274 = icmp ne i32 %3273, 0, !dbg !1096
  %is_subnormal832 = and i1 %3272, %3274, !dbg !1096
  %is_tiny833 = or i1 %is_subnormal832, false, !dbg !1096
  %underflow_cond834 = and i1 %3269, %is_tiny833, !dbg !1096
  br i1 %underflow_cond834, label %3275, label %3277, !dbg !1096

3275:                                             ; preds = %3254
  %3276 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3277, !dbg !1096

3277:                                             ; preds = %3254, %3275
  %3278 = bitcast float %3234 to i32, !dbg !1096
  %3279 = bitcast float %3234 to i32, !dbg !1096
  %3280 = and i32 %3279, 2139095040, !dbg !1096
  %3281 = icmp eq i32 %3280, 2139095040, !dbg !1096
  %3282 = and i32 %3279, 8388607, !dbg !1096
  %3283 = icmp ne i32 %3282, 0, !dbg !1096
  %is_nan835 = and i1 %3281, %3283, !dbg !1096
  %3284 = and i32 %3278, 4194304, !dbg !1096
  %3285 = icmp eq i32 %3284, 0, !dbg !1096
  %is_snan836 = and i1 %is_nan835, %3285, !dbg !1096
  %3286 = bitcast float %2950 to i32, !dbg !1096
  %3287 = bitcast float %2950 to i32, !dbg !1096
  %3288 = and i32 %3287, 2139095040, !dbg !1096
  %3289 = icmp eq i32 %3288, 2139095040, !dbg !1096
  %3290 = and i32 %3287, 8388607, !dbg !1096
  %3291 = icmp ne i32 %3290, 0, !dbg !1096
  %is_nan837 = and i1 %3289, %3291, !dbg !1096
  %3292 = and i32 %3286, 4194304, !dbg !1096
  %3293 = icmp eq i32 %3292, 0, !dbg !1096
  %is_snan838 = and i1 %is_nan837, %3293, !dbg !1096
  %3294 = or i1 %is_snan836, %is_snan838, !dbg !1096
  %3295 = or i1 %3294, false, !dbg !1096
  %3296 = bitcast float %3234 to i32, !dbg !1096
  %3297 = and i32 %3296, 2147483647, !dbg !1096
  %is_zero839 = icmp eq i32 %3297, 0, !dbg !1096
  %3298 = bitcast float %2950 to i32, !dbg !1096
  %3299 = and i32 %3298, 2139095040, !dbg !1096
  %3300 = icmp eq i32 %3299, 2139095040, !dbg !1096
  %3301 = and i32 %3298, 8388607, !dbg !1096
  %3302 = icmp eq i32 %3301, 0, !dbg !1096
  %is_inf840 = and i1 %3300, %3302, !dbg !1096
  %3303 = and i1 %is_zero839, %is_inf840, !dbg !1096
  %3304 = bitcast float %3234 to i32, !dbg !1096
  %3305 = and i32 %3304, 2139095040, !dbg !1096
  %3306 = icmp eq i32 %3305, 2139095040, !dbg !1096
  %3307 = and i32 %3304, 8388607, !dbg !1096
  %3308 = icmp eq i32 %3307, 0, !dbg !1096
  %is_inf841 = and i1 %3306, %3308, !dbg !1096
  %3309 = bitcast float %2950 to i32, !dbg !1096
  %3310 = and i32 %3309, 2147483647, !dbg !1096
  %is_zero842 = icmp eq i32 %3310, 0, !dbg !1096
  %3311 = and i1 %is_inf841, %is_zero842, !dbg !1096
  %3312 = or i1 %3303, %3311, !dbg !1096
  %3313 = or i1 %3295, %3312, !dbg !1096
  br i1 %3313, label %3314, label %3316, !dbg !1096

3314:                                             ; preds = %3277
  %3315 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3316, !dbg !1096

3316:                                             ; preds = %3277, %3314
  %3317 = call float @llvm.nvvm.fma.rn.f(float %3234, float %2950, float 0x3FE62E4300000000) #5, !dbg !1096
  %3318 = bitcast float %3234 to i32, !dbg !1096
  %3319 = and i32 %3318, 2139095040, !dbg !1096
  %is_finite843 = icmp ne i32 %3319, 2139095040, !dbg !1096
  %3320 = and i1 true, %is_finite843, !dbg !1096
  %3321 = bitcast float %2950 to i32, !dbg !1096
  %3322 = and i32 %3321, 2139095040, !dbg !1096
  %is_finite844 = icmp ne i32 %3322, 2139095040, !dbg !1096
  %3323 = and i1 %3320, %is_finite844, !dbg !1096
  %3324 = bitcast float %3317 to i32, !dbg !1096
  %3325 = and i32 %3324, 2139095040, !dbg !1096
  %3326 = icmp eq i32 %3325, 2139095040, !dbg !1096
  %3327 = and i32 %3324, 8388607, !dbg !1096
  %3328 = icmp eq i32 %3327, 0, !dbg !1096
  %is_inf845 = and i1 %3326, %3328, !dbg !1096
  %3329 = bitcast float %3317 to i32, !dbg !1096
  %3330 = and i32 %3329, 2147483647, !dbg !1096
  %is_maxfinite846 = icmp eq i32 %3330, 2139095039, !dbg !1096
  %3331 = bitcast float %3317 to i32, !dbg !1096
  %3332 = and i32 %3331, -2147483648, !dbg !1096
  %3333 = icmp eq i32 %3332, 0, !dbg !1096
  %3334 = icmp ne i32 %3332, 0, !dbg !1096
  %is_pos_inf847 = and i1 %is_inf845, %3333, !dbg !1096
  %is_neg_inf848 = and i1 %is_inf845, %3334, !dbg !1096
  %is_pos_max849 = and i1 %is_maxfinite846, %3333, !dbg !1096
  %is_neg_max850 = and i1 %is_maxfinite846, %3334, !dbg !1096
  %overflow_cond851 = and i1 %3323, %is_inf845, !dbg !1096
  br i1 %overflow_cond851, label %3335, label %3337, !dbg !1096

3335:                                             ; preds = %3316
  %3336 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3337, !dbg !1096

3337:                                             ; preds = %3316, %3335
  %3338 = bitcast float %3234 to i32, !dbg !1096
  %3339 = and i32 %3338, 2139095040, !dbg !1096
  %3340 = icmp eq i32 %3339, 0, !dbg !1096
  %3341 = and i32 %3338, 8388607, !dbg !1096
  %3342 = icmp ne i32 %3341, 0, !dbg !1096
  %is_subnormal852 = and i1 %3340, %3342, !dbg !1096
  %3343 = xor i1 %is_subnormal852, true, !dbg !1096
  %3344 = and i1 true, %3343, !dbg !1096
  %3345 = bitcast float %2950 to i32, !dbg !1096
  %3346 = and i32 %3345, 2139095040, !dbg !1096
  %3347 = icmp eq i32 %3346, 0, !dbg !1096
  %3348 = and i32 %3345, 8388607, !dbg !1096
  %3349 = icmp ne i32 %3348, 0, !dbg !1096
  %is_subnormal853 = and i1 %3347, %3349, !dbg !1096
  %3350 = xor i1 %is_subnormal853, true, !dbg !1096
  %3351 = and i1 %3344, %3350, !dbg !1096
  %3352 = and i1 %3351, true, !dbg !1096
  %3353 = bitcast float %3317 to i32, !dbg !1096
  %3354 = and i32 %3353, 2139095040, !dbg !1096
  %3355 = icmp eq i32 %3354, 0, !dbg !1096
  %3356 = and i32 %3353, 8388607, !dbg !1096
  %3357 = icmp ne i32 %3356, 0, !dbg !1096
  %is_subnormal854 = and i1 %3355, %3357, !dbg !1096
  %is_tiny855 = or i1 %is_subnormal854, false, !dbg !1096
  %underflow_cond856 = and i1 %3352, %is_tiny855, !dbg !1096
  br i1 %underflow_cond856, label %3358, label %3360, !dbg !1096

3358:                                             ; preds = %3337
  %3359 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3360, !dbg !1096

3360:                                             ; preds = %3337, %3358
  %3361 = bitcast float %3317 to i32, !dbg !1096
  %3362 = bitcast float %3317 to i32, !dbg !1096
  %3363 = and i32 %3362, 2139095040, !dbg !1096
  %3364 = icmp eq i32 %3363, 2139095040, !dbg !1096
  %3365 = and i32 %3362, 8388607, !dbg !1096
  %3366 = icmp ne i32 %3365, 0, !dbg !1096
  %is_nan857 = and i1 %3364, %3366, !dbg !1096
  %3367 = and i32 %3361, 4194304, !dbg !1096
  %3368 = icmp eq i32 %3367, 0, !dbg !1096
  %is_snan858 = and i1 %is_nan857, %3368, !dbg !1096
  %3369 = bitcast float %2950 to i32, !dbg !1096
  %3370 = bitcast float %2950 to i32, !dbg !1096
  %3371 = and i32 %3370, 2139095040, !dbg !1096
  %3372 = icmp eq i32 %3371, 2139095040, !dbg !1096
  %3373 = and i32 %3370, 8388607, !dbg !1096
  %3374 = icmp ne i32 %3373, 0, !dbg !1096
  %is_nan859 = and i1 %3372, %3374, !dbg !1096
  %3375 = and i32 %3369, 4194304, !dbg !1096
  %3376 = icmp eq i32 %3375, 0, !dbg !1096
  %is_snan860 = and i1 %is_nan859, %3376, !dbg !1096
  %3377 = or i1 %is_snan858, %is_snan860, !dbg !1096
  %3378 = or i1 %3377, false, !dbg !1096
  %3379 = bitcast float %3317 to i32, !dbg !1096
  %3380 = and i32 %3379, 2147483647, !dbg !1096
  %is_zero861 = icmp eq i32 %3380, 0, !dbg !1096
  %3381 = bitcast float %2950 to i32, !dbg !1096
  %3382 = and i32 %3381, 2139095040, !dbg !1096
  %3383 = icmp eq i32 %3382, 2139095040, !dbg !1096
  %3384 = and i32 %3381, 8388607, !dbg !1096
  %3385 = icmp eq i32 %3384, 0, !dbg !1096
  %is_inf862 = and i1 %3383, %3385, !dbg !1096
  %3386 = and i1 %is_zero861, %is_inf862, !dbg !1096
  %3387 = bitcast float %3317 to i32, !dbg !1096
  %3388 = and i32 %3387, 2139095040, !dbg !1096
  %3389 = icmp eq i32 %3388, 2139095040, !dbg !1096
  %3390 = and i32 %3387, 8388607, !dbg !1096
  %3391 = icmp eq i32 %3390, 0, !dbg !1096
  %is_inf863 = and i1 %3389, %3391, !dbg !1096
  %3392 = bitcast float %2950 to i32, !dbg !1096
  %3393 = and i32 %3392, 2147483647, !dbg !1096
  %is_zero864 = icmp eq i32 %3393, 0, !dbg !1096
  %3394 = and i1 %is_inf863, %is_zero864, !dbg !1096
  %3395 = or i1 %3386, %3394, !dbg !1096
  %3396 = or i1 %3378, %3395, !dbg !1096
  br i1 %3396, label %3397, label %3399, !dbg !1096

3397:                                             ; preds = %3360
  %3398 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3399, !dbg !1096

3399:                                             ; preds = %3360, %3397
  %3400 = call float @llvm.nvvm.fma.rn.f(float %3317, float %2950, float 1.000000e+00) #5, !dbg !1096
  %3401 = bitcast float %3317 to i32, !dbg !1096
  %3402 = and i32 %3401, 2139095040, !dbg !1096
  %is_finite865 = icmp ne i32 %3402, 2139095040, !dbg !1096
  %3403 = and i1 true, %is_finite865, !dbg !1096
  %3404 = bitcast float %2950 to i32, !dbg !1096
  %3405 = and i32 %3404, 2139095040, !dbg !1096
  %is_finite866 = icmp ne i32 %3405, 2139095040, !dbg !1096
  %3406 = and i1 %3403, %is_finite866, !dbg !1096
  %3407 = bitcast float %3400 to i32, !dbg !1096
  %3408 = and i32 %3407, 2139095040, !dbg !1096
  %3409 = icmp eq i32 %3408, 2139095040, !dbg !1096
  %3410 = and i32 %3407, 8388607, !dbg !1096
  %3411 = icmp eq i32 %3410, 0, !dbg !1096
  %is_inf867 = and i1 %3409, %3411, !dbg !1096
  %3412 = bitcast float %3400 to i32, !dbg !1096
  %3413 = and i32 %3412, 2147483647, !dbg !1096
  %is_maxfinite868 = icmp eq i32 %3413, 2139095039, !dbg !1096
  %3414 = bitcast float %3400 to i32, !dbg !1096
  %3415 = and i32 %3414, -2147483648, !dbg !1096
  %3416 = icmp eq i32 %3415, 0, !dbg !1096
  %3417 = icmp ne i32 %3415, 0, !dbg !1096
  %is_pos_inf869 = and i1 %is_inf867, %3416, !dbg !1096
  %is_neg_inf870 = and i1 %is_inf867, %3417, !dbg !1096
  %is_pos_max871 = and i1 %is_maxfinite868, %3416, !dbg !1096
  %is_neg_max872 = and i1 %is_maxfinite868, %3417, !dbg !1096
  %overflow_cond873 = and i1 %3406, %is_inf867, !dbg !1096
  br i1 %overflow_cond873, label %3418, label %3420, !dbg !1096

3418:                                             ; preds = %3399
  %3419 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3420, !dbg !1096

3420:                                             ; preds = %3399, %3418
  %3421 = bitcast float %3317 to i32, !dbg !1096
  %3422 = and i32 %3421, 2139095040, !dbg !1096
  %3423 = icmp eq i32 %3422, 0, !dbg !1096
  %3424 = and i32 %3421, 8388607, !dbg !1096
  %3425 = icmp ne i32 %3424, 0, !dbg !1096
  %is_subnormal874 = and i1 %3423, %3425, !dbg !1096
  %3426 = xor i1 %is_subnormal874, true, !dbg !1096
  %3427 = and i1 true, %3426, !dbg !1096
  %3428 = bitcast float %2950 to i32, !dbg !1096
  %3429 = and i32 %3428, 2139095040, !dbg !1096
  %3430 = icmp eq i32 %3429, 0, !dbg !1096
  %3431 = and i32 %3428, 8388607, !dbg !1096
  %3432 = icmp ne i32 %3431, 0, !dbg !1096
  %is_subnormal875 = and i1 %3430, %3432, !dbg !1096
  %3433 = xor i1 %is_subnormal875, true, !dbg !1096
  %3434 = and i1 %3427, %3433, !dbg !1096
  %3435 = and i1 %3434, true, !dbg !1096
  %3436 = bitcast float %3400 to i32, !dbg !1096
  %3437 = and i32 %3436, 2139095040, !dbg !1096
  %3438 = icmp eq i32 %3437, 0, !dbg !1096
  %3439 = and i32 %3436, 8388607, !dbg !1096
  %3440 = icmp ne i32 %3439, 0, !dbg !1096
  %is_subnormal876 = and i1 %3438, %3440, !dbg !1096
  %is_tiny877 = or i1 %is_subnormal876, false, !dbg !1096
  %underflow_cond878 = and i1 %3435, %is_tiny877, !dbg !1096
  br i1 %underflow_cond878, label %3441, label %3443, !dbg !1096

3441:                                             ; preds = %3420
  %3442 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3443, !dbg !1096

3443:                                             ; preds = %3420, %3441
  %3444 = fptosi float %2852 to i32, !dbg !1096
  %3445 = fcmp ogt float %2852, 0.000000e+00, !dbg !1096
  %3446 = select i1 %3445, i32 0, i32 -2097152000, !dbg !1096
  %3447 = add i32 2130706432, %3446, !dbg !1096
  %3448 = bitcast i32 %3447 to float, !dbg !1096
  %3449 = bitcast float %3400 to i32, !dbg !1096
  %3450 = bitcast float %3400 to i32, !dbg !1096
  %3451 = and i32 %3450, 2139095040, !dbg !1096
  %3452 = icmp eq i32 %3451, 2139095040, !dbg !1096
  %3453 = and i32 %3450, 8388607, !dbg !1096
  %3454 = icmp ne i32 %3453, 0, !dbg !1096
  %is_nan879 = and i1 %3452, %3454, !dbg !1096
  %3455 = and i32 %3449, 4194304, !dbg !1096
  %3456 = icmp eq i32 %3455, 0, !dbg !1096
  %is_snan880 = and i1 %is_nan879, %3456, !dbg !1096
  %3457 = bitcast float %3448 to i32, !dbg !1096
  %3458 = bitcast float %3448 to i32, !dbg !1096
  %3459 = and i32 %3458, 2139095040, !dbg !1096
  %3460 = icmp eq i32 %3459, 2139095040, !dbg !1096
  %3461 = and i32 %3458, 8388607, !dbg !1096
  %3462 = icmp ne i32 %3461, 0, !dbg !1096
  %is_nan881 = and i1 %3460, %3462, !dbg !1096
  %3463 = and i32 %3457, 4194304, !dbg !1096
  %3464 = icmp eq i32 %3463, 0, !dbg !1096
  %is_snan882 = and i1 %is_nan881, %3464, !dbg !1096
  %3465 = or i1 %is_snan880, %is_snan882, !dbg !1096
  %3466 = bitcast float %3400 to i32, !dbg !1096
  %3467 = and i32 %3466, 2147483647, !dbg !1096
  %is_zero883 = icmp eq i32 %3467, 0, !dbg !1096
  %3468 = bitcast float %3448 to i32, !dbg !1096
  %3469 = and i32 %3468, 2139095040, !dbg !1096
  %3470 = icmp eq i32 %3469, 2139095040, !dbg !1096
  %3471 = and i32 %3468, 8388607, !dbg !1096
  %3472 = icmp eq i32 %3471, 0, !dbg !1096
  %is_inf884 = and i1 %3470, %3472, !dbg !1096
  %3473 = and i1 %is_zero883, %is_inf884, !dbg !1096
  %3474 = bitcast float %3400 to i32, !dbg !1096
  %3475 = and i32 %3474, 2139095040, !dbg !1096
  %3476 = icmp eq i32 %3475, 2139095040, !dbg !1096
  %3477 = and i32 %3474, 8388607, !dbg !1096
  %3478 = icmp eq i32 %3477, 0, !dbg !1096
  %is_inf885 = and i1 %3476, %3478, !dbg !1096
  %3479 = bitcast float %3448 to i32, !dbg !1096
  %3480 = and i32 %3479, 2147483647, !dbg !1096
  %is_zero886 = icmp eq i32 %3480, 0, !dbg !1096
  %3481 = and i1 %is_inf885, %is_zero886, !dbg !1096
  %3482 = or i1 %3473, %3481, !dbg !1096
  %3483 = or i1 %3465, %3482, !dbg !1096
  br i1 %3483, label %3484, label %3486, !dbg !1096

3484:                                             ; preds = %3443
  %3485 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3486, !dbg !1096

3486:                                             ; preds = %3443, %3484
  %3487 = fmul float %3400, %3448, !dbg !1096
  %3488 = bitcast float %3400 to i32, !dbg !1096
  %3489 = and i32 %3488, 2139095040, !dbg !1096
  %is_finite887 = icmp ne i32 %3489, 2139095040, !dbg !1096
  %3490 = and i1 true, %is_finite887, !dbg !1096
  %3491 = bitcast float %3448 to i32, !dbg !1096
  %3492 = and i32 %3491, 2139095040, !dbg !1096
  %is_finite888 = icmp ne i32 %3492, 2139095040, !dbg !1096
  %3493 = and i1 %3490, %is_finite888, !dbg !1096
  %3494 = bitcast float %3487 to i32, !dbg !1096
  %3495 = and i32 %3494, 2139095040, !dbg !1096
  %3496 = icmp eq i32 %3495, 2139095040, !dbg !1096
  %3497 = and i32 %3494, 8388607, !dbg !1096
  %3498 = icmp eq i32 %3497, 0, !dbg !1096
  %is_inf889 = and i1 %3496, %3498, !dbg !1096
  %3499 = bitcast float %3487 to i32, !dbg !1096
  %3500 = and i32 %3499, 2147483647, !dbg !1096
  %is_maxfinite890 = icmp eq i32 %3500, 2139095039, !dbg !1096
  %3501 = bitcast float %3487 to i32, !dbg !1096
  %3502 = and i32 %3501, -2147483648, !dbg !1096
  %3503 = icmp eq i32 %3502, 0, !dbg !1096
  %3504 = icmp ne i32 %3502, 0, !dbg !1096
  %is_pos_inf891 = and i1 %is_inf889, %3503, !dbg !1096
  %is_neg_inf892 = and i1 %is_inf889, %3504, !dbg !1096
  %is_pos_max893 = and i1 %is_maxfinite890, %3503, !dbg !1096
  %is_neg_max894 = and i1 %is_maxfinite890, %3504, !dbg !1096
  %overflow_cond895 = and i1 %3493, %is_inf889, !dbg !1096
  br i1 %overflow_cond895, label %3505, label %3507, !dbg !1096

3505:                                             ; preds = %3486
  %3506 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3507, !dbg !1096

3507:                                             ; preds = %3486, %3505
  %3508 = bitcast float %3400 to i32, !dbg !1096
  %3509 = and i32 %3508, 2139095040, !dbg !1096
  %3510 = icmp eq i32 %3509, 0, !dbg !1096
  %3511 = and i32 %3508, 8388607, !dbg !1096
  %3512 = icmp ne i32 %3511, 0, !dbg !1096
  %is_subnormal896 = and i1 %3510, %3512, !dbg !1096
  %3513 = xor i1 %is_subnormal896, true, !dbg !1096
  %3514 = and i1 true, %3513, !dbg !1096
  %3515 = bitcast float %3448 to i32, !dbg !1096
  %3516 = and i32 %3515, 2139095040, !dbg !1096
  %3517 = icmp eq i32 %3516, 0, !dbg !1096
  %3518 = and i32 %3515, 8388607, !dbg !1096
  %3519 = icmp ne i32 %3518, 0, !dbg !1096
  %is_subnormal897 = and i1 %3517, %3519, !dbg !1096
  %3520 = xor i1 %is_subnormal897, true, !dbg !1096
  %3521 = and i1 %3514, %3520, !dbg !1096
  %3522 = bitcast float %3487 to i32, !dbg !1096
  %3523 = and i32 %3522, 2139095040, !dbg !1096
  %3524 = icmp eq i32 %3523, 0, !dbg !1096
  %3525 = and i32 %3522, 8388607, !dbg !1096
  %3526 = icmp ne i32 %3525, 0, !dbg !1096
  %is_subnormal898 = and i1 %3524, %3526, !dbg !1096
  %3527 = bitcast float %3487 to i32, !dbg !1096
  %3528 = and i32 %3527, 2147483647, !dbg !1096
  %is_zero899 = icmp eq i32 %3528, 0, !dbg !1096
  %3529 = bitcast float %3400 to i32, !dbg !1096
  %3530 = and i32 %3529, 2147483647, !dbg !1096
  %is_zero900 = icmp eq i32 %3530, 0, !dbg !1096
  %3531 = xor i1 %is_zero900, true, !dbg !1096
  %3532 = bitcast float %3448 to i32, !dbg !1096
  %3533 = and i32 %3532, 2147483647, !dbg !1096
  %is_zero901 = icmp eq i32 %3533, 0, !dbg !1096
  %3534 = xor i1 %is_zero901, true, !dbg !1096
  %3535 = and i1 %3531, %3534, !dbg !1096
  %3536 = and i1 %is_zero899, %3535, !dbg !1096
  %is_tiny902 = or i1 %is_subnormal898, %3536, !dbg !1096
  %underflow_cond903 = and i1 %3521, %is_tiny902, !dbg !1096
  br i1 %underflow_cond903, label %3537, label %3539, !dbg !1096

3537:                                             ; preds = %3507
  %3538 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3539, !dbg !1096

3539:                                             ; preds = %3507, %3537
  %3540 = shl i32 %3444, 23, !dbg !1096
  %3541 = sub i32 %3540, %3446, !dbg !1096
  %3542 = bitcast i32 %3541 to float, !dbg !1096
  %3543 = bitcast float %3487 to i32, !dbg !1096
  %3544 = bitcast float %3487 to i32, !dbg !1096
  %3545 = and i32 %3544, 2139095040, !dbg !1096
  %3546 = icmp eq i32 %3545, 2139095040, !dbg !1096
  %3547 = and i32 %3544, 8388607, !dbg !1096
  %3548 = icmp ne i32 %3547, 0, !dbg !1096
  %is_nan904 = and i1 %3546, %3548, !dbg !1096
  %3549 = and i32 %3543, 4194304, !dbg !1096
  %3550 = icmp eq i32 %3549, 0, !dbg !1096
  %is_snan905 = and i1 %is_nan904, %3550, !dbg !1096
  %3551 = bitcast float %3542 to i32, !dbg !1096
  %3552 = bitcast float %3542 to i32, !dbg !1096
  %3553 = and i32 %3552, 2139095040, !dbg !1096
  %3554 = icmp eq i32 %3553, 2139095040, !dbg !1096
  %3555 = and i32 %3552, 8388607, !dbg !1096
  %3556 = icmp ne i32 %3555, 0, !dbg !1096
  %is_nan906 = and i1 %3554, %3556, !dbg !1096
  %3557 = and i32 %3551, 4194304, !dbg !1096
  %3558 = icmp eq i32 %3557, 0, !dbg !1096
  %is_snan907 = and i1 %is_nan906, %3558, !dbg !1096
  %3559 = or i1 %is_snan905, %is_snan907, !dbg !1096
  %3560 = bitcast float %3487 to i32, !dbg !1096
  %3561 = and i32 %3560, 2147483647, !dbg !1096
  %is_zero908 = icmp eq i32 %3561, 0, !dbg !1096
  %3562 = bitcast float %3542 to i32, !dbg !1096
  %3563 = and i32 %3562, 2139095040, !dbg !1096
  %3564 = icmp eq i32 %3563, 2139095040, !dbg !1096
  %3565 = and i32 %3562, 8388607, !dbg !1096
  %3566 = icmp eq i32 %3565, 0, !dbg !1096
  %is_inf909 = and i1 %3564, %3566, !dbg !1096
  %3567 = and i1 %is_zero908, %is_inf909, !dbg !1096
  %3568 = bitcast float %3487 to i32, !dbg !1096
  %3569 = and i32 %3568, 2139095040, !dbg !1096
  %3570 = icmp eq i32 %3569, 2139095040, !dbg !1096
  %3571 = and i32 %3568, 8388607, !dbg !1096
  %3572 = icmp eq i32 %3571, 0, !dbg !1096
  %is_inf910 = and i1 %3570, %3572, !dbg !1096
  %3573 = bitcast float %3542 to i32, !dbg !1096
  %3574 = and i32 %3573, 2147483647, !dbg !1096
  %is_zero911 = icmp eq i32 %3574, 0, !dbg !1096
  %3575 = and i1 %is_inf910, %is_zero911, !dbg !1096
  %3576 = or i1 %3567, %3575, !dbg !1096
  %3577 = or i1 %3559, %3576, !dbg !1096
  br i1 %3577, label %3578, label %3580, !dbg !1096

3578:                                             ; preds = %3539
  %3579 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3580, !dbg !1096

3580:                                             ; preds = %3539, %3578
  %3581 = fmul float %3487, %3542, !dbg !1096
  %3582 = bitcast float %3487 to i32, !dbg !1096
  %3583 = and i32 %3582, 2139095040, !dbg !1096
  %is_finite912 = icmp ne i32 %3583, 2139095040, !dbg !1096
  %3584 = and i1 true, %is_finite912, !dbg !1096
  %3585 = bitcast float %3542 to i32, !dbg !1096
  %3586 = and i32 %3585, 2139095040, !dbg !1096
  %is_finite913 = icmp ne i32 %3586, 2139095040, !dbg !1096
  %3587 = and i1 %3584, %is_finite913, !dbg !1096
  %3588 = bitcast float %3581 to i32, !dbg !1096
  %3589 = and i32 %3588, 2139095040, !dbg !1096
  %3590 = icmp eq i32 %3589, 2139095040, !dbg !1096
  %3591 = and i32 %3588, 8388607, !dbg !1096
  %3592 = icmp eq i32 %3591, 0, !dbg !1096
  %is_inf914 = and i1 %3590, %3592, !dbg !1096
  %3593 = bitcast float %3581 to i32, !dbg !1096
  %3594 = and i32 %3593, 2147483647, !dbg !1096
  %is_maxfinite915 = icmp eq i32 %3594, 2139095039, !dbg !1096
  %3595 = bitcast float %3581 to i32, !dbg !1096
  %3596 = and i32 %3595, -2147483648, !dbg !1096
  %3597 = icmp eq i32 %3596, 0, !dbg !1096
  %3598 = icmp ne i32 %3596, 0, !dbg !1096
  %is_pos_inf916 = and i1 %is_inf914, %3597, !dbg !1096
  %is_neg_inf917 = and i1 %is_inf914, %3598, !dbg !1096
  %is_pos_max918 = and i1 %is_maxfinite915, %3597, !dbg !1096
  %is_neg_max919 = and i1 %is_maxfinite915, %3598, !dbg !1096
  %overflow_cond920 = and i1 %3587, %is_inf914, !dbg !1096
  br i1 %overflow_cond920, label %3599, label %3601, !dbg !1096

3599:                                             ; preds = %3580
  %3600 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3601, !dbg !1096

3601:                                             ; preds = %3580, %3599
  %3602 = bitcast float %3487 to i32, !dbg !1096
  %3603 = and i32 %3602, 2139095040, !dbg !1096
  %3604 = icmp eq i32 %3603, 0, !dbg !1096
  %3605 = and i32 %3602, 8388607, !dbg !1096
  %3606 = icmp ne i32 %3605, 0, !dbg !1096
  %is_subnormal921 = and i1 %3604, %3606, !dbg !1096
  %3607 = xor i1 %is_subnormal921, true, !dbg !1096
  %3608 = and i1 true, %3607, !dbg !1096
  %3609 = bitcast float %3542 to i32, !dbg !1096
  %3610 = and i32 %3609, 2139095040, !dbg !1096
  %3611 = icmp eq i32 %3610, 0, !dbg !1096
  %3612 = and i32 %3609, 8388607, !dbg !1096
  %3613 = icmp ne i32 %3612, 0, !dbg !1096
  %is_subnormal922 = and i1 %3611, %3613, !dbg !1096
  %3614 = xor i1 %is_subnormal922, true, !dbg !1096
  %3615 = and i1 %3608, %3614, !dbg !1096
  %3616 = bitcast float %3581 to i32, !dbg !1096
  %3617 = and i32 %3616, 2139095040, !dbg !1096
  %3618 = icmp eq i32 %3617, 0, !dbg !1096
  %3619 = and i32 %3616, 8388607, !dbg !1096
  %3620 = icmp ne i32 %3619, 0, !dbg !1096
  %is_subnormal923 = and i1 %3618, %3620, !dbg !1096
  %3621 = bitcast float %3581 to i32, !dbg !1096
  %3622 = and i32 %3621, 2147483647, !dbg !1096
  %is_zero924 = icmp eq i32 %3622, 0, !dbg !1096
  %3623 = bitcast float %3487 to i32, !dbg !1096
  %3624 = and i32 %3623, 2147483647, !dbg !1096
  %is_zero925 = icmp eq i32 %3624, 0, !dbg !1096
  %3625 = xor i1 %is_zero925, true, !dbg !1096
  %3626 = bitcast float %3542 to i32, !dbg !1096
  %3627 = and i32 %3626, 2147483647, !dbg !1096
  %is_zero926 = icmp eq i32 %3627, 0, !dbg !1096
  %3628 = xor i1 %is_zero926, true, !dbg !1096
  %3629 = and i1 %3625, %3628, !dbg !1096
  %3630 = and i1 %is_zero924, %3629, !dbg !1096
  %is_tiny927 = or i1 %is_subnormal923, %3630, !dbg !1096
  %underflow_cond928 = and i1 %3615, %is_tiny927, !dbg !1096
  br i1 %underflow_cond928, label %3631, label %3633, !dbg !1096

3631:                                             ; preds = %3601
  %3632 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3633, !dbg !1096

3633:                                             ; preds = %3601, %3631
  %3634 = call float @llvm.nvvm.fabs.f32(float %2616), !dbg !1096
  %3635 = fcmp ogt float %3634, 1.520000e+02, !dbg !1096
  br i1 %3635, label %3636, label %__internal_accurate_powf.exit.i, !dbg !1096

3636:                                             ; preds = %3633
  %3637 = fcmp olt float %2616, 0.000000e+00, !dbg !1096
  br i1 %3637, label %3638, label %3639, !dbg !1096

3638:                                             ; preds = %3636
  br label %3640, !dbg !1096

3639:                                             ; preds = %3636
  br label %3640, !dbg !1096

3640:                                             ; preds = %3639, %3638
  %3641 = phi float [ 0.000000e+00, %3638 ], [ 0x7FF0000000000000, %3639 ], !dbg !1096
  br label %__internal_accurate_powf.exit.i, !dbg !1096

__internal_accurate_powf.exit.i:                  ; preds = %3640, %3633
  %t.i.0.i = phi float [ %3641, %3640 ], [ %3581, %3633 ], !dbg !1096
  %3642 = fcmp oeq float %762, 1.000000e+00, !dbg !1096
  br i1 %3642, label %3645, label %3643, !dbg !1096

3643:                                             ; preds = %__internal_accurate_powf.exit.i
  %3644 = fcmp oeq float %763, 0.000000e+00, !dbg !1096
  br i1 %3644, label %3645, label %3646, !dbg !1096

3645:                                             ; preds = %3643, %__internal_accurate_powf.exit.i
  br label %__nv_powf.exit, !dbg !1096

3646:                                             ; preds = %3643
  %3647 = call float @llvm.nvvm.fabs.f32(float %762), !dbg !1096
  %3648 = fcmp ole float %3647, 0x7FF0000000000000, !dbg !1096
  %3649 = xor i1 %3648, true, !dbg !1096
  %3650 = select i1 %3649, i32 1, i32 0, !dbg !1096
  br i1 %3649, label %3656, label %3651, !dbg !1096

3651:                                             ; preds = %3646
  %3652 = call float @llvm.nvvm.fabs.f32(float %763), !dbg !1096
  %3653 = fcmp ole float %3652, 0x7FF0000000000000, !dbg !1096
  %3654 = xor i1 %3653, true, !dbg !1096
  %3655 = select i1 %3654, i32 1, i32 0, !dbg !1096
  br i1 %3654, label %3656, label %3658, !dbg !1096

3656:                                             ; preds = %3651, %3646
  %3657 = call float @llvm.nvvm.add.rn.f(float %762, float %763) #5, !dbg !1096
  br label %3794, !dbg !1096

3658:                                             ; preds = %3651
  %3659 = fcmp oeq float %762, 0.000000e+00, !dbg !1096
  br i1 %3659, label %3664, label %3660, !dbg !1096

3660:                                             ; preds = %3658
  %3661 = call float @llvm.nvvm.fabs.f32(float %762), !dbg !1096
  %3662 = fcmp oeq float %3661, 0x7FF0000000000000, !dbg !1096
  %3663 = select i1 %3662, i32 1, i32 0, !dbg !1096
  br i1 %3662, label %3664, label %3734, !dbg !1096

3664:                                             ; preds = %3660, %3658
  %3665 = bitcast float %762 to i32, !dbg !1096
  %3666 = bitcast float %762 to i32, !dbg !1096
  %3667 = and i32 %3666, 2139095040, !dbg !1096
  %3668 = icmp eq i32 %3667, 2139095040, !dbg !1096
  %3669 = and i32 %3666, 8388607, !dbg !1096
  %3670 = icmp ne i32 %3669, 0, !dbg !1096
  %is_nan929 = and i1 %3668, %3670, !dbg !1096
  %3671 = and i32 %3665, 4194304, !dbg !1096
  %3672 = icmp eq i32 %3671, 0, !dbg !1096
  %is_snan930 = and i1 %is_nan929, %3672, !dbg !1096
  %3673 = bitcast float %762 to i32, !dbg !1096
  %3674 = bitcast float %762 to i32, !dbg !1096
  %3675 = and i32 %3674, 2139095040, !dbg !1096
  %3676 = icmp eq i32 %3675, 2139095040, !dbg !1096
  %3677 = and i32 %3674, 8388607, !dbg !1096
  %3678 = icmp ne i32 %3677, 0, !dbg !1096
  %is_nan931 = and i1 %3676, %3678, !dbg !1096
  %3679 = and i32 %3673, 4194304, !dbg !1096
  %3680 = icmp eq i32 %3679, 0, !dbg !1096
  %is_snan932 = and i1 %is_nan931, %3680, !dbg !1096
  %3681 = or i1 %is_snan930, %is_snan932, !dbg !1096
  %3682 = bitcast float %762 to i32, !dbg !1096
  %3683 = and i32 %3682, 2139095040, !dbg !1096
  %3684 = icmp eq i32 %3683, 2139095040, !dbg !1096
  %3685 = and i32 %3682, 8388607, !dbg !1096
  %3686 = icmp eq i32 %3685, 0, !dbg !1096
  %is_inf933 = and i1 %3684, %3686, !dbg !1096
  %3687 = bitcast float %762 to i32, !dbg !1096
  %3688 = and i32 %3687, 2139095040, !dbg !1096
  %3689 = icmp eq i32 %3688, 2139095040, !dbg !1096
  %3690 = and i32 %3687, 8388607, !dbg !1096
  %3691 = icmp eq i32 %3690, 0, !dbg !1096
  %is_inf934 = and i1 %3689, %3691, !dbg !1096
  %3692 = and i1 %is_inf933, %is_inf934, !dbg !1096
  %3693 = bitcast float %762 to i32, !dbg !1096
  %3694 = bitcast float %762 to i32, !dbg !1096
  %3695 = and i32 %3693, -2147483648, !dbg !1096
  %3696 = and i32 %3694, -2147483648, !dbg !1096
  %3697 = icmp ne i32 %3695, %3696, !dbg !1096
  %3698 = and i1 %3692, %3697, !dbg !1096
  %3699 = or i1 %3681, %3698, !dbg !1096
  br i1 %3699, label %3700, label %3702, !dbg !1096

3700:                                             ; preds = %3664
  %3701 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3702, !dbg !1096

3702:                                             ; preds = %3664, %3700
  %3703 = fadd float %762, %762, !dbg !1096
  %3704 = bitcast float %762 to i32, !dbg !1096
  %3705 = and i32 %3704, 2139095040, !dbg !1096
  %is_finite935 = icmp ne i32 %3705, 2139095040, !dbg !1096
  %3706 = and i1 true, %is_finite935, !dbg !1096
  %3707 = bitcast float %762 to i32, !dbg !1096
  %3708 = and i32 %3707, 2139095040, !dbg !1096
  %is_finite936 = icmp ne i32 %3708, 2139095040, !dbg !1096
  %3709 = and i1 %3706, %is_finite936, !dbg !1096
  %3710 = bitcast float %3703 to i32, !dbg !1096
  %3711 = and i32 %3710, 2139095040, !dbg !1096
  %3712 = icmp eq i32 %3711, 2139095040, !dbg !1096
  %3713 = and i32 %3710, 8388607, !dbg !1096
  %3714 = icmp eq i32 %3713, 0, !dbg !1096
  %is_inf937 = and i1 %3712, %3714, !dbg !1096
  %3715 = bitcast float %3703 to i32, !dbg !1096
  %3716 = and i32 %3715, 2147483647, !dbg !1096
  %is_maxfinite938 = icmp eq i32 %3716, 2139095039, !dbg !1096
  %3717 = bitcast float %3703 to i32, !dbg !1096
  %3718 = and i32 %3717, -2147483648, !dbg !1096
  %3719 = icmp eq i32 %3718, 0, !dbg !1096
  %3720 = icmp ne i32 %3718, 0, !dbg !1096
  %is_pos_inf939 = and i1 %is_inf937, %3719, !dbg !1096
  %is_neg_inf940 = and i1 %is_inf937, %3720, !dbg !1096
  %is_pos_max941 = and i1 %is_maxfinite938, %3719, !dbg !1096
  %is_neg_max942 = and i1 %is_maxfinite938, %3720, !dbg !1096
  %overflow_cond943 = and i1 %3709, %is_inf937, !dbg !1096
  br i1 %overflow_cond943, label %3721, label %3723, !dbg !1096

3721:                                             ; preds = %3702
  %3722 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3723, !dbg !1096

3723:                                             ; preds = %3702, %3721
  %3724 = bitcast float %3703 to i32, !dbg !1096
  %3725 = fcmp olt float %763, 0.000000e+00, !dbg !1096
  br i1 %3725, label %3726, label %3728, !dbg !1096

3726:                                             ; preds = %3723
  %3727 = xor i32 %3724, 2139095040, !dbg !1096
  br label %3728, !dbg !1096

3728:                                             ; preds = %3726, %3723
  %ti.i.0.i = phi i32 [ %3727, %3726 ], [ %3724, %3723 ], !dbg !1096
  %3729 = icmp eq i32 %952, 0, !dbg !1096
  br i1 %3729, label %3730, label %3732, !dbg !1096

3730:                                             ; preds = %3728
  %3731 = and i32 %ti.i.0.i, 2147483647, !dbg !1096
  br label %3732, !dbg !1096

3732:                                             ; preds = %3730, %3728
  %ti.i.1.i = phi i32 [ %3731, %3730 ], [ %ti.i.0.i, %3728 ], !dbg !1096
  %3733 = bitcast i32 %ti.i.1.i to float, !dbg !1096
  br label %3793, !dbg !1096

3734:                                             ; preds = %3660
  %3735 = fcmp oeq float %762, -1.000000e+00, !dbg !1096
  br i1 %3735, label %3736, label %3741, !dbg !1096

3736:                                             ; preds = %3734
  %3737 = call float @llvm.nvvm.fabs.f32(float %763), !dbg !1096
  %3738 = fcmp oeq float %3737, 0x7FF0000000000000, !dbg !1096
  %3739 = select i1 %3738, i32 1, i32 0, !dbg !1096
  br i1 %3738, label %3740, label %3741, !dbg !1096

3740:                                             ; preds = %3736
  br label %3792, !dbg !1096

3741:                                             ; preds = %3736, %3734
  %3742 = fcmp olt float %762, 0.000000e+00, !dbg !1096
  br i1 %3742, label %3743, label %3791, !dbg !1096

3743:                                             ; preds = %3741
  br i1 %951, label %3744, label %3786, !dbg !1096

3744:                                             ; preds = %3743
  %3745 = bitcast float %t.i.0.i to i32, !dbg !1096
  %3746 = bitcast float %t.i.0.i to i32, !dbg !1096
  %3747 = and i32 %3746, 2139095040, !dbg !1096
  %3748 = icmp eq i32 %3747, 2139095040, !dbg !1096
  %3749 = and i32 %3746, 8388607, !dbg !1096
  %3750 = icmp ne i32 %3749, 0, !dbg !1096
  %is_nan944 = and i1 %3748, %3750, !dbg !1096
  %3751 = and i32 %3745, 4194304, !dbg !1096
  %3752 = icmp eq i32 %3751, 0, !dbg !1096
  %is_snan945 = and i1 %is_nan944, %3752, !dbg !1096
  %3753 = or i1 false, %is_snan945, !dbg !1096
  %3754 = bitcast float %t.i.0.i to i32, !dbg !1096
  %3755 = and i32 %3754, 2139095040, !dbg !1096
  %3756 = icmp eq i32 %3755, 2139095040, !dbg !1096
  %3757 = and i32 %3754, 8388607, !dbg !1096
  %3758 = icmp eq i32 %3757, 0, !dbg !1096
  %is_inf946 = and i1 %3756, %3758, !dbg !1096
  %3759 = and i1 false, %is_inf946, !dbg !1096
  %3760 = bitcast float %t.i.0.i to i32, !dbg !1096
  %3761 = and i32 %3760, -2147483648, !dbg !1096
  %3762 = icmp eq i32 -2147483648, %3761, !dbg !1096
  %3763 = and i1 %3759, %3762, !dbg !1096
  %3764 = or i1 %3753, %3763, !dbg !1096
  br i1 %3764, label %3765, label %3767, !dbg !1096

3765:                                             ; preds = %3744
  %3766 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3767, !dbg !1096

3767:                                             ; preds = %3744, %3765
  %3768 = fsub float -0.000000e+00, %t.i.0.i, !dbg !1096
  %3769 = bitcast float %t.i.0.i to i32, !dbg !1096
  %3770 = and i32 %3769, 2139095040, !dbg !1096
  %is_finite947 = icmp ne i32 %3770, 2139095040, !dbg !1096
  %3771 = and i1 true, %is_finite947, !dbg !1096
  %3772 = bitcast float %3768 to i32, !dbg !1096
  %3773 = and i32 %3772, 2139095040, !dbg !1096
  %3774 = icmp eq i32 %3773, 2139095040, !dbg !1096
  %3775 = and i32 %3772, 8388607, !dbg !1096
  %3776 = icmp eq i32 %3775, 0, !dbg !1096
  %is_inf948 = and i1 %3774, %3776, !dbg !1096
  %3777 = bitcast float %3768 to i32, !dbg !1096
  %3778 = and i32 %3777, 2147483647, !dbg !1096
  %is_maxfinite949 = icmp eq i32 %3778, 2139095039, !dbg !1096
  %3779 = bitcast float %3768 to i32, !dbg !1096
  %3780 = and i32 %3779, -2147483648, !dbg !1096
  %3781 = icmp eq i32 %3780, 0, !dbg !1096
  %3782 = icmp ne i32 %3780, 0, !dbg !1096
  %is_pos_inf950 = and i1 %is_inf948, %3781, !dbg !1096
  %is_neg_inf951 = and i1 %is_inf948, %3782, !dbg !1096
  %is_pos_max952 = and i1 %is_maxfinite949, %3781, !dbg !1096
  %is_neg_max953 = and i1 %is_maxfinite949, %3782, !dbg !1096
  %overflow_cond954 = and i1 %3771, %is_inf948, !dbg !1096
  br i1 %overflow_cond954, label %3783, label %3785, !dbg !1096

3783:                                             ; preds = %3767
  %3784 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3785, !dbg !1096

3785:                                             ; preds = %3767, %3783
  br label %3786, !dbg !1096

3786:                                             ; preds = %3785, %3743
  %.01.i = phi float [ %3768, %3785 ], [ %t.i.0.i, %3743 ], !dbg !1096
  %3787 = call float @llvm.nvvm.floor.f(float %763) #5, !dbg !1096
  %3788 = fcmp une float %763, %3787, !dbg !1096
  br i1 %3788, label %3789, label %3790, !dbg !1096

3789:                                             ; preds = %3786
  br label %3790, !dbg !1096

3790:                                             ; preds = %3789, %3786
  %.1.i = phi float [ 0x7FFFFFFFE0000000, %3789 ], [ %.01.i, %3786 ], !dbg !1096
  br label %3791, !dbg !1096

3791:                                             ; preds = %3790, %3741
  %.2.i = phi float [ %.1.i, %3790 ], [ %t.i.0.i, %3741 ], !dbg !1096
  br label %3792, !dbg !1096

3792:                                             ; preds = %3791, %3740
  %.3.i = phi float [ 1.000000e+00, %3740 ], [ %.2.i, %3791 ], !dbg !1096
  br label %3793, !dbg !1096

3793:                                             ; preds = %3792, %3732
  %.4.i = phi float [ %3733, %3732 ], [ %.3.i, %3792 ], !dbg !1096
  br label %3794, !dbg !1096

3794:                                             ; preds = %3793, %3656
  %.5.i = phi float [ %3657, %3656 ], [ %.4.i, %3793 ], !dbg !1096
  br label %__nv_powf.exit, !dbg !1096

__nv_powf.exit:                                   ; preds = %3645, %3794
  %.6.i = phi float [ 1.000000e+00, %3645 ], [ %.5.i, %3794 ], !dbg !1096
  %3795 = load ptr, ptr %result.addr, align 8, !dbg !1098
  %arrayidx49 = getelementptr inbounds float, ptr %3795, i64 6, !dbg !1098
  store float %.6.i, ptr %arrayidx49, align 4, !dbg !1099
  %3796 = load ptr, ptr %result.addr, align 8, !dbg !1100
  %arrayidx50 = getelementptr inbounds float, ptr %3796, i64 6, !dbg !1100
  %3797 = load float, ptr %arrayidx50, align 4, !dbg !1100
  %call51 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %3797) #4, !dbg !1101
  %3798 = zext i1 %call51 to i64, !dbg !1101
  %cond52 = select i1 %call51, i32 1, i32 0, !dbg !1101
  %3799 = load ptr, ptr %is_denorm.addr, align 8, !dbg !1102
  %arrayidx53 = getelementptr inbounds i32, ptr %3799, i64 6, !dbg !1102
  store i32 %cond52, ptr %arrayidx53, align 4, !dbg !1103
  br label %if.end54, !dbg !1104

if.end54:                                         ; preds = %__nv_powf.exit, %if.end45
  %3800 = load i32, ptr %idx, align 4, !dbg !1105
  %cmp55 = icmp eq i32 %3800, 7, !dbg !1107
  br i1 %cmp55, label %if.then56, label %if.end63, !dbg !1107

if.then56:                                        ; preds = %if.end54
  store float 1.000000e+00, ptr %__a.addr.i68, align 4
    #dbg_declare(ptr %__a.addr.i68, !1108, !DIExpression(), !1109)
  %3801 = load float, ptr %__a.addr.i68, align 4, !dbg !1112
  %3802 = fcmp olt float %3801, 0x3810000000000000, !dbg !1113
  br i1 %3802, label %3803, label %3869, !dbg !1113

3803:                                             ; preds = %if.then56
  %3804 = bitcast float %3801 to i32, !dbg !1113
  %3805 = bitcast float %3801 to i32, !dbg !1113
  %3806 = and i32 %3805, 2139095040, !dbg !1113
  %3807 = icmp eq i32 %3806, 2139095040, !dbg !1113
  %3808 = and i32 %3805, 8388607, !dbg !1113
  %3809 = icmp ne i32 %3808, 0, !dbg !1113
  %is_nan955 = and i1 %3807, %3809, !dbg !1113
  %3810 = and i32 %3804, 4194304, !dbg !1113
  %3811 = icmp eq i32 %3810, 0, !dbg !1113
  %is_snan956 = and i1 %is_nan955, %3811, !dbg !1113
  %3812 = or i1 %is_snan956, false, !dbg !1113
  %3813 = bitcast float %3801 to i32, !dbg !1113
  %3814 = and i32 %3813, 2147483647, !dbg !1113
  %is_zero957 = icmp eq i32 %3814, 0, !dbg !1113
  %3815 = and i1 %is_zero957, false, !dbg !1113
  %3816 = bitcast float %3801 to i32, !dbg !1113
  %3817 = and i32 %3816, 2139095040, !dbg !1113
  %3818 = icmp eq i32 %3817, 2139095040, !dbg !1113
  %3819 = and i32 %3816, 8388607, !dbg !1113
  %3820 = icmp eq i32 %3819, 0, !dbg !1113
  %is_inf958 = and i1 %3818, %3820, !dbg !1113
  %3821 = and i1 %is_inf958, false, !dbg !1113
  %3822 = or i1 %3815, %3821, !dbg !1113
  %3823 = or i1 %3812, %3822, !dbg !1113
  br i1 %3823, label %3824, label %3826, !dbg !1113

3824:                                             ; preds = %3803
  %3825 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %3826, !dbg !1113

3826:                                             ; preds = %3803, %3824
  %3827 = fmul float %3801, 0x4160000000000000, !dbg !1113
  %3828 = bitcast float %3801 to i32, !dbg !1113
  %3829 = and i32 %3828, 2139095040, !dbg !1113
  %is_finite959 = icmp ne i32 %3829, 2139095040, !dbg !1113
  %3830 = and i1 true, %is_finite959, !dbg !1113
  %3831 = and i1 %3830, true, !dbg !1113
  %3832 = bitcast float %3827 to i32, !dbg !1113
  %3833 = and i32 %3832, 2139095040, !dbg !1113
  %3834 = icmp eq i32 %3833, 2139095040, !dbg !1113
  %3835 = and i32 %3832, 8388607, !dbg !1113
  %3836 = icmp eq i32 %3835, 0, !dbg !1113
  %is_inf960 = and i1 %3834, %3836, !dbg !1113
  %3837 = bitcast float %3827 to i32, !dbg !1113
  %3838 = and i32 %3837, 2147483647, !dbg !1113
  %is_maxfinite961 = icmp eq i32 %3838, 2139095039, !dbg !1113
  %3839 = bitcast float %3827 to i32, !dbg !1113
  %3840 = and i32 %3839, -2147483648, !dbg !1113
  %3841 = icmp eq i32 %3840, 0, !dbg !1113
  %3842 = icmp ne i32 %3840, 0, !dbg !1113
  %is_pos_inf962 = and i1 %is_inf960, %3841, !dbg !1113
  %is_neg_inf963 = and i1 %is_inf960, %3842, !dbg !1113
  %is_pos_max964 = and i1 %is_maxfinite961, %3841, !dbg !1113
  %is_neg_max965 = and i1 %is_maxfinite961, %3842, !dbg !1113
  %overflow_cond966 = and i1 %3831, %is_inf960, !dbg !1113
  br i1 %overflow_cond966, label %3843, label %3845, !dbg !1113

3843:                                             ; preds = %3826
  %3844 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %3845, !dbg !1113

3845:                                             ; preds = %3826, %3843
  %3846 = bitcast float %3801 to i32, !dbg !1113
  %3847 = and i32 %3846, 2139095040, !dbg !1113
  %3848 = icmp eq i32 %3847, 0, !dbg !1113
  %3849 = and i32 %3846, 8388607, !dbg !1113
  %3850 = icmp ne i32 %3849, 0, !dbg !1113
  %is_subnormal967 = and i1 %3848, %3850, !dbg !1113
  %3851 = xor i1 %is_subnormal967, true, !dbg !1113
  %3852 = and i1 true, %3851, !dbg !1113
  %3853 = and i1 %3852, true, !dbg !1113
  %3854 = bitcast float %3827 to i32, !dbg !1113
  %3855 = and i32 %3854, 2139095040, !dbg !1113
  %3856 = icmp eq i32 %3855, 0, !dbg !1113
  %3857 = and i32 %3854, 8388607, !dbg !1113
  %3858 = icmp ne i32 %3857, 0, !dbg !1113
  %is_subnormal968 = and i1 %3856, %3858, !dbg !1113
  %3859 = bitcast float %3827 to i32, !dbg !1113
  %3860 = and i32 %3859, 2147483647, !dbg !1113
  %is_zero969 = icmp eq i32 %3860, 0, !dbg !1113
  %3861 = bitcast float %3801 to i32, !dbg !1113
  %3862 = and i32 %3861, 2147483647, !dbg !1113
  %is_zero970 = icmp eq i32 %3862, 0, !dbg !1113
  %3863 = xor i1 %is_zero970, true, !dbg !1113
  %3864 = and i1 %3863, true, !dbg !1113
  %3865 = and i1 %is_zero969, %3864, !dbg !1113
  %is_tiny971 = or i1 %is_subnormal968, %3865, !dbg !1113
  %underflow_cond972 = and i1 %3853, %is_tiny971, !dbg !1113
  br i1 %underflow_cond972, label %3866, label %3868, !dbg !1113

3866:                                             ; preds = %3845
  %3867 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %3868, !dbg !1113

3868:                                             ; preds = %3845, %3866
  br label %3869, !dbg !1113

3869:                                             ; preds = %3868, %if.then56
  %.02.i = phi float [ %3827, %3868 ], [ %3801, %if.then56 ], !dbg !1113
  %i.i.0.i = phi float [ -2.300000e+01, %3868 ], [ 0.000000e+00, %if.then56 ], !dbg !1113
  %3870 = bitcast float %.02.i to i32, !dbg !1113
  %3871 = sub i32 %3870, 1059760811, !dbg !1113
  %3872 = and i32 %3871, -8388608, !dbg !1113
  %3873 = bitcast float %.02.i to i32, !dbg !1113
  %3874 = sub i32 %3873, %3872, !dbg !1113
  %3875 = bitcast i32 %3874 to float, !dbg !1113
  %3876 = sitofp i32 %3872 to float, !dbg !1113
  %3877 = bitcast float %3876 to i32, !dbg !1113
  %3878 = bitcast float %3876 to i32, !dbg !1113
  %3879 = and i32 %3878, 2139095040, !dbg !1113
  %3880 = icmp eq i32 %3879, 2139095040, !dbg !1113
  %3881 = and i32 %3878, 8388607, !dbg !1113
  %3882 = icmp ne i32 %3881, 0, !dbg !1113
  %is_nan973 = and i1 %3880, %3882, !dbg !1113
  %3883 = and i32 %3877, 4194304, !dbg !1113
  %3884 = icmp eq i32 %3883, 0, !dbg !1113
  %is_snan974 = and i1 %is_nan973, %3884, !dbg !1113
  %3885 = or i1 %is_snan974, false, !dbg !1113
  %3886 = bitcast float %i.i.0.i to i32, !dbg !1113
  %3887 = bitcast float %i.i.0.i to i32, !dbg !1113
  %3888 = and i32 %3887, 2139095040, !dbg !1113
  %3889 = icmp eq i32 %3888, 2139095040, !dbg !1113
  %3890 = and i32 %3887, 8388607, !dbg !1113
  %3891 = icmp ne i32 %3890, 0, !dbg !1113
  %is_nan975 = and i1 %3889, %3891, !dbg !1113
  %3892 = and i32 %3886, 4194304, !dbg !1113
  %3893 = icmp eq i32 %3892, 0, !dbg !1113
  %is_snan976 = and i1 %is_nan975, %3893, !dbg !1113
  %3894 = or i1 %3885, %is_snan976, !dbg !1113
  %3895 = bitcast float %3876 to i32, !dbg !1113
  %3896 = and i32 %3895, 2147483647, !dbg !1113
  %is_zero977 = icmp eq i32 %3896, 0, !dbg !1113
  %3897 = and i1 %is_zero977, false, !dbg !1113
  %3898 = bitcast float %3876 to i32, !dbg !1113
  %3899 = and i32 %3898, 2139095040, !dbg !1113
  %3900 = icmp eq i32 %3899, 2139095040, !dbg !1113
  %3901 = and i32 %3898, 8388607, !dbg !1113
  %3902 = icmp eq i32 %3901, 0, !dbg !1113
  %is_inf978 = and i1 %3900, %3902, !dbg !1113
  %3903 = and i1 %is_inf978, false, !dbg !1113
  %3904 = or i1 %3897, %3903, !dbg !1113
  %3905 = or i1 %3894, %3904, !dbg !1113
  br i1 %3905, label %3906, label %3908, !dbg !1113

3906:                                             ; preds = %3869
  %3907 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %3908, !dbg !1113

3908:                                             ; preds = %3869, %3906
  %3909 = call float @llvm.nvvm.fma.rn.f(float %3876, float 0x3E80000000000000, float %i.i.0.i) #5, !dbg !1113
  %3910 = bitcast float %3876 to i32, !dbg !1113
  %3911 = and i32 %3910, 2139095040, !dbg !1113
  %is_finite979 = icmp ne i32 %3911, 2139095040, !dbg !1113
  %3912 = and i1 true, %is_finite979, !dbg !1113
  %3913 = and i1 %3912, true, !dbg !1113
  %3914 = bitcast float %3909 to i32, !dbg !1113
  %3915 = and i32 %3914, 2139095040, !dbg !1113
  %3916 = icmp eq i32 %3915, 2139095040, !dbg !1113
  %3917 = and i32 %3914, 8388607, !dbg !1113
  %3918 = icmp eq i32 %3917, 0, !dbg !1113
  %is_inf980 = and i1 %3916, %3918, !dbg !1113
  %3919 = bitcast float %3909 to i32, !dbg !1113
  %3920 = and i32 %3919, 2147483647, !dbg !1113
  %is_maxfinite981 = icmp eq i32 %3920, 2139095039, !dbg !1113
  %3921 = bitcast float %3909 to i32, !dbg !1113
  %3922 = and i32 %3921, -2147483648, !dbg !1113
  %3923 = icmp eq i32 %3922, 0, !dbg !1113
  %3924 = icmp ne i32 %3922, 0, !dbg !1113
  %is_pos_inf982 = and i1 %is_inf980, %3923, !dbg !1113
  %is_neg_inf983 = and i1 %is_inf980, %3924, !dbg !1113
  %is_pos_max984 = and i1 %is_maxfinite981, %3923, !dbg !1113
  %is_neg_max985 = and i1 %is_maxfinite981, %3924, !dbg !1113
  %overflow_cond986 = and i1 %3913, %is_inf980, !dbg !1113
  br i1 %overflow_cond986, label %3925, label %3927, !dbg !1113

3925:                                             ; preds = %3908
  %3926 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %3927, !dbg !1113

3927:                                             ; preds = %3908, %3925
  %3928 = bitcast float %3876 to i32, !dbg !1113
  %3929 = and i32 %3928, 2139095040, !dbg !1113
  %3930 = icmp eq i32 %3929, 0, !dbg !1113
  %3931 = and i32 %3928, 8388607, !dbg !1113
  %3932 = icmp ne i32 %3931, 0, !dbg !1113
  %is_subnormal987 = and i1 %3930, %3932, !dbg !1113
  %3933 = xor i1 %is_subnormal987, true, !dbg !1113
  %3934 = and i1 true, %3933, !dbg !1113
  %3935 = and i1 %3934, true, !dbg !1113
  %3936 = bitcast float %i.i.0.i to i32, !dbg !1113
  %3937 = and i32 %3936, 2139095040, !dbg !1113
  %3938 = icmp eq i32 %3937, 0, !dbg !1113
  %3939 = and i32 %3936, 8388607, !dbg !1113
  %3940 = icmp ne i32 %3939, 0, !dbg !1113
  %is_subnormal988 = and i1 %3938, %3940, !dbg !1113
  %3941 = xor i1 %is_subnormal988, true, !dbg !1113
  %3942 = and i1 %3935, %3941, !dbg !1113
  %3943 = bitcast float %3909 to i32, !dbg !1113
  %3944 = and i32 %3943, 2139095040, !dbg !1113
  %3945 = icmp eq i32 %3944, 0, !dbg !1113
  %3946 = and i32 %3943, 8388607, !dbg !1113
  %3947 = icmp ne i32 %3946, 0, !dbg !1113
  %is_subnormal989 = and i1 %3945, %3947, !dbg !1113
  %is_tiny990 = or i1 %is_subnormal989, false, !dbg !1113
  %underflow_cond991 = and i1 %3942, %is_tiny990, !dbg !1113
  br i1 %underflow_cond991, label %3948, label %3950, !dbg !1113

3948:                                             ; preds = %3927
  %3949 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %3950, !dbg !1113

3950:                                             ; preds = %3927, %3948
  %3951 = bitcast float %3875 to i32, !dbg !1113
  %3952 = bitcast float %3875 to i32, !dbg !1113
  %3953 = and i32 %3952, 2139095040, !dbg !1113
  %3954 = icmp eq i32 %3953, 2139095040, !dbg !1113
  %3955 = and i32 %3952, 8388607, !dbg !1113
  %3956 = icmp ne i32 %3955, 0, !dbg !1113
  %is_nan992 = and i1 %3954, %3956, !dbg !1113
  %3957 = and i32 %3951, 4194304, !dbg !1113
  %3958 = icmp eq i32 %3957, 0, !dbg !1113
  %is_snan993 = and i1 %is_nan992, %3958, !dbg !1113
  %3959 = or i1 %is_snan993, false, !dbg !1113
  %3960 = bitcast float %3875 to i32, !dbg !1113
  %3961 = and i32 %3960, 2139095040, !dbg !1113
  %3962 = icmp eq i32 %3961, 2139095040, !dbg !1113
  %3963 = and i32 %3960, 8388607, !dbg !1113
  %3964 = icmp eq i32 %3963, 0, !dbg !1113
  %is_inf994 = and i1 %3962, %3964, !dbg !1113
  %3965 = and i1 %is_inf994, false, !dbg !1113
  %3966 = bitcast float %3875 to i32, !dbg !1113
  %3967 = and i32 %3966, -2147483648, !dbg !1113
  %3968 = icmp eq i32 %3967, 0, !dbg !1113
  %3969 = and i1 %3965, %3968, !dbg !1113
  %3970 = or i1 %3959, %3969, !dbg !1113
  br i1 %3970, label %3971, label %3973, !dbg !1113

3971:                                             ; preds = %3950
  %3972 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %3973, !dbg !1113

3973:                                             ; preds = %3950, %3971
  %3974 = fsub float %3875, 1.000000e+00, !dbg !1113
  %3975 = bitcast float %3875 to i32, !dbg !1113
  %3976 = and i32 %3975, 2139095040, !dbg !1113
  %is_finite995 = icmp ne i32 %3976, 2139095040, !dbg !1113
  %3977 = and i1 true, %is_finite995, !dbg !1113
  %3978 = and i1 %3977, true, !dbg !1113
  %3979 = bitcast float %3974 to i32, !dbg !1113
  %3980 = and i32 %3979, 2139095040, !dbg !1113
  %3981 = icmp eq i32 %3980, 2139095040, !dbg !1113
  %3982 = and i32 %3979, 8388607, !dbg !1113
  %3983 = icmp eq i32 %3982, 0, !dbg !1113
  %is_inf996 = and i1 %3981, %3983, !dbg !1113
  %3984 = bitcast float %3974 to i32, !dbg !1113
  %3985 = and i32 %3984, 2147483647, !dbg !1113
  %is_maxfinite997 = icmp eq i32 %3985, 2139095039, !dbg !1113
  %3986 = bitcast float %3974 to i32, !dbg !1113
  %3987 = and i32 %3986, -2147483648, !dbg !1113
  %3988 = icmp eq i32 %3987, 0, !dbg !1113
  %3989 = icmp ne i32 %3987, 0, !dbg !1113
  %is_pos_inf998 = and i1 %is_inf996, %3988, !dbg !1113
  %is_neg_inf999 = and i1 %is_inf996, %3989, !dbg !1113
  %is_pos_max1000 = and i1 %is_maxfinite997, %3988, !dbg !1113
  %is_neg_max1001 = and i1 %is_maxfinite997, %3989, !dbg !1113
  %overflow_cond1002 = and i1 %3978, %is_inf996, !dbg !1113
  br i1 %overflow_cond1002, label %3990, label %3992, !dbg !1113

3990:                                             ; preds = %3973
  %3991 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %3992, !dbg !1113

3992:                                             ; preds = %3973, %3990
  %3993 = bitcast float %3974 to i32, !dbg !1113
  %3994 = bitcast float %3974 to i32, !dbg !1113
  %3995 = and i32 %3994, 2139095040, !dbg !1113
  %3996 = icmp eq i32 %3995, 2139095040, !dbg !1113
  %3997 = and i32 %3994, 8388607, !dbg !1113
  %3998 = icmp ne i32 %3997, 0, !dbg !1113
  %is_nan1003 = and i1 %3996, %3998, !dbg !1113
  %3999 = and i32 %3993, 4194304, !dbg !1113
  %4000 = icmp eq i32 %3999, 0, !dbg !1113
  %is_snan1004 = and i1 %is_nan1003, %4000, !dbg !1113
  %4001 = or i1 false, %is_snan1004, !dbg !1113
  %4002 = or i1 %4001, false, !dbg !1113
  %4003 = bitcast float %3974 to i32, !dbg !1113
  %4004 = and i32 %4003, 2139095040, !dbg !1113
  %4005 = icmp eq i32 %4004, 2139095040, !dbg !1113
  %4006 = and i32 %4003, 8388607, !dbg !1113
  %4007 = icmp eq i32 %4006, 0, !dbg !1113
  %is_inf1005 = and i1 %4005, %4007, !dbg !1113
  %4008 = and i1 false, %is_inf1005, !dbg !1113
  %4009 = bitcast float %3974 to i32, !dbg !1113
  %4010 = and i32 %4009, 2147483647, !dbg !1113
  %is_zero1006 = icmp eq i32 %4010, 0, !dbg !1113
  %4011 = and i1 false, %is_zero1006, !dbg !1113
  %4012 = or i1 %4008, %4011, !dbg !1113
  %4013 = or i1 %4002, %4012, !dbg !1113
  br i1 %4013, label %4014, label %4016, !dbg !1113

4014:                                             ; preds = %3992
  %4015 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4016, !dbg !1113

4016:                                             ; preds = %3992, %4014
  %4017 = call float @llvm.nvvm.fma.rn.f(float 0xBFC0AA04E0000000, float %3974, float 0x3FC2073EC0000000) #5, !dbg !1113
  %4018 = bitcast float %3974 to i32, !dbg !1113
  %4019 = and i32 %4018, 2139095040, !dbg !1113
  %is_finite1007 = icmp ne i32 %4019, 2139095040, !dbg !1113
  %4020 = and i1 true, %is_finite1007, !dbg !1113
  %4021 = bitcast float %4017 to i32, !dbg !1113
  %4022 = and i32 %4021, 2139095040, !dbg !1113
  %4023 = icmp eq i32 %4022, 2139095040, !dbg !1113
  %4024 = and i32 %4021, 8388607, !dbg !1113
  %4025 = icmp eq i32 %4024, 0, !dbg !1113
  %is_inf1008 = and i1 %4023, %4025, !dbg !1113
  %4026 = bitcast float %4017 to i32, !dbg !1113
  %4027 = and i32 %4026, 2147483647, !dbg !1113
  %is_maxfinite1009 = icmp eq i32 %4027, 2139095039, !dbg !1113
  %4028 = bitcast float %4017 to i32, !dbg !1113
  %4029 = and i32 %4028, -2147483648, !dbg !1113
  %4030 = icmp eq i32 %4029, 0, !dbg !1113
  %4031 = icmp ne i32 %4029, 0, !dbg !1113
  %is_pos_inf1010 = and i1 %is_inf1008, %4030, !dbg !1113
  %is_neg_inf1011 = and i1 %is_inf1008, %4031, !dbg !1113
  %is_pos_max1012 = and i1 %is_maxfinite1009, %4030, !dbg !1113
  %is_neg_max1013 = and i1 %is_maxfinite1009, %4031, !dbg !1113
  %overflow_cond1014 = and i1 %4020, %is_inf1008, !dbg !1113
  br i1 %overflow_cond1014, label %4032, label %4034, !dbg !1113

4032:                                             ; preds = %4016
  %4033 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4034, !dbg !1113

4034:                                             ; preds = %4016, %4032
  %4035 = bitcast float %3974 to i32, !dbg !1113
  %4036 = and i32 %4035, 2139095040, !dbg !1113
  %4037 = icmp eq i32 %4036, 0, !dbg !1113
  %4038 = and i32 %4035, 8388607, !dbg !1113
  %4039 = icmp ne i32 %4038, 0, !dbg !1113
  %is_subnormal1015 = and i1 %4037, %4039, !dbg !1113
  %4040 = xor i1 %is_subnormal1015, true, !dbg !1113
  %4041 = and i1 true, %4040, !dbg !1113
  %4042 = and i1 %4041, true, !dbg !1113
  %4043 = bitcast float %4017 to i32, !dbg !1113
  %4044 = and i32 %4043, 2139095040, !dbg !1113
  %4045 = icmp eq i32 %4044, 0, !dbg !1113
  %4046 = and i32 %4043, 8388607, !dbg !1113
  %4047 = icmp ne i32 %4046, 0, !dbg !1113
  %is_subnormal1016 = and i1 %4045, %4047, !dbg !1113
  %is_tiny1017 = or i1 %is_subnormal1016, false, !dbg !1113
  %underflow_cond1018 = and i1 %4042, %is_tiny1017, !dbg !1113
  br i1 %underflow_cond1018, label %4048, label %4050, !dbg !1113

4048:                                             ; preds = %4034
  %4049 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4050, !dbg !1113

4050:                                             ; preds = %4034, %4048
  %4051 = bitcast float %4017 to i32, !dbg !1113
  %4052 = bitcast float %4017 to i32, !dbg !1113
  %4053 = and i32 %4052, 2139095040, !dbg !1113
  %4054 = icmp eq i32 %4053, 2139095040, !dbg !1113
  %4055 = and i32 %4052, 8388607, !dbg !1113
  %4056 = icmp ne i32 %4055, 0, !dbg !1113
  %is_nan1019 = and i1 %4054, %4056, !dbg !1113
  %4057 = and i32 %4051, 4194304, !dbg !1113
  %4058 = icmp eq i32 %4057, 0, !dbg !1113
  %is_snan1020 = and i1 %is_nan1019, %4058, !dbg !1113
  %4059 = bitcast float %3974 to i32, !dbg !1113
  %4060 = bitcast float %3974 to i32, !dbg !1113
  %4061 = and i32 %4060, 2139095040, !dbg !1113
  %4062 = icmp eq i32 %4061, 2139095040, !dbg !1113
  %4063 = and i32 %4060, 8388607, !dbg !1113
  %4064 = icmp ne i32 %4063, 0, !dbg !1113
  %is_nan1021 = and i1 %4062, %4064, !dbg !1113
  %4065 = and i32 %4059, 4194304, !dbg !1113
  %4066 = icmp eq i32 %4065, 0, !dbg !1113
  %is_snan1022 = and i1 %is_nan1021, %4066, !dbg !1113
  %4067 = or i1 %is_snan1020, %is_snan1022, !dbg !1113
  %4068 = or i1 %4067, false, !dbg !1113
  %4069 = bitcast float %4017 to i32, !dbg !1113
  %4070 = and i32 %4069, 2147483647, !dbg !1113
  %is_zero1023 = icmp eq i32 %4070, 0, !dbg !1113
  %4071 = bitcast float %3974 to i32, !dbg !1113
  %4072 = and i32 %4071, 2139095040, !dbg !1113
  %4073 = icmp eq i32 %4072, 2139095040, !dbg !1113
  %4074 = and i32 %4071, 8388607, !dbg !1113
  %4075 = icmp eq i32 %4074, 0, !dbg !1113
  %is_inf1024 = and i1 %4073, %4075, !dbg !1113
  %4076 = and i1 %is_zero1023, %is_inf1024, !dbg !1113
  %4077 = bitcast float %4017 to i32, !dbg !1113
  %4078 = and i32 %4077, 2139095040, !dbg !1113
  %4079 = icmp eq i32 %4078, 2139095040, !dbg !1113
  %4080 = and i32 %4077, 8388607, !dbg !1113
  %4081 = icmp eq i32 %4080, 0, !dbg !1113
  %is_inf1025 = and i1 %4079, %4081, !dbg !1113
  %4082 = bitcast float %3974 to i32, !dbg !1113
  %4083 = and i32 %4082, 2147483647, !dbg !1113
  %is_zero1026 = icmp eq i32 %4083, 0, !dbg !1113
  %4084 = and i1 %is_inf1025, %is_zero1026, !dbg !1113
  %4085 = or i1 %4076, %4084, !dbg !1113
  %4086 = or i1 %4068, %4085, !dbg !1113
  br i1 %4086, label %4087, label %4089, !dbg !1113

4087:                                             ; preds = %4050
  %4088 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4089, !dbg !1113

4089:                                             ; preds = %4050, %4087
  %4090 = call float @llvm.nvvm.fma.rn.f(float %4017, float %3974, float 0xBFBF19B980000000) #5, !dbg !1113
  %4091 = bitcast float %4017 to i32, !dbg !1113
  %4092 = and i32 %4091, 2139095040, !dbg !1113
  %is_finite1027 = icmp ne i32 %4092, 2139095040, !dbg !1113
  %4093 = and i1 true, %is_finite1027, !dbg !1113
  %4094 = bitcast float %3974 to i32, !dbg !1113
  %4095 = and i32 %4094, 2139095040, !dbg !1113
  %is_finite1028 = icmp ne i32 %4095, 2139095040, !dbg !1113
  %4096 = and i1 %4093, %is_finite1028, !dbg !1113
  %4097 = bitcast float %4090 to i32, !dbg !1113
  %4098 = and i32 %4097, 2139095040, !dbg !1113
  %4099 = icmp eq i32 %4098, 2139095040, !dbg !1113
  %4100 = and i32 %4097, 8388607, !dbg !1113
  %4101 = icmp eq i32 %4100, 0, !dbg !1113
  %is_inf1029 = and i1 %4099, %4101, !dbg !1113
  %4102 = bitcast float %4090 to i32, !dbg !1113
  %4103 = and i32 %4102, 2147483647, !dbg !1113
  %is_maxfinite1030 = icmp eq i32 %4103, 2139095039, !dbg !1113
  %4104 = bitcast float %4090 to i32, !dbg !1113
  %4105 = and i32 %4104, -2147483648, !dbg !1113
  %4106 = icmp eq i32 %4105, 0, !dbg !1113
  %4107 = icmp ne i32 %4105, 0, !dbg !1113
  %is_pos_inf1031 = and i1 %is_inf1029, %4106, !dbg !1113
  %is_neg_inf1032 = and i1 %is_inf1029, %4107, !dbg !1113
  %is_pos_max1033 = and i1 %is_maxfinite1030, %4106, !dbg !1113
  %is_neg_max1034 = and i1 %is_maxfinite1030, %4107, !dbg !1113
  %overflow_cond1035 = and i1 %4096, %is_inf1029, !dbg !1113
  br i1 %overflow_cond1035, label %4108, label %4110, !dbg !1113

4108:                                             ; preds = %4089
  %4109 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4110, !dbg !1113

4110:                                             ; preds = %4089, %4108
  %4111 = bitcast float %4017 to i32, !dbg !1113
  %4112 = and i32 %4111, 2139095040, !dbg !1113
  %4113 = icmp eq i32 %4112, 0, !dbg !1113
  %4114 = and i32 %4111, 8388607, !dbg !1113
  %4115 = icmp ne i32 %4114, 0, !dbg !1113
  %is_subnormal1036 = and i1 %4113, %4115, !dbg !1113
  %4116 = xor i1 %is_subnormal1036, true, !dbg !1113
  %4117 = and i1 true, %4116, !dbg !1113
  %4118 = bitcast float %3974 to i32, !dbg !1113
  %4119 = and i32 %4118, 2139095040, !dbg !1113
  %4120 = icmp eq i32 %4119, 0, !dbg !1113
  %4121 = and i32 %4118, 8388607, !dbg !1113
  %4122 = icmp ne i32 %4121, 0, !dbg !1113
  %is_subnormal1037 = and i1 %4120, %4122, !dbg !1113
  %4123 = xor i1 %is_subnormal1037, true, !dbg !1113
  %4124 = and i1 %4117, %4123, !dbg !1113
  %4125 = and i1 %4124, true, !dbg !1113
  %4126 = bitcast float %4090 to i32, !dbg !1113
  %4127 = and i32 %4126, 2139095040, !dbg !1113
  %4128 = icmp eq i32 %4127, 0, !dbg !1113
  %4129 = and i32 %4126, 8388607, !dbg !1113
  %4130 = icmp ne i32 %4129, 0, !dbg !1113
  %is_subnormal1038 = and i1 %4128, %4130, !dbg !1113
  %is_tiny1039 = or i1 %is_subnormal1038, false, !dbg !1113
  %underflow_cond1040 = and i1 %4125, %is_tiny1039, !dbg !1113
  br i1 %underflow_cond1040, label %4131, label %4133, !dbg !1113

4131:                                             ; preds = %4110
  %4132 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4133, !dbg !1113

4133:                                             ; preds = %4110, %4131
  %4134 = bitcast float %4090 to i32, !dbg !1113
  %4135 = bitcast float %4090 to i32, !dbg !1113
  %4136 = and i32 %4135, 2139095040, !dbg !1113
  %4137 = icmp eq i32 %4136, 2139095040, !dbg !1113
  %4138 = and i32 %4135, 8388607, !dbg !1113
  %4139 = icmp ne i32 %4138, 0, !dbg !1113
  %is_nan1041 = and i1 %4137, %4139, !dbg !1113
  %4140 = and i32 %4134, 4194304, !dbg !1113
  %4141 = icmp eq i32 %4140, 0, !dbg !1113
  %is_snan1042 = and i1 %is_nan1041, %4141, !dbg !1113
  %4142 = bitcast float %3974 to i32, !dbg !1113
  %4143 = bitcast float %3974 to i32, !dbg !1113
  %4144 = and i32 %4143, 2139095040, !dbg !1113
  %4145 = icmp eq i32 %4144, 2139095040, !dbg !1113
  %4146 = and i32 %4143, 8388607, !dbg !1113
  %4147 = icmp ne i32 %4146, 0, !dbg !1113
  %is_nan1043 = and i1 %4145, %4147, !dbg !1113
  %4148 = and i32 %4142, 4194304, !dbg !1113
  %4149 = icmp eq i32 %4148, 0, !dbg !1113
  %is_snan1044 = and i1 %is_nan1043, %4149, !dbg !1113
  %4150 = or i1 %is_snan1042, %is_snan1044, !dbg !1113
  %4151 = or i1 %4150, false, !dbg !1113
  %4152 = bitcast float %4090 to i32, !dbg !1113
  %4153 = and i32 %4152, 2147483647, !dbg !1113
  %is_zero1045 = icmp eq i32 %4153, 0, !dbg !1113
  %4154 = bitcast float %3974 to i32, !dbg !1113
  %4155 = and i32 %4154, 2139095040, !dbg !1113
  %4156 = icmp eq i32 %4155, 2139095040, !dbg !1113
  %4157 = and i32 %4154, 8388607, !dbg !1113
  %4158 = icmp eq i32 %4157, 0, !dbg !1113
  %is_inf1046 = and i1 %4156, %4158, !dbg !1113
  %4159 = and i1 %is_zero1045, %is_inf1046, !dbg !1113
  %4160 = bitcast float %4090 to i32, !dbg !1113
  %4161 = and i32 %4160, 2139095040, !dbg !1113
  %4162 = icmp eq i32 %4161, 2139095040, !dbg !1113
  %4163 = and i32 %4160, 8388607, !dbg !1113
  %4164 = icmp eq i32 %4163, 0, !dbg !1113
  %is_inf1047 = and i1 %4162, %4164, !dbg !1113
  %4165 = bitcast float %3974 to i32, !dbg !1113
  %4166 = and i32 %4165, 2147483647, !dbg !1113
  %is_zero1048 = icmp eq i32 %4166, 0, !dbg !1113
  %4167 = and i1 %is_inf1047, %is_zero1048, !dbg !1113
  %4168 = or i1 %4159, %4167, !dbg !1113
  %4169 = or i1 %4151, %4168, !dbg !1113
  br i1 %4169, label %4170, label %4172, !dbg !1113

4170:                                             ; preds = %4133
  %4171 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4172, !dbg !1113

4172:                                             ; preds = %4133, %4170
  %4173 = call float @llvm.nvvm.fma.rn.f(float %4090, float %3974, float 0x3FC1E52AA0000000) #5, !dbg !1113
  %4174 = bitcast float %4090 to i32, !dbg !1113
  %4175 = and i32 %4174, 2139095040, !dbg !1113
  %is_finite1049 = icmp ne i32 %4175, 2139095040, !dbg !1113
  %4176 = and i1 true, %is_finite1049, !dbg !1113
  %4177 = bitcast float %3974 to i32, !dbg !1113
  %4178 = and i32 %4177, 2139095040, !dbg !1113
  %is_finite1050 = icmp ne i32 %4178, 2139095040, !dbg !1113
  %4179 = and i1 %4176, %is_finite1050, !dbg !1113
  %4180 = bitcast float %4173 to i32, !dbg !1113
  %4181 = and i32 %4180, 2139095040, !dbg !1113
  %4182 = icmp eq i32 %4181, 2139095040, !dbg !1113
  %4183 = and i32 %4180, 8388607, !dbg !1113
  %4184 = icmp eq i32 %4183, 0, !dbg !1113
  %is_inf1051 = and i1 %4182, %4184, !dbg !1113
  %4185 = bitcast float %4173 to i32, !dbg !1113
  %4186 = and i32 %4185, 2147483647, !dbg !1113
  %is_maxfinite1052 = icmp eq i32 %4186, 2139095039, !dbg !1113
  %4187 = bitcast float %4173 to i32, !dbg !1113
  %4188 = and i32 %4187, -2147483648, !dbg !1113
  %4189 = icmp eq i32 %4188, 0, !dbg !1113
  %4190 = icmp ne i32 %4188, 0, !dbg !1113
  %is_pos_inf1053 = and i1 %is_inf1051, %4189, !dbg !1113
  %is_neg_inf1054 = and i1 %is_inf1051, %4190, !dbg !1113
  %is_pos_max1055 = and i1 %is_maxfinite1052, %4189, !dbg !1113
  %is_neg_max1056 = and i1 %is_maxfinite1052, %4190, !dbg !1113
  %overflow_cond1057 = and i1 %4179, %is_inf1051, !dbg !1113
  br i1 %overflow_cond1057, label %4191, label %4193, !dbg !1113

4191:                                             ; preds = %4172
  %4192 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4193, !dbg !1113

4193:                                             ; preds = %4172, %4191
  %4194 = bitcast float %4090 to i32, !dbg !1113
  %4195 = and i32 %4194, 2139095040, !dbg !1113
  %4196 = icmp eq i32 %4195, 0, !dbg !1113
  %4197 = and i32 %4194, 8388607, !dbg !1113
  %4198 = icmp ne i32 %4197, 0, !dbg !1113
  %is_subnormal1058 = and i1 %4196, %4198, !dbg !1113
  %4199 = xor i1 %is_subnormal1058, true, !dbg !1113
  %4200 = and i1 true, %4199, !dbg !1113
  %4201 = bitcast float %3974 to i32, !dbg !1113
  %4202 = and i32 %4201, 2139095040, !dbg !1113
  %4203 = icmp eq i32 %4202, 0, !dbg !1113
  %4204 = and i32 %4201, 8388607, !dbg !1113
  %4205 = icmp ne i32 %4204, 0, !dbg !1113
  %is_subnormal1059 = and i1 %4203, %4205, !dbg !1113
  %4206 = xor i1 %is_subnormal1059, true, !dbg !1113
  %4207 = and i1 %4200, %4206, !dbg !1113
  %4208 = and i1 %4207, true, !dbg !1113
  %4209 = bitcast float %4173 to i32, !dbg !1113
  %4210 = and i32 %4209, 2139095040, !dbg !1113
  %4211 = icmp eq i32 %4210, 0, !dbg !1113
  %4212 = and i32 %4209, 8388607, !dbg !1113
  %4213 = icmp ne i32 %4212, 0, !dbg !1113
  %is_subnormal1060 = and i1 %4211, %4213, !dbg !1113
  %is_tiny1061 = or i1 %is_subnormal1060, false, !dbg !1113
  %underflow_cond1062 = and i1 %4208, %is_tiny1061, !dbg !1113
  br i1 %underflow_cond1062, label %4214, label %4216, !dbg !1113

4214:                                             ; preds = %4193
  %4215 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4216, !dbg !1113

4216:                                             ; preds = %4193, %4214
  %4217 = bitcast float %4173 to i32, !dbg !1113
  %4218 = bitcast float %4173 to i32, !dbg !1113
  %4219 = and i32 %4218, 2139095040, !dbg !1113
  %4220 = icmp eq i32 %4219, 2139095040, !dbg !1113
  %4221 = and i32 %4218, 8388607, !dbg !1113
  %4222 = icmp ne i32 %4221, 0, !dbg !1113
  %is_nan1063 = and i1 %4220, %4222, !dbg !1113
  %4223 = and i32 %4217, 4194304, !dbg !1113
  %4224 = icmp eq i32 %4223, 0, !dbg !1113
  %is_snan1064 = and i1 %is_nan1063, %4224, !dbg !1113
  %4225 = bitcast float %3974 to i32, !dbg !1113
  %4226 = bitcast float %3974 to i32, !dbg !1113
  %4227 = and i32 %4226, 2139095040, !dbg !1113
  %4228 = icmp eq i32 %4227, 2139095040, !dbg !1113
  %4229 = and i32 %4226, 8388607, !dbg !1113
  %4230 = icmp ne i32 %4229, 0, !dbg !1113
  %is_nan1065 = and i1 %4228, %4230, !dbg !1113
  %4231 = and i32 %4225, 4194304, !dbg !1113
  %4232 = icmp eq i32 %4231, 0, !dbg !1113
  %is_snan1066 = and i1 %is_nan1065, %4232, !dbg !1113
  %4233 = or i1 %is_snan1064, %is_snan1066, !dbg !1113
  %4234 = or i1 %4233, false, !dbg !1113
  %4235 = bitcast float %4173 to i32, !dbg !1113
  %4236 = and i32 %4235, 2147483647, !dbg !1113
  %is_zero1067 = icmp eq i32 %4236, 0, !dbg !1113
  %4237 = bitcast float %3974 to i32, !dbg !1113
  %4238 = and i32 %4237, 2139095040, !dbg !1113
  %4239 = icmp eq i32 %4238, 2139095040, !dbg !1113
  %4240 = and i32 %4237, 8388607, !dbg !1113
  %4241 = icmp eq i32 %4240, 0, !dbg !1113
  %is_inf1068 = and i1 %4239, %4241, !dbg !1113
  %4242 = and i1 %is_zero1067, %is_inf1068, !dbg !1113
  %4243 = bitcast float %4173 to i32, !dbg !1113
  %4244 = and i32 %4243, 2139095040, !dbg !1113
  %4245 = icmp eq i32 %4244, 2139095040, !dbg !1113
  %4246 = and i32 %4243, 8388607, !dbg !1113
  %4247 = icmp eq i32 %4246, 0, !dbg !1113
  %is_inf1069 = and i1 %4245, %4247, !dbg !1113
  %4248 = bitcast float %3974 to i32, !dbg !1113
  %4249 = and i32 %4248, 2147483647, !dbg !1113
  %is_zero1070 = icmp eq i32 %4249, 0, !dbg !1113
  %4250 = and i1 %is_inf1069, %is_zero1070, !dbg !1113
  %4251 = or i1 %4242, %4250, !dbg !1113
  %4252 = or i1 %4234, %4251, !dbg !1113
  br i1 %4252, label %4253, label %4255, !dbg !1113

4253:                                             ; preds = %4216
  %4254 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4255, !dbg !1113

4255:                                             ; preds = %4216, %4253
  %4256 = call float @llvm.nvvm.fma.rn.f(float %4173, float %3974, float 0xBFC55B1720000000) #5, !dbg !1113
  %4257 = bitcast float %4173 to i32, !dbg !1113
  %4258 = and i32 %4257, 2139095040, !dbg !1113
  %is_finite1071 = icmp ne i32 %4258, 2139095040, !dbg !1113
  %4259 = and i1 true, %is_finite1071, !dbg !1113
  %4260 = bitcast float %3974 to i32, !dbg !1113
  %4261 = and i32 %4260, 2139095040, !dbg !1113
  %is_finite1072 = icmp ne i32 %4261, 2139095040, !dbg !1113
  %4262 = and i1 %4259, %is_finite1072, !dbg !1113
  %4263 = bitcast float %4256 to i32, !dbg !1113
  %4264 = and i32 %4263, 2139095040, !dbg !1113
  %4265 = icmp eq i32 %4264, 2139095040, !dbg !1113
  %4266 = and i32 %4263, 8388607, !dbg !1113
  %4267 = icmp eq i32 %4266, 0, !dbg !1113
  %is_inf1073 = and i1 %4265, %4267, !dbg !1113
  %4268 = bitcast float %4256 to i32, !dbg !1113
  %4269 = and i32 %4268, 2147483647, !dbg !1113
  %is_maxfinite1074 = icmp eq i32 %4269, 2139095039, !dbg !1113
  %4270 = bitcast float %4256 to i32, !dbg !1113
  %4271 = and i32 %4270, -2147483648, !dbg !1113
  %4272 = icmp eq i32 %4271, 0, !dbg !1113
  %4273 = icmp ne i32 %4271, 0, !dbg !1113
  %is_pos_inf1075 = and i1 %is_inf1073, %4272, !dbg !1113
  %is_neg_inf1076 = and i1 %is_inf1073, %4273, !dbg !1113
  %is_pos_max1077 = and i1 %is_maxfinite1074, %4272, !dbg !1113
  %is_neg_max1078 = and i1 %is_maxfinite1074, %4273, !dbg !1113
  %overflow_cond1079 = and i1 %4262, %is_inf1073, !dbg !1113
  br i1 %overflow_cond1079, label %4274, label %4276, !dbg !1113

4274:                                             ; preds = %4255
  %4275 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4276, !dbg !1113

4276:                                             ; preds = %4255, %4274
  %4277 = bitcast float %4173 to i32, !dbg !1113
  %4278 = and i32 %4277, 2139095040, !dbg !1113
  %4279 = icmp eq i32 %4278, 0, !dbg !1113
  %4280 = and i32 %4277, 8388607, !dbg !1113
  %4281 = icmp ne i32 %4280, 0, !dbg !1113
  %is_subnormal1080 = and i1 %4279, %4281, !dbg !1113
  %4282 = xor i1 %is_subnormal1080, true, !dbg !1113
  %4283 = and i1 true, %4282, !dbg !1113
  %4284 = bitcast float %3974 to i32, !dbg !1113
  %4285 = and i32 %4284, 2139095040, !dbg !1113
  %4286 = icmp eq i32 %4285, 0, !dbg !1113
  %4287 = and i32 %4284, 8388607, !dbg !1113
  %4288 = icmp ne i32 %4287, 0, !dbg !1113
  %is_subnormal1081 = and i1 %4286, %4288, !dbg !1113
  %4289 = xor i1 %is_subnormal1081, true, !dbg !1113
  %4290 = and i1 %4283, %4289, !dbg !1113
  %4291 = and i1 %4290, true, !dbg !1113
  %4292 = bitcast float %4256 to i32, !dbg !1113
  %4293 = and i32 %4292, 2139095040, !dbg !1113
  %4294 = icmp eq i32 %4293, 0, !dbg !1113
  %4295 = and i32 %4292, 8388607, !dbg !1113
  %4296 = icmp ne i32 %4295, 0, !dbg !1113
  %is_subnormal1082 = and i1 %4294, %4296, !dbg !1113
  %is_tiny1083 = or i1 %is_subnormal1082, false, !dbg !1113
  %underflow_cond1084 = and i1 %4291, %is_tiny1083, !dbg !1113
  br i1 %underflow_cond1084, label %4297, label %4299, !dbg !1113

4297:                                             ; preds = %4276
  %4298 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4299, !dbg !1113

4299:                                             ; preds = %4276, %4297
  %4300 = bitcast float %4256 to i32, !dbg !1113
  %4301 = bitcast float %4256 to i32, !dbg !1113
  %4302 = and i32 %4301, 2139095040, !dbg !1113
  %4303 = icmp eq i32 %4302, 2139095040, !dbg !1113
  %4304 = and i32 %4301, 8388607, !dbg !1113
  %4305 = icmp ne i32 %4304, 0, !dbg !1113
  %is_nan1085 = and i1 %4303, %4305, !dbg !1113
  %4306 = and i32 %4300, 4194304, !dbg !1113
  %4307 = icmp eq i32 %4306, 0, !dbg !1113
  %is_snan1086 = and i1 %is_nan1085, %4307, !dbg !1113
  %4308 = bitcast float %3974 to i32, !dbg !1113
  %4309 = bitcast float %3974 to i32, !dbg !1113
  %4310 = and i32 %4309, 2139095040, !dbg !1113
  %4311 = icmp eq i32 %4310, 2139095040, !dbg !1113
  %4312 = and i32 %4309, 8388607, !dbg !1113
  %4313 = icmp ne i32 %4312, 0, !dbg !1113
  %is_nan1087 = and i1 %4311, %4313, !dbg !1113
  %4314 = and i32 %4308, 4194304, !dbg !1113
  %4315 = icmp eq i32 %4314, 0, !dbg !1113
  %is_snan1088 = and i1 %is_nan1087, %4315, !dbg !1113
  %4316 = or i1 %is_snan1086, %is_snan1088, !dbg !1113
  %4317 = or i1 %4316, false, !dbg !1113
  %4318 = bitcast float %4256 to i32, !dbg !1113
  %4319 = and i32 %4318, 2147483647, !dbg !1113
  %is_zero1089 = icmp eq i32 %4319, 0, !dbg !1113
  %4320 = bitcast float %3974 to i32, !dbg !1113
  %4321 = and i32 %4320, 2139095040, !dbg !1113
  %4322 = icmp eq i32 %4321, 2139095040, !dbg !1113
  %4323 = and i32 %4320, 8388607, !dbg !1113
  %4324 = icmp eq i32 %4323, 0, !dbg !1113
  %is_inf1090 = and i1 %4322, %4324, !dbg !1113
  %4325 = and i1 %is_zero1089, %is_inf1090, !dbg !1113
  %4326 = bitcast float %4256 to i32, !dbg !1113
  %4327 = and i32 %4326, 2139095040, !dbg !1113
  %4328 = icmp eq i32 %4327, 2139095040, !dbg !1113
  %4329 = and i32 %4326, 8388607, !dbg !1113
  %4330 = icmp eq i32 %4329, 0, !dbg !1113
  %is_inf1091 = and i1 %4328, %4330, !dbg !1113
  %4331 = bitcast float %3974 to i32, !dbg !1113
  %4332 = and i32 %4331, 2147483647, !dbg !1113
  %is_zero1092 = icmp eq i32 %4332, 0, !dbg !1113
  %4333 = and i1 %is_inf1091, %is_zero1092, !dbg !1113
  %4334 = or i1 %4325, %4333, !dbg !1113
  %4335 = or i1 %4317, %4334, !dbg !1113
  br i1 %4335, label %4336, label %4338, !dbg !1113

4336:                                             ; preds = %4299
  %4337 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4338, !dbg !1113

4338:                                             ; preds = %4299, %4336
  %4339 = call float @llvm.nvvm.fma.rn.f(float %4256, float %3974, float 0x3FC99DA160000000) #5, !dbg !1113
  %4340 = bitcast float %4256 to i32, !dbg !1113
  %4341 = and i32 %4340, 2139095040, !dbg !1113
  %is_finite1093 = icmp ne i32 %4341, 2139095040, !dbg !1113
  %4342 = and i1 true, %is_finite1093, !dbg !1113
  %4343 = bitcast float %3974 to i32, !dbg !1113
  %4344 = and i32 %4343, 2139095040, !dbg !1113
  %is_finite1094 = icmp ne i32 %4344, 2139095040, !dbg !1113
  %4345 = and i1 %4342, %is_finite1094, !dbg !1113
  %4346 = bitcast float %4339 to i32, !dbg !1113
  %4347 = and i32 %4346, 2139095040, !dbg !1113
  %4348 = icmp eq i32 %4347, 2139095040, !dbg !1113
  %4349 = and i32 %4346, 8388607, !dbg !1113
  %4350 = icmp eq i32 %4349, 0, !dbg !1113
  %is_inf1095 = and i1 %4348, %4350, !dbg !1113
  %4351 = bitcast float %4339 to i32, !dbg !1113
  %4352 = and i32 %4351, 2147483647, !dbg !1113
  %is_maxfinite1096 = icmp eq i32 %4352, 2139095039, !dbg !1113
  %4353 = bitcast float %4339 to i32, !dbg !1113
  %4354 = and i32 %4353, -2147483648, !dbg !1113
  %4355 = icmp eq i32 %4354, 0, !dbg !1113
  %4356 = icmp ne i32 %4354, 0, !dbg !1113
  %is_pos_inf1097 = and i1 %is_inf1095, %4355, !dbg !1113
  %is_neg_inf1098 = and i1 %is_inf1095, %4356, !dbg !1113
  %is_pos_max1099 = and i1 %is_maxfinite1096, %4355, !dbg !1113
  %is_neg_max1100 = and i1 %is_maxfinite1096, %4356, !dbg !1113
  %overflow_cond1101 = and i1 %4345, %is_inf1095, !dbg !1113
  br i1 %overflow_cond1101, label %4357, label %4359, !dbg !1113

4357:                                             ; preds = %4338
  %4358 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4359, !dbg !1113

4359:                                             ; preds = %4338, %4357
  %4360 = bitcast float %4256 to i32, !dbg !1113
  %4361 = and i32 %4360, 2139095040, !dbg !1113
  %4362 = icmp eq i32 %4361, 0, !dbg !1113
  %4363 = and i32 %4360, 8388607, !dbg !1113
  %4364 = icmp ne i32 %4363, 0, !dbg !1113
  %is_subnormal1102 = and i1 %4362, %4364, !dbg !1113
  %4365 = xor i1 %is_subnormal1102, true, !dbg !1113
  %4366 = and i1 true, %4365, !dbg !1113
  %4367 = bitcast float %3974 to i32, !dbg !1113
  %4368 = and i32 %4367, 2139095040, !dbg !1113
  %4369 = icmp eq i32 %4368, 0, !dbg !1113
  %4370 = and i32 %4367, 8388607, !dbg !1113
  %4371 = icmp ne i32 %4370, 0, !dbg !1113
  %is_subnormal1103 = and i1 %4369, %4371, !dbg !1113
  %4372 = xor i1 %is_subnormal1103, true, !dbg !1113
  %4373 = and i1 %4366, %4372, !dbg !1113
  %4374 = and i1 %4373, true, !dbg !1113
  %4375 = bitcast float %4339 to i32, !dbg !1113
  %4376 = and i32 %4375, 2139095040, !dbg !1113
  %4377 = icmp eq i32 %4376, 0, !dbg !1113
  %4378 = and i32 %4375, 8388607, !dbg !1113
  %4379 = icmp ne i32 %4378, 0, !dbg !1113
  %is_subnormal1104 = and i1 %4377, %4379, !dbg !1113
  %is_tiny1105 = or i1 %is_subnormal1104, false, !dbg !1113
  %underflow_cond1106 = and i1 %4374, %is_tiny1105, !dbg !1113
  br i1 %underflow_cond1106, label %4380, label %4382, !dbg !1113

4380:                                             ; preds = %4359
  %4381 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4382, !dbg !1113

4382:                                             ; preds = %4359, %4380
  %4383 = bitcast float %4339 to i32, !dbg !1113
  %4384 = bitcast float %4339 to i32, !dbg !1113
  %4385 = and i32 %4384, 2139095040, !dbg !1113
  %4386 = icmp eq i32 %4385, 2139095040, !dbg !1113
  %4387 = and i32 %4384, 8388607, !dbg !1113
  %4388 = icmp ne i32 %4387, 0, !dbg !1113
  %is_nan1107 = and i1 %4386, %4388, !dbg !1113
  %4389 = and i32 %4383, 4194304, !dbg !1113
  %4390 = icmp eq i32 %4389, 0, !dbg !1113
  %is_snan1108 = and i1 %is_nan1107, %4390, !dbg !1113
  %4391 = bitcast float %3974 to i32, !dbg !1113
  %4392 = bitcast float %3974 to i32, !dbg !1113
  %4393 = and i32 %4392, 2139095040, !dbg !1113
  %4394 = icmp eq i32 %4393, 2139095040, !dbg !1113
  %4395 = and i32 %4392, 8388607, !dbg !1113
  %4396 = icmp ne i32 %4395, 0, !dbg !1113
  %is_nan1109 = and i1 %4394, %4396, !dbg !1113
  %4397 = and i32 %4391, 4194304, !dbg !1113
  %4398 = icmp eq i32 %4397, 0, !dbg !1113
  %is_snan1110 = and i1 %is_nan1109, %4398, !dbg !1113
  %4399 = or i1 %is_snan1108, %is_snan1110, !dbg !1113
  %4400 = or i1 %4399, false, !dbg !1113
  %4401 = bitcast float %4339 to i32, !dbg !1113
  %4402 = and i32 %4401, 2147483647, !dbg !1113
  %is_zero1111 = icmp eq i32 %4402, 0, !dbg !1113
  %4403 = bitcast float %3974 to i32, !dbg !1113
  %4404 = and i32 %4403, 2139095040, !dbg !1113
  %4405 = icmp eq i32 %4404, 2139095040, !dbg !1113
  %4406 = and i32 %4403, 8388607, !dbg !1113
  %4407 = icmp eq i32 %4406, 0, !dbg !1113
  %is_inf1112 = and i1 %4405, %4407, !dbg !1113
  %4408 = and i1 %is_zero1111, %is_inf1112, !dbg !1113
  %4409 = bitcast float %4339 to i32, !dbg !1113
  %4410 = and i32 %4409, 2139095040, !dbg !1113
  %4411 = icmp eq i32 %4410, 2139095040, !dbg !1113
  %4412 = and i32 %4409, 8388607, !dbg !1113
  %4413 = icmp eq i32 %4412, 0, !dbg !1113
  %is_inf1113 = and i1 %4411, %4413, !dbg !1113
  %4414 = bitcast float %3974 to i32, !dbg !1113
  %4415 = and i32 %4414, 2147483647, !dbg !1113
  %is_zero1114 = icmp eq i32 %4415, 0, !dbg !1113
  %4416 = and i1 %is_inf1113, %is_zero1114, !dbg !1113
  %4417 = or i1 %4408, %4416, !dbg !1113
  %4418 = or i1 %4400, %4417, !dbg !1113
  br i1 %4418, label %4419, label %4421, !dbg !1113

4419:                                             ; preds = %4382
  %4420 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4421, !dbg !1113

4421:                                             ; preds = %4382, %4419
  %4422 = call float @llvm.nvvm.fma.rn.f(float %4339, float %3974, float 0xBFCFFFE440000000) #5, !dbg !1113
  %4423 = bitcast float %4339 to i32, !dbg !1113
  %4424 = and i32 %4423, 2139095040, !dbg !1113
  %is_finite1115 = icmp ne i32 %4424, 2139095040, !dbg !1113
  %4425 = and i1 true, %is_finite1115, !dbg !1113
  %4426 = bitcast float %3974 to i32, !dbg !1113
  %4427 = and i32 %4426, 2139095040, !dbg !1113
  %is_finite1116 = icmp ne i32 %4427, 2139095040, !dbg !1113
  %4428 = and i1 %4425, %is_finite1116, !dbg !1113
  %4429 = bitcast float %4422 to i32, !dbg !1113
  %4430 = and i32 %4429, 2139095040, !dbg !1113
  %4431 = icmp eq i32 %4430, 2139095040, !dbg !1113
  %4432 = and i32 %4429, 8388607, !dbg !1113
  %4433 = icmp eq i32 %4432, 0, !dbg !1113
  %is_inf1117 = and i1 %4431, %4433, !dbg !1113
  %4434 = bitcast float %4422 to i32, !dbg !1113
  %4435 = and i32 %4434, 2147483647, !dbg !1113
  %is_maxfinite1118 = icmp eq i32 %4435, 2139095039, !dbg !1113
  %4436 = bitcast float %4422 to i32, !dbg !1113
  %4437 = and i32 %4436, -2147483648, !dbg !1113
  %4438 = icmp eq i32 %4437, 0, !dbg !1113
  %4439 = icmp ne i32 %4437, 0, !dbg !1113
  %is_pos_inf1119 = and i1 %is_inf1117, %4438, !dbg !1113
  %is_neg_inf1120 = and i1 %is_inf1117, %4439, !dbg !1113
  %is_pos_max1121 = and i1 %is_maxfinite1118, %4438, !dbg !1113
  %is_neg_max1122 = and i1 %is_maxfinite1118, %4439, !dbg !1113
  %overflow_cond1123 = and i1 %4428, %is_inf1117, !dbg !1113
  br i1 %overflow_cond1123, label %4440, label %4442, !dbg !1113

4440:                                             ; preds = %4421
  %4441 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4442, !dbg !1113

4442:                                             ; preds = %4421, %4440
  %4443 = bitcast float %4339 to i32, !dbg !1113
  %4444 = and i32 %4443, 2139095040, !dbg !1113
  %4445 = icmp eq i32 %4444, 0, !dbg !1113
  %4446 = and i32 %4443, 8388607, !dbg !1113
  %4447 = icmp ne i32 %4446, 0, !dbg !1113
  %is_subnormal1124 = and i1 %4445, %4447, !dbg !1113
  %4448 = xor i1 %is_subnormal1124, true, !dbg !1113
  %4449 = and i1 true, %4448, !dbg !1113
  %4450 = bitcast float %3974 to i32, !dbg !1113
  %4451 = and i32 %4450, 2139095040, !dbg !1113
  %4452 = icmp eq i32 %4451, 0, !dbg !1113
  %4453 = and i32 %4450, 8388607, !dbg !1113
  %4454 = icmp ne i32 %4453, 0, !dbg !1113
  %is_subnormal1125 = and i1 %4452, %4454, !dbg !1113
  %4455 = xor i1 %is_subnormal1125, true, !dbg !1113
  %4456 = and i1 %4449, %4455, !dbg !1113
  %4457 = and i1 %4456, true, !dbg !1113
  %4458 = bitcast float %4422 to i32, !dbg !1113
  %4459 = and i32 %4458, 2139095040, !dbg !1113
  %4460 = icmp eq i32 %4459, 0, !dbg !1113
  %4461 = and i32 %4458, 8388607, !dbg !1113
  %4462 = icmp ne i32 %4461, 0, !dbg !1113
  %is_subnormal1126 = and i1 %4460, %4462, !dbg !1113
  %is_tiny1127 = or i1 %is_subnormal1126, false, !dbg !1113
  %underflow_cond1128 = and i1 %4457, %is_tiny1127, !dbg !1113
  br i1 %underflow_cond1128, label %4463, label %4465, !dbg !1113

4463:                                             ; preds = %4442
  %4464 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4465, !dbg !1113

4465:                                             ; preds = %4442, %4463
  %4466 = bitcast float %4422 to i32, !dbg !1113
  %4467 = bitcast float %4422 to i32, !dbg !1113
  %4468 = and i32 %4467, 2139095040, !dbg !1113
  %4469 = icmp eq i32 %4468, 2139095040, !dbg !1113
  %4470 = and i32 %4467, 8388607, !dbg !1113
  %4471 = icmp ne i32 %4470, 0, !dbg !1113
  %is_nan1129 = and i1 %4469, %4471, !dbg !1113
  %4472 = and i32 %4466, 4194304, !dbg !1113
  %4473 = icmp eq i32 %4472, 0, !dbg !1113
  %is_snan1130 = and i1 %is_nan1129, %4473, !dbg !1113
  %4474 = bitcast float %3974 to i32, !dbg !1113
  %4475 = bitcast float %3974 to i32, !dbg !1113
  %4476 = and i32 %4475, 2139095040, !dbg !1113
  %4477 = icmp eq i32 %4476, 2139095040, !dbg !1113
  %4478 = and i32 %4475, 8388607, !dbg !1113
  %4479 = icmp ne i32 %4478, 0, !dbg !1113
  %is_nan1131 = and i1 %4477, %4479, !dbg !1113
  %4480 = and i32 %4474, 4194304, !dbg !1113
  %4481 = icmp eq i32 %4480, 0, !dbg !1113
  %is_snan1132 = and i1 %is_nan1131, %4481, !dbg !1113
  %4482 = or i1 %is_snan1130, %is_snan1132, !dbg !1113
  %4483 = or i1 %4482, false, !dbg !1113
  %4484 = bitcast float %4422 to i32, !dbg !1113
  %4485 = and i32 %4484, 2147483647, !dbg !1113
  %is_zero1133 = icmp eq i32 %4485, 0, !dbg !1113
  %4486 = bitcast float %3974 to i32, !dbg !1113
  %4487 = and i32 %4486, 2139095040, !dbg !1113
  %4488 = icmp eq i32 %4487, 2139095040, !dbg !1113
  %4489 = and i32 %4486, 8388607, !dbg !1113
  %4490 = icmp eq i32 %4489, 0, !dbg !1113
  %is_inf1134 = and i1 %4488, %4490, !dbg !1113
  %4491 = and i1 %is_zero1133, %is_inf1134, !dbg !1113
  %4492 = bitcast float %4422 to i32, !dbg !1113
  %4493 = and i32 %4492, 2139095040, !dbg !1113
  %4494 = icmp eq i32 %4493, 2139095040, !dbg !1113
  %4495 = and i32 %4492, 8388607, !dbg !1113
  %4496 = icmp eq i32 %4495, 0, !dbg !1113
  %is_inf1135 = and i1 %4494, %4496, !dbg !1113
  %4497 = bitcast float %3974 to i32, !dbg !1113
  %4498 = and i32 %4497, 2147483647, !dbg !1113
  %is_zero1136 = icmp eq i32 %4498, 0, !dbg !1113
  %4499 = and i1 %is_inf1135, %is_zero1136, !dbg !1113
  %4500 = or i1 %4491, %4499, !dbg !1113
  %4501 = or i1 %4483, %4500, !dbg !1113
  br i1 %4501, label %4502, label %4504, !dbg !1113

4502:                                             ; preds = %4465
  %4503 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4504, !dbg !1113

4504:                                             ; preds = %4465, %4502
  %4505 = call float @llvm.nvvm.fma.rn.f(float %4422, float %3974, float 0x3FD5554F00000000) #5, !dbg !1113
  %4506 = bitcast float %4422 to i32, !dbg !1113
  %4507 = and i32 %4506, 2139095040, !dbg !1113
  %is_finite1137 = icmp ne i32 %4507, 2139095040, !dbg !1113
  %4508 = and i1 true, %is_finite1137, !dbg !1113
  %4509 = bitcast float %3974 to i32, !dbg !1113
  %4510 = and i32 %4509, 2139095040, !dbg !1113
  %is_finite1138 = icmp ne i32 %4510, 2139095040, !dbg !1113
  %4511 = and i1 %4508, %is_finite1138, !dbg !1113
  %4512 = bitcast float %4505 to i32, !dbg !1113
  %4513 = and i32 %4512, 2139095040, !dbg !1113
  %4514 = icmp eq i32 %4513, 2139095040, !dbg !1113
  %4515 = and i32 %4512, 8388607, !dbg !1113
  %4516 = icmp eq i32 %4515, 0, !dbg !1113
  %is_inf1139 = and i1 %4514, %4516, !dbg !1113
  %4517 = bitcast float %4505 to i32, !dbg !1113
  %4518 = and i32 %4517, 2147483647, !dbg !1113
  %is_maxfinite1140 = icmp eq i32 %4518, 2139095039, !dbg !1113
  %4519 = bitcast float %4505 to i32, !dbg !1113
  %4520 = and i32 %4519, -2147483648, !dbg !1113
  %4521 = icmp eq i32 %4520, 0, !dbg !1113
  %4522 = icmp ne i32 %4520, 0, !dbg !1113
  %is_pos_inf1141 = and i1 %is_inf1139, %4521, !dbg !1113
  %is_neg_inf1142 = and i1 %is_inf1139, %4522, !dbg !1113
  %is_pos_max1143 = and i1 %is_maxfinite1140, %4521, !dbg !1113
  %is_neg_max1144 = and i1 %is_maxfinite1140, %4522, !dbg !1113
  %overflow_cond1145 = and i1 %4511, %is_inf1139, !dbg !1113
  br i1 %overflow_cond1145, label %4523, label %4525, !dbg !1113

4523:                                             ; preds = %4504
  %4524 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4525, !dbg !1113

4525:                                             ; preds = %4504, %4523
  %4526 = bitcast float %4422 to i32, !dbg !1113
  %4527 = and i32 %4526, 2139095040, !dbg !1113
  %4528 = icmp eq i32 %4527, 0, !dbg !1113
  %4529 = and i32 %4526, 8388607, !dbg !1113
  %4530 = icmp ne i32 %4529, 0, !dbg !1113
  %is_subnormal1146 = and i1 %4528, %4530, !dbg !1113
  %4531 = xor i1 %is_subnormal1146, true, !dbg !1113
  %4532 = and i1 true, %4531, !dbg !1113
  %4533 = bitcast float %3974 to i32, !dbg !1113
  %4534 = and i32 %4533, 2139095040, !dbg !1113
  %4535 = icmp eq i32 %4534, 0, !dbg !1113
  %4536 = and i32 %4533, 8388607, !dbg !1113
  %4537 = icmp ne i32 %4536, 0, !dbg !1113
  %is_subnormal1147 = and i1 %4535, %4537, !dbg !1113
  %4538 = xor i1 %is_subnormal1147, true, !dbg !1113
  %4539 = and i1 %4532, %4538, !dbg !1113
  %4540 = and i1 %4539, true, !dbg !1113
  %4541 = bitcast float %4505 to i32, !dbg !1113
  %4542 = and i32 %4541, 2139095040, !dbg !1113
  %4543 = icmp eq i32 %4542, 0, !dbg !1113
  %4544 = and i32 %4541, 8388607, !dbg !1113
  %4545 = icmp ne i32 %4544, 0, !dbg !1113
  %is_subnormal1148 = and i1 %4543, %4545, !dbg !1113
  %is_tiny1149 = or i1 %is_subnormal1148, false, !dbg !1113
  %underflow_cond1150 = and i1 %4540, %is_tiny1149, !dbg !1113
  br i1 %underflow_cond1150, label %4546, label %4548, !dbg !1113

4546:                                             ; preds = %4525
  %4547 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4548, !dbg !1113

4548:                                             ; preds = %4525, %4546
  %4549 = bitcast float %4505 to i32, !dbg !1113
  %4550 = bitcast float %4505 to i32, !dbg !1113
  %4551 = and i32 %4550, 2139095040, !dbg !1113
  %4552 = icmp eq i32 %4551, 2139095040, !dbg !1113
  %4553 = and i32 %4550, 8388607, !dbg !1113
  %4554 = icmp ne i32 %4553, 0, !dbg !1113
  %is_nan1151 = and i1 %4552, %4554, !dbg !1113
  %4555 = and i32 %4549, 4194304, !dbg !1113
  %4556 = icmp eq i32 %4555, 0, !dbg !1113
  %is_snan1152 = and i1 %is_nan1151, %4556, !dbg !1113
  %4557 = bitcast float %3974 to i32, !dbg !1113
  %4558 = bitcast float %3974 to i32, !dbg !1113
  %4559 = and i32 %4558, 2139095040, !dbg !1113
  %4560 = icmp eq i32 %4559, 2139095040, !dbg !1113
  %4561 = and i32 %4558, 8388607, !dbg !1113
  %4562 = icmp ne i32 %4561, 0, !dbg !1113
  %is_nan1153 = and i1 %4560, %4562, !dbg !1113
  %4563 = and i32 %4557, 4194304, !dbg !1113
  %4564 = icmp eq i32 %4563, 0, !dbg !1113
  %is_snan1154 = and i1 %is_nan1153, %4564, !dbg !1113
  %4565 = or i1 %is_snan1152, %is_snan1154, !dbg !1113
  %4566 = or i1 %4565, false, !dbg !1113
  %4567 = bitcast float %4505 to i32, !dbg !1113
  %4568 = and i32 %4567, 2147483647, !dbg !1113
  %is_zero1155 = icmp eq i32 %4568, 0, !dbg !1113
  %4569 = bitcast float %3974 to i32, !dbg !1113
  %4570 = and i32 %4569, 2139095040, !dbg !1113
  %4571 = icmp eq i32 %4570, 2139095040, !dbg !1113
  %4572 = and i32 %4569, 8388607, !dbg !1113
  %4573 = icmp eq i32 %4572, 0, !dbg !1113
  %is_inf1156 = and i1 %4571, %4573, !dbg !1113
  %4574 = and i1 %is_zero1155, %is_inf1156, !dbg !1113
  %4575 = bitcast float %4505 to i32, !dbg !1113
  %4576 = and i32 %4575, 2139095040, !dbg !1113
  %4577 = icmp eq i32 %4576, 2139095040, !dbg !1113
  %4578 = and i32 %4575, 8388607, !dbg !1113
  %4579 = icmp eq i32 %4578, 0, !dbg !1113
  %is_inf1157 = and i1 %4577, %4579, !dbg !1113
  %4580 = bitcast float %3974 to i32, !dbg !1113
  %4581 = and i32 %4580, 2147483647, !dbg !1113
  %is_zero1158 = icmp eq i32 %4581, 0, !dbg !1113
  %4582 = and i1 %is_inf1157, %is_zero1158, !dbg !1113
  %4583 = or i1 %4574, %4582, !dbg !1113
  %4584 = or i1 %4566, %4583, !dbg !1113
  br i1 %4584, label %4585, label %4587, !dbg !1113

4585:                                             ; preds = %4548
  %4586 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4587, !dbg !1113

4587:                                             ; preds = %4548, %4585
  %4588 = call float @llvm.nvvm.fma.rn.f(float %4505, float %3974, float -5.000000e-01) #5, !dbg !1113
  %4589 = bitcast float %4505 to i32, !dbg !1113
  %4590 = and i32 %4589, 2139095040, !dbg !1113
  %is_finite1159 = icmp ne i32 %4590, 2139095040, !dbg !1113
  %4591 = and i1 true, %is_finite1159, !dbg !1113
  %4592 = bitcast float %3974 to i32, !dbg !1113
  %4593 = and i32 %4592, 2139095040, !dbg !1113
  %is_finite1160 = icmp ne i32 %4593, 2139095040, !dbg !1113
  %4594 = and i1 %4591, %is_finite1160, !dbg !1113
  %4595 = bitcast float %4588 to i32, !dbg !1113
  %4596 = and i32 %4595, 2139095040, !dbg !1113
  %4597 = icmp eq i32 %4596, 2139095040, !dbg !1113
  %4598 = and i32 %4595, 8388607, !dbg !1113
  %4599 = icmp eq i32 %4598, 0, !dbg !1113
  %is_inf1161 = and i1 %4597, %4599, !dbg !1113
  %4600 = bitcast float %4588 to i32, !dbg !1113
  %4601 = and i32 %4600, 2147483647, !dbg !1113
  %is_maxfinite1162 = icmp eq i32 %4601, 2139095039, !dbg !1113
  %4602 = bitcast float %4588 to i32, !dbg !1113
  %4603 = and i32 %4602, -2147483648, !dbg !1113
  %4604 = icmp eq i32 %4603, 0, !dbg !1113
  %4605 = icmp ne i32 %4603, 0, !dbg !1113
  %is_pos_inf1163 = and i1 %is_inf1161, %4604, !dbg !1113
  %is_neg_inf1164 = and i1 %is_inf1161, %4605, !dbg !1113
  %is_pos_max1165 = and i1 %is_maxfinite1162, %4604, !dbg !1113
  %is_neg_max1166 = and i1 %is_maxfinite1162, %4605, !dbg !1113
  %overflow_cond1167 = and i1 %4594, %is_inf1161, !dbg !1113
  br i1 %overflow_cond1167, label %4606, label %4608, !dbg !1113

4606:                                             ; preds = %4587
  %4607 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4608, !dbg !1113

4608:                                             ; preds = %4587, %4606
  %4609 = bitcast float %4505 to i32, !dbg !1113
  %4610 = and i32 %4609, 2139095040, !dbg !1113
  %4611 = icmp eq i32 %4610, 0, !dbg !1113
  %4612 = and i32 %4609, 8388607, !dbg !1113
  %4613 = icmp ne i32 %4612, 0, !dbg !1113
  %is_subnormal1168 = and i1 %4611, %4613, !dbg !1113
  %4614 = xor i1 %is_subnormal1168, true, !dbg !1113
  %4615 = and i1 true, %4614, !dbg !1113
  %4616 = bitcast float %3974 to i32, !dbg !1113
  %4617 = and i32 %4616, 2139095040, !dbg !1113
  %4618 = icmp eq i32 %4617, 0, !dbg !1113
  %4619 = and i32 %4616, 8388607, !dbg !1113
  %4620 = icmp ne i32 %4619, 0, !dbg !1113
  %is_subnormal1169 = and i1 %4618, %4620, !dbg !1113
  %4621 = xor i1 %is_subnormal1169, true, !dbg !1113
  %4622 = and i1 %4615, %4621, !dbg !1113
  %4623 = and i1 %4622, true, !dbg !1113
  %4624 = bitcast float %4588 to i32, !dbg !1113
  %4625 = and i32 %4624, 2139095040, !dbg !1113
  %4626 = icmp eq i32 %4625, 0, !dbg !1113
  %4627 = and i32 %4624, 8388607, !dbg !1113
  %4628 = icmp ne i32 %4627, 0, !dbg !1113
  %is_subnormal1170 = and i1 %4626, %4628, !dbg !1113
  %is_tiny1171 = or i1 %is_subnormal1170, false, !dbg !1113
  %underflow_cond1172 = and i1 %4623, %is_tiny1171, !dbg !1113
  br i1 %underflow_cond1172, label %4629, label %4631, !dbg !1113

4629:                                             ; preds = %4608
  %4630 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4631, !dbg !1113

4631:                                             ; preds = %4608, %4629
  %4632 = bitcast float %4588 to i32, !dbg !1113
  %4633 = bitcast float %4588 to i32, !dbg !1113
  %4634 = and i32 %4633, 2139095040, !dbg !1113
  %4635 = icmp eq i32 %4634, 2139095040, !dbg !1113
  %4636 = and i32 %4633, 8388607, !dbg !1113
  %4637 = icmp ne i32 %4636, 0, !dbg !1113
  %is_nan1173 = and i1 %4635, %4637, !dbg !1113
  %4638 = and i32 %4632, 4194304, !dbg !1113
  %4639 = icmp eq i32 %4638, 0, !dbg !1113
  %is_snan1174 = and i1 %is_nan1173, %4639, !dbg !1113
  %4640 = bitcast float %3974 to i32, !dbg !1113
  %4641 = bitcast float %3974 to i32, !dbg !1113
  %4642 = and i32 %4641, 2139095040, !dbg !1113
  %4643 = icmp eq i32 %4642, 2139095040, !dbg !1113
  %4644 = and i32 %4641, 8388607, !dbg !1113
  %4645 = icmp ne i32 %4644, 0, !dbg !1113
  %is_nan1175 = and i1 %4643, %4645, !dbg !1113
  %4646 = and i32 %4640, 4194304, !dbg !1113
  %4647 = icmp eq i32 %4646, 0, !dbg !1113
  %is_snan1176 = and i1 %is_nan1175, %4647, !dbg !1113
  %4648 = or i1 %is_snan1174, %is_snan1176, !dbg !1113
  %4649 = bitcast float %4588 to i32, !dbg !1113
  %4650 = and i32 %4649, 2147483647, !dbg !1113
  %is_zero1177 = icmp eq i32 %4650, 0, !dbg !1113
  %4651 = bitcast float %3974 to i32, !dbg !1113
  %4652 = and i32 %4651, 2139095040, !dbg !1113
  %4653 = icmp eq i32 %4652, 2139095040, !dbg !1113
  %4654 = and i32 %4651, 8388607, !dbg !1113
  %4655 = icmp eq i32 %4654, 0, !dbg !1113
  %is_inf1178 = and i1 %4653, %4655, !dbg !1113
  %4656 = and i1 %is_zero1177, %is_inf1178, !dbg !1113
  %4657 = bitcast float %4588 to i32, !dbg !1113
  %4658 = and i32 %4657, 2139095040, !dbg !1113
  %4659 = icmp eq i32 %4658, 2139095040, !dbg !1113
  %4660 = and i32 %4657, 8388607, !dbg !1113
  %4661 = icmp eq i32 %4660, 0, !dbg !1113
  %is_inf1179 = and i1 %4659, %4661, !dbg !1113
  %4662 = bitcast float %3974 to i32, !dbg !1113
  %4663 = and i32 %4662, 2147483647, !dbg !1113
  %is_zero1180 = icmp eq i32 %4663, 0, !dbg !1113
  %4664 = and i1 %is_inf1179, %is_zero1180, !dbg !1113
  %4665 = or i1 %4656, %4664, !dbg !1113
  %4666 = or i1 %4648, %4665, !dbg !1113
  br i1 %4666, label %4667, label %4669, !dbg !1113

4667:                                             ; preds = %4631
  %4668 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4669, !dbg !1113

4669:                                             ; preds = %4631, %4667
  %4670 = fmul float %4588, %3974, !dbg !1113
  %4671 = bitcast float %4588 to i32, !dbg !1113
  %4672 = and i32 %4671, 2139095040, !dbg !1113
  %is_finite1181 = icmp ne i32 %4672, 2139095040, !dbg !1113
  %4673 = and i1 true, %is_finite1181, !dbg !1113
  %4674 = bitcast float %3974 to i32, !dbg !1113
  %4675 = and i32 %4674, 2139095040, !dbg !1113
  %is_finite1182 = icmp ne i32 %4675, 2139095040, !dbg !1113
  %4676 = and i1 %4673, %is_finite1182, !dbg !1113
  %4677 = bitcast float %4670 to i32, !dbg !1113
  %4678 = and i32 %4677, 2139095040, !dbg !1113
  %4679 = icmp eq i32 %4678, 2139095040, !dbg !1113
  %4680 = and i32 %4677, 8388607, !dbg !1113
  %4681 = icmp eq i32 %4680, 0, !dbg !1113
  %is_inf1183 = and i1 %4679, %4681, !dbg !1113
  %4682 = bitcast float %4670 to i32, !dbg !1113
  %4683 = and i32 %4682, 2147483647, !dbg !1113
  %is_maxfinite1184 = icmp eq i32 %4683, 2139095039, !dbg !1113
  %4684 = bitcast float %4670 to i32, !dbg !1113
  %4685 = and i32 %4684, -2147483648, !dbg !1113
  %4686 = icmp eq i32 %4685, 0, !dbg !1113
  %4687 = icmp ne i32 %4685, 0, !dbg !1113
  %is_pos_inf1185 = and i1 %is_inf1183, %4686, !dbg !1113
  %is_neg_inf1186 = and i1 %is_inf1183, %4687, !dbg !1113
  %is_pos_max1187 = and i1 %is_maxfinite1184, %4686, !dbg !1113
  %is_neg_max1188 = and i1 %is_maxfinite1184, %4687, !dbg !1113
  %overflow_cond1189 = and i1 %4676, %is_inf1183, !dbg !1113
  br i1 %overflow_cond1189, label %4688, label %4690, !dbg !1113

4688:                                             ; preds = %4669
  %4689 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4690, !dbg !1113

4690:                                             ; preds = %4669, %4688
  %4691 = bitcast float %4588 to i32, !dbg !1113
  %4692 = and i32 %4691, 2139095040, !dbg !1113
  %4693 = icmp eq i32 %4692, 0, !dbg !1113
  %4694 = and i32 %4691, 8388607, !dbg !1113
  %4695 = icmp ne i32 %4694, 0, !dbg !1113
  %is_subnormal1190 = and i1 %4693, %4695, !dbg !1113
  %4696 = xor i1 %is_subnormal1190, true, !dbg !1113
  %4697 = and i1 true, %4696, !dbg !1113
  %4698 = bitcast float %3974 to i32, !dbg !1113
  %4699 = and i32 %4698, 2139095040, !dbg !1113
  %4700 = icmp eq i32 %4699, 0, !dbg !1113
  %4701 = and i32 %4698, 8388607, !dbg !1113
  %4702 = icmp ne i32 %4701, 0, !dbg !1113
  %is_subnormal1191 = and i1 %4700, %4702, !dbg !1113
  %4703 = xor i1 %is_subnormal1191, true, !dbg !1113
  %4704 = and i1 %4697, %4703, !dbg !1113
  %4705 = bitcast float %4670 to i32, !dbg !1113
  %4706 = and i32 %4705, 2139095040, !dbg !1113
  %4707 = icmp eq i32 %4706, 0, !dbg !1113
  %4708 = and i32 %4705, 8388607, !dbg !1113
  %4709 = icmp ne i32 %4708, 0, !dbg !1113
  %is_subnormal1192 = and i1 %4707, %4709, !dbg !1113
  %4710 = bitcast float %4670 to i32, !dbg !1113
  %4711 = and i32 %4710, 2147483647, !dbg !1113
  %is_zero1193 = icmp eq i32 %4711, 0, !dbg !1113
  %4712 = bitcast float %4588 to i32, !dbg !1113
  %4713 = and i32 %4712, 2147483647, !dbg !1113
  %is_zero1194 = icmp eq i32 %4713, 0, !dbg !1113
  %4714 = xor i1 %is_zero1194, true, !dbg !1113
  %4715 = bitcast float %3974 to i32, !dbg !1113
  %4716 = and i32 %4715, 2147483647, !dbg !1113
  %is_zero1195 = icmp eq i32 %4716, 0, !dbg !1113
  %4717 = xor i1 %is_zero1195, true, !dbg !1113
  %4718 = and i1 %4714, %4717, !dbg !1113
  %4719 = and i1 %is_zero1193, %4718, !dbg !1113
  %is_tiny1196 = or i1 %is_subnormal1192, %4719, !dbg !1113
  %underflow_cond1197 = and i1 %4704, %is_tiny1196, !dbg !1113
  br i1 %underflow_cond1197, label %4720, label %4722, !dbg !1113

4720:                                             ; preds = %4690
  %4721 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4722, !dbg !1113

4722:                                             ; preds = %4690, %4720
  %4723 = bitcast float %4670 to i32, !dbg !1113
  %4724 = bitcast float %4670 to i32, !dbg !1113
  %4725 = and i32 %4724, 2139095040, !dbg !1113
  %4726 = icmp eq i32 %4725, 2139095040, !dbg !1113
  %4727 = and i32 %4724, 8388607, !dbg !1113
  %4728 = icmp ne i32 %4727, 0, !dbg !1113
  %is_nan1198 = and i1 %4726, %4728, !dbg !1113
  %4729 = and i32 %4723, 4194304, !dbg !1113
  %4730 = icmp eq i32 %4729, 0, !dbg !1113
  %is_snan1199 = and i1 %is_nan1198, %4730, !dbg !1113
  %4731 = bitcast float %3974 to i32, !dbg !1113
  %4732 = bitcast float %3974 to i32, !dbg !1113
  %4733 = and i32 %4732, 2139095040, !dbg !1113
  %4734 = icmp eq i32 %4733, 2139095040, !dbg !1113
  %4735 = and i32 %4732, 8388607, !dbg !1113
  %4736 = icmp ne i32 %4735, 0, !dbg !1113
  %is_nan1200 = and i1 %4734, %4736, !dbg !1113
  %4737 = and i32 %4731, 4194304, !dbg !1113
  %4738 = icmp eq i32 %4737, 0, !dbg !1113
  %is_snan1201 = and i1 %is_nan1200, %4738, !dbg !1113
  %4739 = or i1 %is_snan1199, %is_snan1201, !dbg !1113
  %4740 = bitcast float %3974 to i32, !dbg !1113
  %4741 = bitcast float %3974 to i32, !dbg !1113
  %4742 = and i32 %4741, 2139095040, !dbg !1113
  %4743 = icmp eq i32 %4742, 2139095040, !dbg !1113
  %4744 = and i32 %4741, 8388607, !dbg !1113
  %4745 = icmp ne i32 %4744, 0, !dbg !1113
  %is_nan1202 = and i1 %4743, %4745, !dbg !1113
  %4746 = and i32 %4740, 4194304, !dbg !1113
  %4747 = icmp eq i32 %4746, 0, !dbg !1113
  %is_snan1203 = and i1 %is_nan1202, %4747, !dbg !1113
  %4748 = or i1 %4739, %is_snan1203, !dbg !1113
  %4749 = bitcast float %4670 to i32, !dbg !1113
  %4750 = and i32 %4749, 2147483647, !dbg !1113
  %is_zero1204 = icmp eq i32 %4750, 0, !dbg !1113
  %4751 = bitcast float %3974 to i32, !dbg !1113
  %4752 = and i32 %4751, 2139095040, !dbg !1113
  %4753 = icmp eq i32 %4752, 2139095040, !dbg !1113
  %4754 = and i32 %4751, 8388607, !dbg !1113
  %4755 = icmp eq i32 %4754, 0, !dbg !1113
  %is_inf1205 = and i1 %4753, %4755, !dbg !1113
  %4756 = and i1 %is_zero1204, %is_inf1205, !dbg !1113
  %4757 = bitcast float %4670 to i32, !dbg !1113
  %4758 = and i32 %4757, 2139095040, !dbg !1113
  %4759 = icmp eq i32 %4758, 2139095040, !dbg !1113
  %4760 = and i32 %4757, 8388607, !dbg !1113
  %4761 = icmp eq i32 %4760, 0, !dbg !1113
  %is_inf1206 = and i1 %4759, %4761, !dbg !1113
  %4762 = bitcast float %3974 to i32, !dbg !1113
  %4763 = and i32 %4762, 2147483647, !dbg !1113
  %is_zero1207 = icmp eq i32 %4763, 0, !dbg !1113
  %4764 = and i1 %is_inf1206, %is_zero1207, !dbg !1113
  %4765 = or i1 %4756, %4764, !dbg !1113
  %4766 = or i1 %4748, %4765, !dbg !1113
  br i1 %4766, label %4767, label %4769, !dbg !1113

4767:                                             ; preds = %4722
  %4768 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4769, !dbg !1113

4769:                                             ; preds = %4722, %4767
  %4770 = call float @llvm.nvvm.fma.rn.f(float %4670, float %3974, float %3974) #5, !dbg !1113
  %4771 = bitcast float %4670 to i32, !dbg !1113
  %4772 = and i32 %4771, 2139095040, !dbg !1113
  %is_finite1208 = icmp ne i32 %4772, 2139095040, !dbg !1113
  %4773 = and i1 true, %is_finite1208, !dbg !1113
  %4774 = bitcast float %3974 to i32, !dbg !1113
  %4775 = and i32 %4774, 2139095040, !dbg !1113
  %is_finite1209 = icmp ne i32 %4775, 2139095040, !dbg !1113
  %4776 = and i1 %4773, %is_finite1209, !dbg !1113
  %4777 = bitcast float %4770 to i32, !dbg !1113
  %4778 = and i32 %4777, 2139095040, !dbg !1113
  %4779 = icmp eq i32 %4778, 2139095040, !dbg !1113
  %4780 = and i32 %4777, 8388607, !dbg !1113
  %4781 = icmp eq i32 %4780, 0, !dbg !1113
  %is_inf1210 = and i1 %4779, %4781, !dbg !1113
  %4782 = bitcast float %4770 to i32, !dbg !1113
  %4783 = and i32 %4782, 2147483647, !dbg !1113
  %is_maxfinite1211 = icmp eq i32 %4783, 2139095039, !dbg !1113
  %4784 = bitcast float %4770 to i32, !dbg !1113
  %4785 = and i32 %4784, -2147483648, !dbg !1113
  %4786 = icmp eq i32 %4785, 0, !dbg !1113
  %4787 = icmp ne i32 %4785, 0, !dbg !1113
  %is_pos_inf1212 = and i1 %is_inf1210, %4786, !dbg !1113
  %is_neg_inf1213 = and i1 %is_inf1210, %4787, !dbg !1113
  %is_pos_max1214 = and i1 %is_maxfinite1211, %4786, !dbg !1113
  %is_neg_max1215 = and i1 %is_maxfinite1211, %4787, !dbg !1113
  %overflow_cond1216 = and i1 %4776, %is_inf1210, !dbg !1113
  br i1 %overflow_cond1216, label %4788, label %4790, !dbg !1113

4788:                                             ; preds = %4769
  %4789 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4790, !dbg !1113

4790:                                             ; preds = %4769, %4788
  %4791 = bitcast float %4670 to i32, !dbg !1113
  %4792 = and i32 %4791, 2139095040, !dbg !1113
  %4793 = icmp eq i32 %4792, 0, !dbg !1113
  %4794 = and i32 %4791, 8388607, !dbg !1113
  %4795 = icmp ne i32 %4794, 0, !dbg !1113
  %is_subnormal1217 = and i1 %4793, %4795, !dbg !1113
  %4796 = xor i1 %is_subnormal1217, true, !dbg !1113
  %4797 = and i1 true, %4796, !dbg !1113
  %4798 = bitcast float %3974 to i32, !dbg !1113
  %4799 = and i32 %4798, 2139095040, !dbg !1113
  %4800 = icmp eq i32 %4799, 0, !dbg !1113
  %4801 = and i32 %4798, 8388607, !dbg !1113
  %4802 = icmp ne i32 %4801, 0, !dbg !1113
  %is_subnormal1218 = and i1 %4800, %4802, !dbg !1113
  %4803 = xor i1 %is_subnormal1218, true, !dbg !1113
  %4804 = and i1 %4797, %4803, !dbg !1113
  %4805 = bitcast float %3974 to i32, !dbg !1113
  %4806 = and i32 %4805, 2139095040, !dbg !1113
  %4807 = icmp eq i32 %4806, 0, !dbg !1113
  %4808 = and i32 %4805, 8388607, !dbg !1113
  %4809 = icmp ne i32 %4808, 0, !dbg !1113
  %is_subnormal1219 = and i1 %4807, %4809, !dbg !1113
  %4810 = xor i1 %is_subnormal1219, true, !dbg !1113
  %4811 = and i1 %4804, %4810, !dbg !1113
  %4812 = bitcast float %4770 to i32, !dbg !1113
  %4813 = and i32 %4812, 2139095040, !dbg !1113
  %4814 = icmp eq i32 %4813, 0, !dbg !1113
  %4815 = and i32 %4812, 8388607, !dbg !1113
  %4816 = icmp ne i32 %4815, 0, !dbg !1113
  %is_subnormal1220 = and i1 %4814, %4816, !dbg !1113
  %is_tiny1221 = or i1 %is_subnormal1220, false, !dbg !1113
  %underflow_cond1222 = and i1 %4811, %is_tiny1221, !dbg !1113
  br i1 %underflow_cond1222, label %4817, label %4819, !dbg !1113

4817:                                             ; preds = %4790
  %4818 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4819, !dbg !1113

4819:                                             ; preds = %4790, %4817
  %4820 = bitcast float %3909 to i32, !dbg !1113
  %4821 = bitcast float %3909 to i32, !dbg !1113
  %4822 = and i32 %4821, 2139095040, !dbg !1113
  %4823 = icmp eq i32 %4822, 2139095040, !dbg !1113
  %4824 = and i32 %4821, 8388607, !dbg !1113
  %4825 = icmp ne i32 %4824, 0, !dbg !1113
  %is_nan1223 = and i1 %4823, %4825, !dbg !1113
  %4826 = and i32 %4820, 4194304, !dbg !1113
  %4827 = icmp eq i32 %4826, 0, !dbg !1113
  %is_snan1224 = and i1 %is_nan1223, %4827, !dbg !1113
  %4828 = or i1 %is_snan1224, false, !dbg !1113
  %4829 = bitcast float %4770 to i32, !dbg !1113
  %4830 = bitcast float %4770 to i32, !dbg !1113
  %4831 = and i32 %4830, 2139095040, !dbg !1113
  %4832 = icmp eq i32 %4831, 2139095040, !dbg !1113
  %4833 = and i32 %4830, 8388607, !dbg !1113
  %4834 = icmp ne i32 %4833, 0, !dbg !1113
  %is_nan1225 = and i1 %4832, %4834, !dbg !1113
  %4835 = and i32 %4829, 4194304, !dbg !1113
  %4836 = icmp eq i32 %4835, 0, !dbg !1113
  %is_snan1226 = and i1 %is_nan1225, %4836, !dbg !1113
  %4837 = or i1 %4828, %is_snan1226, !dbg !1113
  %4838 = bitcast float %3909 to i32, !dbg !1113
  %4839 = and i32 %4838, 2147483647, !dbg !1113
  %is_zero1227 = icmp eq i32 %4839, 0, !dbg !1113
  %4840 = and i1 %is_zero1227, false, !dbg !1113
  %4841 = bitcast float %3909 to i32, !dbg !1113
  %4842 = and i32 %4841, 2139095040, !dbg !1113
  %4843 = icmp eq i32 %4842, 2139095040, !dbg !1113
  %4844 = and i32 %4841, 8388607, !dbg !1113
  %4845 = icmp eq i32 %4844, 0, !dbg !1113
  %is_inf1228 = and i1 %4843, %4845, !dbg !1113
  %4846 = and i1 %is_inf1228, false, !dbg !1113
  %4847 = or i1 %4840, %4846, !dbg !1113
  %4848 = or i1 %4837, %4847, !dbg !1113
  br i1 %4848, label %4849, label %4851, !dbg !1113

4849:                                             ; preds = %4819
  %4850 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4851, !dbg !1113

4851:                                             ; preds = %4819, %4849
  %4852 = call float @llvm.nvvm.fma.rn.f(float %3909, float 0x3FE62E4300000000, float %4770) #5, !dbg !1113
  %4853 = bitcast float %3909 to i32, !dbg !1113
  %4854 = and i32 %4853, 2139095040, !dbg !1113
  %is_finite1229 = icmp ne i32 %4854, 2139095040, !dbg !1113
  %4855 = and i1 true, %is_finite1229, !dbg !1113
  %4856 = and i1 %4855, true, !dbg !1113
  %4857 = bitcast float %4852 to i32, !dbg !1113
  %4858 = and i32 %4857, 2139095040, !dbg !1113
  %4859 = icmp eq i32 %4858, 2139095040, !dbg !1113
  %4860 = and i32 %4857, 8388607, !dbg !1113
  %4861 = icmp eq i32 %4860, 0, !dbg !1113
  %is_inf1230 = and i1 %4859, %4861, !dbg !1113
  %4862 = bitcast float %4852 to i32, !dbg !1113
  %4863 = and i32 %4862, 2147483647, !dbg !1113
  %is_maxfinite1231 = icmp eq i32 %4863, 2139095039, !dbg !1113
  %4864 = bitcast float %4852 to i32, !dbg !1113
  %4865 = and i32 %4864, -2147483648, !dbg !1113
  %4866 = icmp eq i32 %4865, 0, !dbg !1113
  %4867 = icmp ne i32 %4865, 0, !dbg !1113
  %is_pos_inf1232 = and i1 %is_inf1230, %4866, !dbg !1113
  %is_neg_inf1233 = and i1 %is_inf1230, %4867, !dbg !1113
  %is_pos_max1234 = and i1 %is_maxfinite1231, %4866, !dbg !1113
  %is_neg_max1235 = and i1 %is_maxfinite1231, %4867, !dbg !1113
  %overflow_cond1236 = and i1 %4856, %is_inf1230, !dbg !1113
  br i1 %overflow_cond1236, label %4868, label %4870, !dbg !1113

4868:                                             ; preds = %4851
  %4869 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4870, !dbg !1113

4870:                                             ; preds = %4851, %4868
  %4871 = bitcast float %3909 to i32, !dbg !1113
  %4872 = and i32 %4871, 2139095040, !dbg !1113
  %4873 = icmp eq i32 %4872, 0, !dbg !1113
  %4874 = and i32 %4871, 8388607, !dbg !1113
  %4875 = icmp ne i32 %4874, 0, !dbg !1113
  %is_subnormal1237 = and i1 %4873, %4875, !dbg !1113
  %4876 = xor i1 %is_subnormal1237, true, !dbg !1113
  %4877 = and i1 true, %4876, !dbg !1113
  %4878 = and i1 %4877, true, !dbg !1113
  %4879 = bitcast float %4770 to i32, !dbg !1113
  %4880 = and i32 %4879, 2139095040, !dbg !1113
  %4881 = icmp eq i32 %4880, 0, !dbg !1113
  %4882 = and i32 %4879, 8388607, !dbg !1113
  %4883 = icmp ne i32 %4882, 0, !dbg !1113
  %is_subnormal1238 = and i1 %4881, %4883, !dbg !1113
  %4884 = xor i1 %is_subnormal1238, true, !dbg !1113
  %4885 = and i1 %4878, %4884, !dbg !1113
  %4886 = bitcast float %4852 to i32, !dbg !1113
  %4887 = and i32 %4886, 2139095040, !dbg !1113
  %4888 = icmp eq i32 %4887, 0, !dbg !1113
  %4889 = and i32 %4886, 8388607, !dbg !1113
  %4890 = icmp ne i32 %4889, 0, !dbg !1113
  %is_subnormal1239 = and i1 %4888, %4890, !dbg !1113
  %is_tiny1240 = or i1 %is_subnormal1239, false, !dbg !1113
  %underflow_cond1241 = and i1 %4885, %is_tiny1240, !dbg !1113
  br i1 %underflow_cond1241, label %4891, label %4893, !dbg !1113

4891:                                             ; preds = %4870
  %4892 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4893, !dbg !1113

4893:                                             ; preds = %4870, %4891
  %4894 = bitcast float %.02.i to i32, !dbg !1113
  %4895 = icmp uge i32 %4894, 2139095040, !dbg !1113
  br i1 %4895, label %4896, label %4957, !dbg !1113

4896:                                             ; preds = %4893
  %4897 = bitcast float %.02.i to i32, !dbg !1113
  %4898 = bitcast float %.02.i to i32, !dbg !1113
  %4899 = and i32 %4898, 2139095040, !dbg !1113
  %4900 = icmp eq i32 %4899, 2139095040, !dbg !1113
  %4901 = and i32 %4898, 8388607, !dbg !1113
  %4902 = icmp ne i32 %4901, 0, !dbg !1113
  %is_nan1242 = and i1 %4900, %4902, !dbg !1113
  %4903 = and i32 %4897, 4194304, !dbg !1113
  %4904 = icmp eq i32 %4903, 0, !dbg !1113
  %is_snan1243 = and i1 %is_nan1242, %4904, !dbg !1113
  %4905 = or i1 %is_snan1243, false, !dbg !1113
  %4906 = or i1 %4905, false, !dbg !1113
  %4907 = bitcast float %.02.i to i32, !dbg !1113
  %4908 = and i32 %4907, 2147483647, !dbg !1113
  %is_zero1244 = icmp eq i32 %4908, 0, !dbg !1113
  %4909 = and i1 %is_zero1244, true, !dbg !1113
  %4910 = bitcast float %.02.i to i32, !dbg !1113
  %4911 = and i32 %4910, 2139095040, !dbg !1113
  %4912 = icmp eq i32 %4911, 2139095040, !dbg !1113
  %4913 = and i32 %4910, 8388607, !dbg !1113
  %4914 = icmp eq i32 %4913, 0, !dbg !1113
  %is_inf1245 = and i1 %4912, %4914, !dbg !1113
  %4915 = and i1 %is_inf1245, false, !dbg !1113
  %4916 = or i1 %4909, %4915, !dbg !1113
  %4917 = or i1 %4906, %4916, !dbg !1113
  br i1 %4917, label %4918, label %4920, !dbg !1113

4918:                                             ; preds = %4896
  %4919 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4920, !dbg !1113

4920:                                             ; preds = %4896, %4918
  %4921 = call float @llvm.nvvm.fma.rn.f(float %.02.i, float 0x7FF0000000000000, float 0x7FF0000000000000) #5, !dbg !1113
  %4922 = bitcast float %.02.i to i32, !dbg !1113
  %4923 = and i32 %4922, 2139095040, !dbg !1113
  %is_finite1246 = icmp ne i32 %4923, 2139095040, !dbg !1113
  %4924 = and i1 true, %is_finite1246, !dbg !1113
  %4925 = and i1 %4924, false, !dbg !1113
  %4926 = bitcast float %4921 to i32, !dbg !1113
  %4927 = and i32 %4926, 2139095040, !dbg !1113
  %4928 = icmp eq i32 %4927, 2139095040, !dbg !1113
  %4929 = and i32 %4926, 8388607, !dbg !1113
  %4930 = icmp eq i32 %4929, 0, !dbg !1113
  %is_inf1247 = and i1 %4928, %4930, !dbg !1113
  %4931 = bitcast float %4921 to i32, !dbg !1113
  %4932 = and i32 %4931, 2147483647, !dbg !1113
  %is_maxfinite1248 = icmp eq i32 %4932, 2139095039, !dbg !1113
  %4933 = bitcast float %4921 to i32, !dbg !1113
  %4934 = and i32 %4933, -2147483648, !dbg !1113
  %4935 = icmp eq i32 %4934, 0, !dbg !1113
  %4936 = icmp ne i32 %4934, 0, !dbg !1113
  %is_pos_inf1249 = and i1 %is_inf1247, %4935, !dbg !1113
  %is_neg_inf1250 = and i1 %is_inf1247, %4936, !dbg !1113
  %is_pos_max1251 = and i1 %is_maxfinite1248, %4935, !dbg !1113
  %is_neg_max1252 = and i1 %is_maxfinite1248, %4936, !dbg !1113
  %overflow_cond1253 = and i1 %4925, %is_inf1247, !dbg !1113
  br i1 %overflow_cond1253, label %4937, label %4939, !dbg !1113

4937:                                             ; preds = %4920
  %4938 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4939, !dbg !1113

4939:                                             ; preds = %4920, %4937
  %4940 = bitcast float %.02.i to i32, !dbg !1113
  %4941 = and i32 %4940, 2139095040, !dbg !1113
  %4942 = icmp eq i32 %4941, 0, !dbg !1113
  %4943 = and i32 %4940, 8388607, !dbg !1113
  %4944 = icmp ne i32 %4943, 0, !dbg !1113
  %is_subnormal1254 = and i1 %4942, %4944, !dbg !1113
  %4945 = xor i1 %is_subnormal1254, true, !dbg !1113
  %4946 = and i1 true, %4945, !dbg !1113
  %4947 = and i1 %4946, true, !dbg !1113
  %4948 = and i1 %4947, true, !dbg !1113
  %4949 = bitcast float %4921 to i32, !dbg !1113
  %4950 = and i32 %4949, 2139095040, !dbg !1113
  %4951 = icmp eq i32 %4950, 0, !dbg !1113
  %4952 = and i32 %4949, 8388607, !dbg !1113
  %4953 = icmp ne i32 %4952, 0, !dbg !1113
  %is_subnormal1255 = and i1 %4951, %4953, !dbg !1113
  %is_tiny1256 = or i1 %is_subnormal1255, false, !dbg !1113
  %underflow_cond1257 = and i1 %4948, %is_tiny1256, !dbg !1113
  br i1 %underflow_cond1257, label %4954, label %4956, !dbg !1113

4954:                                             ; preds = %4939
  %4955 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4956, !dbg !1113

4956:                                             ; preds = %4939, %4954
  br label %4957, !dbg !1113

4957:                                             ; preds = %4956, %4893
  %r.i.0.i = phi float [ %4921, %4956 ], [ %4852, %4893 ], !dbg !1113
  %4958 = fcmp oeq float %.02.i, 0.000000e+00, !dbg !1113
  br i1 %4958, label %4959, label %__nv_logf.exit, !dbg !1113

4959:                                             ; preds = %4957
  br label %__nv_logf.exit, !dbg !1113

__nv_logf.exit:                                   ; preds = %4957, %4959
  %r.i.1.i = phi float [ 0xFFF0000000000000, %4959 ], [ %r.i.0.i, %4957 ], !dbg !1113
  %4960 = load ptr, ptr %result.addr, align 8, !dbg !1114
  %arrayidx58 = getelementptr inbounds float, ptr %4960, i64 7, !dbg !1114
  store float %r.i.1.i, ptr %arrayidx58, align 4, !dbg !1115
  %4961 = load ptr, ptr %result.addr, align 8, !dbg !1116
  %arrayidx59 = getelementptr inbounds float, ptr %4961, i64 7, !dbg !1116
  %4962 = load float, ptr %arrayidx59, align 4, !dbg !1116
  %call60 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %4962) #4, !dbg !1117
  %4963 = zext i1 %call60 to i64, !dbg !1117
  %cond61 = select i1 %call60, i32 1, i32 0, !dbg !1117
  %4964 = load ptr, ptr %is_denorm.addr, align 8, !dbg !1118
  %arrayidx62 = getelementptr inbounds i32, ptr %4964, i64 7, !dbg !1118
  store i32 %cond61, ptr %arrayidx62, align 4, !dbg !1119
  br label %if.end63, !dbg !1120

if.end63:                                         ; preds = %__nv_logf.exit, %if.end54
  ret void, !dbg !1121
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare noundef range(i32 0, 1024) i32 @llvm.nvvm.read.ptx.sreg.tid.x() #1

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(none)
declare float @llvm.nvvm.sqrt.approx.f(float) #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.fma.rn.f(float, float, float) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.saturate.f(float) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.fma.rm.f(float, float, float) #1

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(none)
declare float @llvm.nvvm.ex2.approx.ftz.f32(float) #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.trunc.f(float) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.mul.rn.f(float, float) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.add.rn.f(float, float) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.round.f(float) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.floor.f(float) #1

attributes #0 = { convergent noinline nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_80" "target-features"="+ptx87,+sm_80" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { convergent noinline norecurse nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_80" "target-features"="+ptx87,+sm_80" "uniform-work-group-size"="true" }
attributes #3 = { nocallback nofree nosync nounwind willreturn memory(none) }
attributes #4 = { convergent nounwind }
attributes #5 = { nounwind }
attributes #6 = { nounwind memory(none) }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!954, !955}
!nvvmir.version = !{!956}
!llvm.module.flags = !{!957, !958, !959, !960, !961, !962}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !1, producer: "clang version 22.1.5 (https://github.com/llvm/llvm-project.git 5ea218a153f4d2f815b8244eab3e4b4ba5e00e6c)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !27, imports: !91, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "tests/basic_tests/underflow/basic.cu", directory: "/home/users/sislam3/SBAC-PAD")
!2 = !{!3}
!3 = distinct !DICompositeType(tag: DW_TAG_enumeration_type, name: "sm_selector", scope: !5, file: !4, line: 84, baseType: !8, size: 64, flags: DIFlagEnumClass, elements: !10, identifier: "_ZTSN2nv6target6detail11sm_selectorE")
!4 = !DIFile(filename: "/storage/packages/cuda/12.8.1/include/nv/target", directory: "")
!5 = !DINamespace(name: "detail", scope: !6)
!6 = !DINamespace(name: "target", scope: !7)
!7 = !DINamespace(name: "nv", scope: null)
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "base_int_t", scope: !5, file: !4, line: 47, baseType: !9)
!9 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!10 = !{!11, !12, !13, !14, !15, !16, !17, !18, !19, !20, !21, !22, !23, !24, !25, !26}
!11 = !DIEnumerator(name: "sm_35", value: 35, isUnsigned: true)
!12 = !DIEnumerator(name: "sm_37", value: 37, isUnsigned: true)
!13 = !DIEnumerator(name: "sm_50", value: 50, isUnsigned: true)
!14 = !DIEnumerator(name: "sm_52", value: 52, isUnsigned: true)
!15 = !DIEnumerator(name: "sm_53", value: 53, isUnsigned: true)
!16 = !DIEnumerator(name: "sm_60", value: 60, isUnsigned: true)
!17 = !DIEnumerator(name: "sm_61", value: 61, isUnsigned: true)
!18 = !DIEnumerator(name: "sm_62", value: 62, isUnsigned: true)
!19 = !DIEnumerator(name: "sm_70", value: 70, isUnsigned: true)
!20 = !DIEnumerator(name: "sm_72", value: 72, isUnsigned: true)
!21 = !DIEnumerator(name: "sm_75", value: 75, isUnsigned: true)
!22 = !DIEnumerator(name: "sm_80", value: 80, isUnsigned: true)
!23 = !DIEnumerator(name: "sm_86", value: 86, isUnsigned: true)
!24 = !DIEnumerator(name: "sm_87", value: 87, isUnsigned: true)
!25 = !DIEnumerator(name: "sm_89", value: 89, isUnsigned: true)
!26 = !DIEnumerator(name: "sm_90", value: 90, isUnsigned: true)
!27 = !{!28, !35, !60}
!28 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "target_description", scope: !5, file: !4, line: 74, size: 64, flags: DIFlagTypePassByValue | DIFlagNonTrivial, elements: !29, identifier: "_ZTSN2nv6target6detail18target_descriptionE")
!29 = !{!30, !31}
!30 = !DIDerivedType(tag: DW_TAG_member, name: "targets", scope: !28, file: !4, line: 76, baseType: !8, size: 64)
!31 = !DISubprogram(name: "target_description", linkageName: "_ZN2nv6target6detail18target_descriptionC4Ey", scope: !28, file: !4, line: 78, type: !32, scopeLine: 78, flags: DIFlagPrototyped, spFlags: 0)
!32 = !DISubroutineType(types: !33)
!33 = !{null, !34, !8}
!34 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !28, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!35 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "dim3", file: !36, line: 426, size: 96, flags: DIFlagTypePassByValue | DIFlagNonTrivial, elements: !37, identifier: "_ZTS4dim3")
!36 = !DIFile(filename: "/storage/packages/cuda/12.8.1/include/vector_types.h", directory: "")
!37 = !{!38, !40, !41, !42, !46, !55}
!38 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !35, file: !36, line: 428, baseType: !39, size: 32)
!39 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!40 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !35, file: !36, line: 428, baseType: !39, size: 32, offset: 32)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !35, file: !36, line: 428, baseType: !39, size: 32, offset: 64)
!42 = !DISubprogram(name: "dim3", linkageName: "_ZN4dim3C4Ejjj", scope: !35, file: !36, line: 431, type: !43, scopeLine: 431, flags: DIFlagPrototyped, spFlags: 0)
!43 = !DISubroutineType(types: !44)
!44 = !{null, !45, !39, !39, !39}
!45 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !35, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!46 = !DISubprogram(name: "dim3", linkageName: "_ZN4dim3C4E5uint3", scope: !35, file: !36, line: 432, type: !47, scopeLine: 432, flags: DIFlagPrototyped, spFlags: 0)
!47 = !DISubroutineType(types: !48)
!48 = !{null, !45, !49}
!49 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint3", file: !36, line: 388, baseType: !50)
!50 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "uint3", file: !36, line: 196, size: 96, flags: DIFlagTypePassByValue, elements: !51, identifier: "_ZTS5uint3")
!51 = !{!52, !53, !54}
!52 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !50, file: !36, line: 198, baseType: !39, size: 32)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !50, file: !36, line: 198, baseType: !39, size: 32, offset: 32)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !50, file: !36, line: 198, baseType: !39, size: 32, offset: 64)
!55 = !DISubprogram(name: "operator uint3", linkageName: "_ZNK4dim3cv5uint3Ev", scope: !35, file: !36, line: 433, type: !56, scopeLine: 433, flags: DIFlagPrototyped, spFlags: 0)
!56 = !DISubroutineType(types: !57)
!57 = !{!49, !58}
!58 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !59, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!59 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !35)
!60 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__cuda_builtin_threadIdx_t", file: !61, line: 52, size: 8, flags: DIFlagTypePassByReference, elements: !62, identifier: "_ZTS26__cuda_builtin_threadIdx_t")
!61 = !DIFile(filename: "/storage/users/sislam3/opt/llvm-22/lib/clang/22/include/__clang_cuda_builtin_vars.h", directory: "")
!62 = !{!63, !66, !67, !68, !73, !76, !80, !84, !87}
!63 = !DISubprogram(name: "__fetch_builtin_x", linkageName: "_ZN26__cuda_builtin_threadIdx_t17__fetch_builtin_xEv", scope: !60, file: !61, line: 53, type: !64, scopeLine: 53, flags: DIFlagPrototyped | DIFlagStaticMember, spFlags: 0)
!64 = !DISubroutineType(types: !65)
!65 = !{!39}
!66 = !DISubprogram(name: "__fetch_builtin_y", linkageName: "_ZN26__cuda_builtin_threadIdx_t17__fetch_builtin_yEv", scope: !60, file: !61, line: 54, type: !64, scopeLine: 54, flags: DIFlagPrototyped | DIFlagStaticMember, spFlags: 0)
!67 = !DISubprogram(name: "__fetch_builtin_z", linkageName: "_ZN26__cuda_builtin_threadIdx_t17__fetch_builtin_zEv", scope: !60, file: !61, line: 55, type: !64, scopeLine: 55, flags: DIFlagPrototyped | DIFlagStaticMember, spFlags: 0)
!68 = !DISubprogram(name: "operator dim3", linkageName: "_ZNK26__cuda_builtin_threadIdx_tcv4dim3Ev", scope: !60, file: !61, line: 58, type: !69, scopeLine: 58, flags: DIFlagPrototyped, spFlags: 0)
!69 = !DISubroutineType(types: !70)
!70 = !{!35, !71}
!71 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !72, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!72 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !60)
!73 = !DISubprogram(name: "operator uint3", linkageName: "_ZNK26__cuda_builtin_threadIdx_tcv5uint3Ev", scope: !60, file: !61, line: 59, type: !74, scopeLine: 59, flags: DIFlagPrototyped, spFlags: 0)
!74 = !DISubroutineType(types: !75)
!75 = !{!50, !71}
!76 = !DISubprogram(name: "__cuda_builtin_threadIdx_t", linkageName: "_ZN26__cuda_builtin_threadIdx_tC4Ev", scope: !60, file: !61, line: 62, type: !77, scopeLine: 62, flags: DIFlagPrivate | DIFlagPrototyped, spFlags: DISPFlagDeleted)
!77 = !DISubroutineType(types: !78)
!78 = !{null, !79}
!79 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !60, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!80 = !DISubprogram(name: "__cuda_builtin_threadIdx_t", linkageName: "_ZN26__cuda_builtin_threadIdx_tC4ERKS_", scope: !60, file: !61, line: 62, type: !81, scopeLine: 62, flags: DIFlagPrivate | DIFlagPrototyped, spFlags: DISPFlagDeleted)
!81 = !DISubroutineType(types: !82)
!82 = !{null, !79, !83}
!83 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !72, size: 64)
!84 = !DISubprogram(name: "operator=", linkageName: "_ZNK26__cuda_builtin_threadIdx_taSERKS_", scope: !60, file: !61, line: 62, type: !85, scopeLine: 62, flags: DIFlagPrivate | DIFlagPrototyped, spFlags: DISPFlagDeleted)
!85 = !DISubroutineType(types: !86)
!86 = !{null, !71, !83}
!87 = !DISubprogram(name: "operator&", linkageName: "_ZNK26__cuda_builtin_threadIdx_tadEv", scope: !60, file: !61, line: 62, type: !88, scopeLine: 62, flags: DIFlagPrivate | DIFlagPrototyped, spFlags: DISPFlagDeleted)
!88 = !DISubroutineType(types: !89)
!89 = !{!90, !71}
!90 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !60, size: 64)
!91 = !{!92, !99, !104, !106, !108, !110, !112, !116, !118, !120, !122, !124, !126, !128, !130, !132, !134, !136, !138, !140, !142, !144, !148, !150, !152, !154, !158, !163, !165, !167, !172, !176, !178, !180, !182, !184, !186, !188, !190, !192, !197, !201, !203, !208, !212, !214, !216, !218, !220, !222, !226, !228, !230, !235, !243, !247, !249, !251, !253, !255, !259, !261, !263, !267, !269, !271, !273, !275, !277, !279, !281, !283, !285, !289, !295, !297, !299, !303, !305, !307, !309, !311, !313, !315, !317, !321, !325, !327, !329, !334, !336, !338, !340, !342, !344, !346, !349, !351, !353, !355, !360, !362, !364, !366, !368, !370, !372, !374, !376, !378, !380, !382, !386, !388, !390, !392, !394, !396, !398, !400, !402, !404, !406, !408, !410, !412, !414, !416, !420, !422, !426, !428, !430, !432, !434, !436, !438, !440, !442, !444, !448, !450, !454, !456, !458, !460, !464, !466, !470, !472, !474, !476, !478, !480, !482, !484, !486, !488, !490, !492, !494, !498, !500, !504, !506, !508, !510, !512, !514, !518, !520, !522, !524, !526, !528, !530, !534, !538, !540, !542, !544, !546, !550, !552, !556, !558, !560, !562, !564, !566, !568, !572, !574, !578, !580, !582, !586, !588, !590, !592, !594, !596, !598, !602, !606, !612, !616, !624, !629, !631, !633, !637, !641, !651, !653, !657, !661, !665, !670, !672, !676, !680, !684, !692, !696, !700, !702, !706, !710, !714, !720, !724, !728, !730, !738, !742, !749, !751, !753, !757, !761, !765, !769, !773, !777, !778, !779, !780, !782, !783, !784, !785, !786, !787, !788, !790, !791, !792, !793, !794, !795, !796, !797, !802, !803, !804, !805, !806, !807, !808, !809, !810, !811, !812, !813, !814, !815, !816, !817, !818, !819, !820, !821, !822, !823, !824, !825, !826, !830, !832, !834, !836, !838, !840, !842, !844, !846, !848, !850, !852, !854, !856, !858, !861, !863, !865, !867, !869, !871, !873, !875, !877, !879, !881, !883, !885, !887, !889, !891, !893, !895, !897, !899, !901, !903, !905, !907, !909, !911, !913, !915, !917, !919, !921, !923, !925, !927, !929, !931, !933, !935, !937, !939, !940, !941, !945, !947, !949}
!92 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !94, file: !95, line: 200)
!93 = !DINamespace(name: "std", scope: null)
!94 = !DISubprogram(name: "abs", linkageName: "_ZL3absi", scope: !95, file: !95, line: 30, type: !96, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!95 = !DIFile(filename: "/storage/users/sislam3/opt/llvm-22/lib/clang/22/include/__clang_cuda_math_forward_declares.h", directory: "")
!96 = !DISubroutineType(types: !97)
!97 = !{!98, !98}
!98 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!99 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !100, file: !95, line: 201)
!100 = !DISubprogram(name: "acos", linkageName: "_ZL4acosf", scope: !95, file: !95, line: 32, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!101 = !DISubroutineType(types: !102)
!102 = !{!103, !103}
!103 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!104 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !105, file: !95, line: 202)
!105 = !DISubprogram(name: "acosh", linkageName: "_ZL5acoshf", scope: !95, file: !95, line: 34, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!106 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !107, file: !95, line: 203)
!107 = !DISubprogram(name: "asin", linkageName: "_ZL4asinf", scope: !95, file: !95, line: 36, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!108 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !109, file: !95, line: 204)
!109 = !DISubprogram(name: "asinh", linkageName: "_ZL5asinhf", scope: !95, file: !95, line: 38, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!110 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !111, file: !95, line: 205)
!111 = !DISubprogram(name: "atan", linkageName: "_ZL4atanf", scope: !95, file: !95, line: 42, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!112 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !113, file: !95, line: 206)
!113 = !DISubprogram(name: "atan2", linkageName: "_ZL5atan2ff", scope: !95, file: !95, line: 40, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!114 = !DISubroutineType(types: !115)
!115 = !{!103, !103, !103}
!116 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !117, file: !95, line: 207)
!117 = !DISubprogram(name: "atanh", linkageName: "_ZL5atanhf", scope: !95, file: !95, line: 44, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!118 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !119, file: !95, line: 208)
!119 = !DISubprogram(name: "cbrt", linkageName: "_ZL4cbrtf", scope: !95, file: !95, line: 46, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!120 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !121, file: !95, line: 209)
!121 = !DISubprogram(name: "ceil", linkageName: "_ZL4ceilf", scope: !95, file: !95, line: 48, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!122 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !123, file: !95, line: 210)
!123 = !DISubprogram(name: "copysign", linkageName: "_ZL8copysignff", scope: !95, file: !95, line: 50, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!124 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !125, file: !95, line: 211)
!125 = !DISubprogram(name: "cos", linkageName: "_ZL3cosf", scope: !95, file: !95, line: 52, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!126 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !127, file: !95, line: 212)
!127 = !DISubprogram(name: "cosh", linkageName: "_ZL4coshf", scope: !95, file: !95, line: 54, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!128 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !129, file: !95, line: 213)
!129 = !DISubprogram(name: "erf", linkageName: "_ZL3erff", scope: !95, file: !95, line: 58, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!130 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !131, file: !95, line: 214)
!131 = !DISubprogram(name: "erfc", linkageName: "_ZL4erfcf", scope: !95, file: !95, line: 56, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!132 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !133, file: !95, line: 215)
!133 = !DISubprogram(name: "exp", linkageName: "_ZL3expf", scope: !95, file: !95, line: 62, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!134 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !135, file: !95, line: 216)
!135 = !DISubprogram(name: "exp2", linkageName: "_ZL4exp2f", scope: !95, file: !95, line: 60, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!136 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !137, file: !95, line: 217)
!137 = !DISubprogram(name: "expm1", linkageName: "_ZL5expm1f", scope: !95, file: !95, line: 64, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!138 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !139, file: !95, line: 218)
!139 = !DISubprogram(name: "fabs", linkageName: "_ZL4fabsf", scope: !95, file: !95, line: 66, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!140 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !141, file: !95, line: 219)
!141 = !DISubprogram(name: "fdim", linkageName: "_ZL4fdimff", scope: !95, file: !95, line: 68, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!142 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !143, file: !95, line: 220)
!143 = !DISubprogram(name: "floor", linkageName: "_ZL5floorf", scope: !95, file: !95, line: 70, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!144 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !145, file: !95, line: 221)
!145 = !DISubprogram(name: "fma", linkageName: "_ZL3fmafff", scope: !95, file: !95, line: 72, type: !146, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!146 = !DISubroutineType(types: !147)
!147 = !{!103, !103, !103, !103}
!148 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !149, file: !95, line: 222)
!149 = !DISubprogram(name: "fmax", linkageName: "_ZL4fmaxff", scope: !95, file: !95, line: 74, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!150 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !151, file: !95, line: 223)
!151 = !DISubprogram(name: "fmin", linkageName: "_ZL4fminff", scope: !95, file: !95, line: 76, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!152 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !153, file: !95, line: 224)
!153 = !DISubprogram(name: "fmod", linkageName: "_ZL4fmodff", scope: !95, file: !95, line: 78, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!154 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !155, file: !95, line: 225)
!155 = !DISubprogram(name: "fpclassify", linkageName: "_ZL10fpclassifyf", scope: !95, file: !95, line: 80, type: !156, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!156 = !DISubroutineType(types: !157)
!157 = !{!98, !103}
!158 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !159, file: !95, line: 226)
!159 = !DISubprogram(name: "frexp", linkageName: "_ZL5frexpfPi", scope: !95, file: !95, line: 82, type: !160, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!160 = !DISubroutineType(types: !161)
!161 = !{!103, !103, !162}
!162 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !98, size: 64)
!163 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !164, file: !95, line: 227)
!164 = !DISubprogram(name: "hypot", linkageName: "_ZL5hypotff", scope: !95, file: !95, line: 84, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!165 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !166, file: !95, line: 228)
!166 = !DISubprogram(name: "ilogb", linkageName: "_ZL5ilogbf", scope: !95, file: !95, line: 86, type: !156, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!167 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !168, file: !95, line: 229)
!168 = !DISubprogram(name: "isfinite", linkageName: "_ZL8isfinitef", scope: !95, file: !95, line: 91, type: !169, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!169 = !DISubroutineType(types: !170)
!170 = !{!171, !103}
!171 = !DIBasicType(name: "bool", size: 8, encoding: DW_ATE_boolean)
!172 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !173, file: !95, line: 230)
!173 = !DISubprogram(name: "isgreater", linkageName: "_ZL9isgreaterff", scope: !95, file: !95, line: 95, type: !174, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!174 = !DISubroutineType(types: !175)
!175 = !{!171, !103, !103}
!176 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !177, file: !95, line: 231)
!177 = !DISubprogram(name: "isgreaterequal", linkageName: "_ZL14isgreaterequalff", scope: !95, file: !95, line: 94, type: !174, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!178 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !179, file: !95, line: 232)
!179 = !DISubprogram(name: "isinf", linkageName: "_ZL5isinff", scope: !95, file: !95, line: 100, type: !169, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!180 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !181, file: !95, line: 233)
!181 = !DISubprogram(name: "isless", linkageName: "_ZL6islessff", scope: !95, file: !95, line: 104, type: !174, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!182 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !183, file: !95, line: 234)
!183 = !DISubprogram(name: "islessequal", linkageName: "_ZL11islessequalff", scope: !95, file: !95, line: 103, type: !174, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!184 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !185, file: !95, line: 235)
!185 = !DISubprogram(name: "islessgreater", linkageName: "_ZL13islessgreaterff", scope: !95, file: !95, line: 106, type: !174, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!186 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !187, file: !95, line: 236)
!187 = !DISubprogram(name: "isnan", linkageName: "_ZL5isnanf", scope: !95, file: !95, line: 111, type: !169, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!188 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !189, file: !95, line: 237)
!189 = !DISubprogram(name: "isnormal", linkageName: "_ZL8isnormalf", scope: !95, file: !95, line: 113, type: !169, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!190 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !191, file: !95, line: 238)
!191 = !DISubprogram(name: "isunordered", linkageName: "_ZL11isunorderedff", scope: !95, file: !95, line: 115, type: !174, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!192 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !193, file: !95, line: 239)
!193 = !DISubprogram(name: "labs", linkageName: "_ZL4labsl", scope: !95, file: !95, line: 116, type: !194, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!194 = !DISubroutineType(types: !195)
!195 = !{!196, !196}
!196 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!197 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !198, file: !95, line: 240)
!198 = !DISubprogram(name: "ldexp", linkageName: "_ZL5ldexpfi", scope: !95, file: !95, line: 118, type: !199, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!199 = !DISubroutineType(types: !200)
!200 = !{!103, !103, !98}
!201 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !202, file: !95, line: 241)
!202 = !DISubprogram(name: "lgamma", linkageName: "_ZL6lgammaf", scope: !95, file: !95, line: 120, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!203 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !204, file: !95, line: 242)
!204 = !DISubprogram(name: "llabs", linkageName: "_ZL5llabsx", scope: !95, file: !95, line: 121, type: !205, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!205 = !DISubroutineType(types: !206)
!206 = !{!207, !207}
!207 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!208 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !209, file: !95, line: 243)
!209 = !DISubprogram(name: "llrint", linkageName: "_ZL6llrintf", scope: !95, file: !95, line: 123, type: !210, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!210 = !DISubroutineType(types: !211)
!211 = !{!207, !103}
!212 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !213, file: !95, line: 244)
!213 = !DISubprogram(name: "log", linkageName: "_ZL3logf", scope: !95, file: !95, line: 133, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!214 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !215, file: !95, line: 245)
!215 = !DISubprogram(name: "log10", linkageName: "_ZL5log10f", scope: !95, file: !95, line: 125, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!216 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !217, file: !95, line: 246)
!217 = !DISubprogram(name: "log1p", linkageName: "_ZL5log1pf", scope: !95, file: !95, line: 127, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!218 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !219, file: !95, line: 247)
!219 = !DISubprogram(name: "log2", linkageName: "_ZL4log2f", scope: !95, file: !95, line: 129, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!220 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !221, file: !95, line: 248)
!221 = !DISubprogram(name: "logb", linkageName: "_ZL4logbf", scope: !95, file: !95, line: 131, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!222 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !223, file: !95, line: 249)
!223 = !DISubprogram(name: "lrint", linkageName: "_ZL5lrintf", scope: !95, file: !95, line: 135, type: !224, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!224 = !DISubroutineType(types: !225)
!225 = !{!196, !103}
!226 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !227, file: !95, line: 250)
!227 = !DISubprogram(name: "lround", linkageName: "_ZL6lroundf", scope: !95, file: !95, line: 137, type: !224, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!228 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !229, file: !95, line: 251)
!229 = !DISubprogram(name: "llround", linkageName: "_ZL7llroundf", scope: !95, file: !95, line: 138, type: !210, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!230 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !231, file: !95, line: 252)
!231 = !DISubprogram(name: "modf", linkageName: "_ZL4modffPf", scope: !95, file: !95, line: 140, type: !232, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!232 = !DISubroutineType(types: !233)
!233 = !{!103, !103, !234}
!234 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !103, size: 64)
!235 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !236, file: !95, line: 253)
!236 = !DISubprogram(name: "nan", linkageName: "_ZL3nanPKc", scope: !95, file: !95, line: 141, type: !237, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!237 = !DISubroutineType(types: !238)
!238 = !{!239, !240}
!239 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!240 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !241, size: 64)
!241 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !242)
!242 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!243 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !244, file: !95, line: 254)
!244 = !DISubprogram(name: "nanf", linkageName: "_ZL4nanfPKc", scope: !95, file: !95, line: 142, type: !245, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!245 = !DISubroutineType(types: !246)
!246 = !{!103, !240}
!247 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !248, file: !95, line: 255)
!248 = !DISubprogram(name: "nearbyint", linkageName: "_ZL9nearbyintf", scope: !95, file: !95, line: 144, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!249 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !250, file: !95, line: 256)
!250 = !DISubprogram(name: "nextafter", linkageName: "_ZL9nextafterff", scope: !95, file: !95, line: 146, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!251 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !252, file: !95, line: 257)
!252 = !DISubprogram(name: "pow", linkageName: "_ZL3powfi", scope: !95, file: !95, line: 150, type: !199, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!253 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !254, file: !95, line: 258)
!254 = !DISubprogram(name: "remainder", linkageName: "_ZL9remainderff", scope: !95, file: !95, line: 152, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!255 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !256, file: !95, line: 259)
!256 = !DISubprogram(name: "remquo", linkageName: "_ZL6remquoffPi", scope: !95, file: !95, line: 154, type: !257, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!257 = !DISubroutineType(types: !258)
!258 = !{!103, !103, !103, !162}
!259 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !260, file: !95, line: 260)
!260 = !DISubprogram(name: "rint", linkageName: "_ZL4rintf", scope: !95, file: !95, line: 156, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!261 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !262, file: !95, line: 261)
!262 = !DISubprogram(name: "round", linkageName: "_ZL5roundf", scope: !95, file: !95, line: 158, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!263 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !264, file: !95, line: 262)
!264 = !DISubprogram(name: "scalbln", linkageName: "_ZL7scalblnfl", scope: !95, file: !95, line: 160, type: !265, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!265 = !DISubroutineType(types: !266)
!266 = !{!103, !103, !196}
!267 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !268, file: !95, line: 263)
!268 = !DISubprogram(name: "scalbn", linkageName: "_ZL6scalbnfi", scope: !95, file: !95, line: 162, type: !199, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!269 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !270, file: !95, line: 264)
!270 = !DISubprogram(name: "signbit", linkageName: "_ZL7signbitf", scope: !95, file: !95, line: 167, type: !169, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!271 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !272, file: !95, line: 265)
!272 = !DISubprogram(name: "sin", linkageName: "_ZL3sinf", scope: !95, file: !95, line: 169, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!273 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !274, file: !95, line: 266)
!274 = !DISubprogram(name: "sinh", linkageName: "_ZL4sinhf", scope: !95, file: !95, line: 171, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!275 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !276, file: !95, line: 267)
!276 = !DISubprogram(name: "sqrt", linkageName: "_ZL4sqrtf", scope: !95, file: !95, line: 173, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!277 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !278, file: !95, line: 268)
!278 = !DISubprogram(name: "tan", linkageName: "_ZL3tanf", scope: !95, file: !95, line: 175, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!279 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !280, file: !95, line: 269)
!280 = !DISubprogram(name: "tanh", linkageName: "_ZL4tanhf", scope: !95, file: !95, line: 177, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!281 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !282, file: !95, line: 270)
!282 = !DISubprogram(name: "tgamma", linkageName: "_ZL6tgammaf", scope: !95, file: !95, line: 179, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!283 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !284, file: !95, line: 271)
!284 = !DISubprogram(name: "trunc", linkageName: "_ZL5truncf", scope: !95, file: !95, line: 181, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!285 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !286, file: !288, line: 52)
!286 = !DISubprogram(name: "abs", scope: !287, file: !287, line: 837, type: !96, flags: DIFlagPrototyped, spFlags: 0)
!287 = !DIFile(filename: "/usr/include/stdlib.h", directory: "")
!288 = !DIFile(filename: "/opt/rh/gcc-toolset-13/root/usr/lib/gcc/x86_64-redhat-linux/13/../../../../include/c++/13/bits/std_abs.h", directory: "")
!289 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !290, file: !294, line: 85)
!290 = !DISubprogram(name: "acos", scope: !291, file: !291, line: 53, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!291 = !DIFile(filename: "/usr/include/bits/mathcalls.h", directory: "")
!292 = !DISubroutineType(types: !293)
!293 = !{!239, !239}
!294 = !DIFile(filename: "/opt/rh/gcc-toolset-13/root/usr/lib/gcc/x86_64-redhat-linux/13/../../../../include/c++/13/cmath", directory: "")
!295 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !296, file: !294, line: 104)
!296 = !DISubprogram(name: "asin", scope: !291, file: !291, line: 55, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!297 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !298, file: !294, line: 123)
!298 = !DISubprogram(name: "atan", scope: !291, file: !291, line: 57, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!299 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !300, file: !294, line: 142)
!300 = !DISubprogram(name: "atan2", scope: !291, file: !291, line: 59, type: !301, flags: DIFlagPrototyped, spFlags: 0)
!301 = !DISubroutineType(types: !302)
!302 = !{!239, !239, !239}
!303 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !304, file: !294, line: 154)
!304 = !DISubprogram(name: "ceil", scope: !291, file: !291, line: 159, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!305 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !306, file: !294, line: 173)
!306 = !DISubprogram(name: "cos", scope: !291, file: !291, line: 62, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!307 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !308, file: !294, line: 192)
!308 = !DISubprogram(name: "cosh", scope: !291, file: !291, line: 71, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!309 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !310, file: !294, line: 211)
!310 = !DISubprogram(name: "exp", scope: !291, file: !291, line: 95, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!311 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !312, file: !294, line: 230)
!312 = !DISubprogram(name: "fabs", scope: !291, file: !291, line: 162, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!313 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !314, file: !294, line: 249)
!314 = !DISubprogram(name: "floor", scope: !291, file: !291, line: 165, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!315 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !316, file: !294, line: 268)
!316 = !DISubprogram(name: "fmod", scope: !291, file: !291, line: 168, type: !301, flags: DIFlagPrototyped, spFlags: 0)
!317 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !318, file: !294, line: 280)
!318 = !DISubprogram(name: "frexp", scope: !291, file: !291, line: 98, type: !319, flags: DIFlagPrototyped, spFlags: 0)
!319 = !DISubroutineType(types: !320)
!320 = !{!239, !239, !162}
!321 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !322, file: !294, line: 299)
!322 = !DISubprogram(name: "ldexp", scope: !291, file: !291, line: 101, type: !323, flags: DIFlagPrototyped, spFlags: 0)
!323 = !DISubroutineType(types: !324)
!324 = !{!239, !239, !98}
!325 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !326, file: !294, line: 318)
!326 = !DISubprogram(name: "log", scope: !291, file: !291, line: 104, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!327 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !328, file: !294, line: 337)
!328 = !DISubprogram(name: "log10", scope: !291, file: !291, line: 107, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!329 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !330, file: !294, line: 356)
!330 = !DISubprogram(name: "modf", scope: !291, file: !291, line: 110, type: !331, flags: DIFlagPrototyped, spFlags: 0)
!331 = !DISubroutineType(types: !332)
!332 = !{!239, !239, !333}
!333 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !239, size: 64)
!334 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !335, file: !294, line: 368)
!335 = !DISubprogram(name: "pow", scope: !291, file: !291, line: 140, type: !301, flags: DIFlagPrototyped, spFlags: 0)
!336 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !337, file: !294, line: 396)
!337 = !DISubprogram(name: "sin", scope: !291, file: !291, line: 64, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!338 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !339, file: !294, line: 415)
!339 = !DISubprogram(name: "sinh", scope: !291, file: !291, line: 73, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!340 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !341, file: !294, line: 434)
!341 = !DISubprogram(name: "sqrt", scope: !291, file: !291, line: 143, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!342 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !343, file: !294, line: 453)
!343 = !DISubprogram(name: "tan", scope: !291, file: !291, line: 66, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!344 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !345, file: !294, line: 472)
!345 = !DISubprogram(name: "tanh", scope: !291, file: !291, line: 75, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!346 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !347, file: !294, line: 1881)
!347 = !DIDerivedType(tag: DW_TAG_typedef, name: "double_t", file: !348, line: 150, baseType: !239)
!348 = !DIFile(filename: "/usr/include/math.h", directory: "")
!349 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !350, file: !294, line: 1882)
!350 = !DIDerivedType(tag: DW_TAG_typedef, name: "float_t", file: !348, line: 149, baseType: !103)
!351 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !352, file: !294, line: 1885)
!352 = !DISubprogram(name: "acosh", scope: !291, file: !291, line: 85, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!353 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !354, file: !294, line: 1886)
!354 = !DISubprogram(name: "acoshf", scope: !291, file: !291, line: 85, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!355 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !356, file: !294, line: 1887)
!356 = !DISubprogram(name: "acoshl", scope: !291, file: !291, line: 85, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!357 = !DISubroutineType(types: !358)
!358 = !{!359, !359}
!359 = !DIBasicType(name: "long double", size: 64, encoding: DW_ATE_float)
!360 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !361, file: !294, line: 1889)
!361 = !DISubprogram(name: "asinh", scope: !291, file: !291, line: 87, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!362 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !363, file: !294, line: 1890)
!363 = !DISubprogram(name: "asinhf", scope: !291, file: !291, line: 87, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!364 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !365, file: !294, line: 1891)
!365 = !DISubprogram(name: "asinhl", scope: !291, file: !291, line: 87, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!366 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !367, file: !294, line: 1893)
!367 = !DISubprogram(name: "atanh", scope: !291, file: !291, line: 89, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!368 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !369, file: !294, line: 1894)
!369 = !DISubprogram(name: "atanhf", scope: !291, file: !291, line: 89, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!370 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !371, file: !294, line: 1895)
!371 = !DISubprogram(name: "atanhl", scope: !291, file: !291, line: 89, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!372 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !373, file: !294, line: 1897)
!373 = !DISubprogram(name: "cbrt", scope: !291, file: !291, line: 152, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!374 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !375, file: !294, line: 1898)
!375 = !DISubprogram(name: "cbrtf", scope: !291, file: !291, line: 152, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!376 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !377, file: !294, line: 1899)
!377 = !DISubprogram(name: "cbrtl", scope: !291, file: !291, line: 152, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!378 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !379, file: !294, line: 1901)
!379 = !DISubprogram(name: "copysign", scope: !291, file: !291, line: 196, type: !301, flags: DIFlagPrototyped, spFlags: 0)
!380 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !381, file: !294, line: 1902)
!381 = !DISubprogram(name: "copysignf", scope: !291, file: !291, line: 196, type: !114, flags: DIFlagPrototyped, spFlags: 0)
!382 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !383, file: !294, line: 1903)
!383 = !DISubprogram(name: "copysignl", scope: !291, file: !291, line: 196, type: !384, flags: DIFlagPrototyped, spFlags: 0)
!384 = !DISubroutineType(types: !385)
!385 = !{!359, !359, !359}
!386 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !387, file: !294, line: 1905)
!387 = !DISubprogram(name: "erf", scope: !291, file: !291, line: 228, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!388 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !389, file: !294, line: 1906)
!389 = !DISubprogram(name: "erff", scope: !291, file: !291, line: 228, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!390 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !391, file: !294, line: 1907)
!391 = !DISubprogram(name: "erfl", scope: !291, file: !291, line: 228, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!392 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !393, file: !294, line: 1909)
!393 = !DISubprogram(name: "erfc", scope: !291, file: !291, line: 229, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!394 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !395, file: !294, line: 1910)
!395 = !DISubprogram(name: "erfcf", scope: !291, file: !291, line: 229, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!396 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !397, file: !294, line: 1911)
!397 = !DISubprogram(name: "erfcl", scope: !291, file: !291, line: 229, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!398 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !399, file: !294, line: 1913)
!399 = !DISubprogram(name: "exp2", scope: !291, file: !291, line: 130, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!400 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !401, file: !294, line: 1914)
!401 = !DISubprogram(name: "exp2f", scope: !291, file: !291, line: 130, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!402 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !403, file: !294, line: 1915)
!403 = !DISubprogram(name: "exp2l", scope: !291, file: !291, line: 130, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!404 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !405, file: !294, line: 1917)
!405 = !DISubprogram(name: "expm1", scope: !291, file: !291, line: 119, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!406 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !407, file: !294, line: 1918)
!407 = !DISubprogram(name: "expm1f", scope: !291, file: !291, line: 119, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!408 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !409, file: !294, line: 1919)
!409 = !DISubprogram(name: "expm1l", scope: !291, file: !291, line: 119, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!410 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !411, file: !294, line: 1921)
!411 = !DISubprogram(name: "fdim", scope: !291, file: !291, line: 326, type: !301, flags: DIFlagPrototyped, spFlags: 0)
!412 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !413, file: !294, line: 1922)
!413 = !DISubprogram(name: "fdimf", scope: !291, file: !291, line: 326, type: !114, flags: DIFlagPrototyped, spFlags: 0)
!414 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !415, file: !294, line: 1923)
!415 = !DISubprogram(name: "fdiml", scope: !291, file: !291, line: 326, type: !384, flags: DIFlagPrototyped, spFlags: 0)
!416 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !417, file: !294, line: 1925)
!417 = !DISubprogram(name: "fma", scope: !291, file: !291, line: 335, type: !418, flags: DIFlagPrototyped, spFlags: 0)
!418 = !DISubroutineType(types: !419)
!419 = !{!239, !239, !239, !239}
!420 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !421, file: !294, line: 1926)
!421 = !DISubprogram(name: "fmaf", scope: !291, file: !291, line: 335, type: !146, flags: DIFlagPrototyped, spFlags: 0)
!422 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !423, file: !294, line: 1927)
!423 = !DISubprogram(name: "fmal", scope: !291, file: !291, line: 335, type: !424, flags: DIFlagPrototyped, spFlags: 0)
!424 = !DISubroutineType(types: !425)
!425 = !{!359, !359, !359, !359}
!426 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !427, file: !294, line: 1929)
!427 = !DISubprogram(name: "fmax", scope: !291, file: !291, line: 329, type: !301, flags: DIFlagPrototyped, spFlags: 0)
!428 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !429, file: !294, line: 1930)
!429 = !DISubprogram(name: "fmaxf", scope: !291, file: !291, line: 329, type: !114, flags: DIFlagPrototyped, spFlags: 0)
!430 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !431, file: !294, line: 1931)
!431 = !DISubprogram(name: "fmaxl", scope: !291, file: !291, line: 329, type: !384, flags: DIFlagPrototyped, spFlags: 0)
!432 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !433, file: !294, line: 1933)
!433 = !DISubprogram(name: "fmin", scope: !291, file: !291, line: 332, type: !301, flags: DIFlagPrototyped, spFlags: 0)
!434 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !435, file: !294, line: 1934)
!435 = !DISubprogram(name: "fminf", scope: !291, file: !291, line: 332, type: !114, flags: DIFlagPrototyped, spFlags: 0)
!436 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !437, file: !294, line: 1935)
!437 = !DISubprogram(name: "fminl", scope: !291, file: !291, line: 332, type: !384, flags: DIFlagPrototyped, spFlags: 0)
!438 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !439, file: !294, line: 1937)
!439 = !DISubprogram(name: "hypot", scope: !291, file: !291, line: 147, type: !301, flags: DIFlagPrototyped, spFlags: 0)
!440 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !441, file: !294, line: 1938)
!441 = !DISubprogram(name: "hypotf", scope: !291, file: !291, line: 147, type: !114, flags: DIFlagPrototyped, spFlags: 0)
!442 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !443, file: !294, line: 1939)
!443 = !DISubprogram(name: "hypotl", scope: !291, file: !291, line: 147, type: !384, flags: DIFlagPrototyped, spFlags: 0)
!444 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !445, file: !294, line: 1941)
!445 = !DISubprogram(name: "ilogb", scope: !291, file: !291, line: 280, type: !446, flags: DIFlagPrototyped, spFlags: 0)
!446 = !DISubroutineType(types: !447)
!447 = !{!98, !239}
!448 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !449, file: !294, line: 1942)
!449 = !DISubprogram(name: "ilogbf", scope: !291, file: !291, line: 280, type: !156, flags: DIFlagPrototyped, spFlags: 0)
!450 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !451, file: !294, line: 1943)
!451 = !DISubprogram(name: "ilogbl", scope: !291, file: !291, line: 280, type: !452, flags: DIFlagPrototyped, spFlags: 0)
!452 = !DISubroutineType(types: !453)
!453 = !{!98, !359}
!454 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !455, file: !294, line: 1945)
!455 = !DISubprogram(name: "lgamma", scope: !291, file: !291, line: 230, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!456 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !457, file: !294, line: 1946)
!457 = !DISubprogram(name: "lgammaf", scope: !291, file: !291, line: 230, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!458 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !459, file: !294, line: 1947)
!459 = !DISubprogram(name: "lgammal", scope: !291, file: !291, line: 230, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!460 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !461, file: !294, line: 1950)
!461 = !DISubprogram(name: "llrint", scope: !291, file: !291, line: 316, type: !462, flags: DIFlagPrototyped, spFlags: 0)
!462 = !DISubroutineType(types: !463)
!463 = !{!207, !239}
!464 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !465, file: !294, line: 1951)
!465 = !DISubprogram(name: "llrintf", scope: !291, file: !291, line: 316, type: !210, flags: DIFlagPrototyped, spFlags: 0)
!466 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !467, file: !294, line: 1952)
!467 = !DISubprogram(name: "llrintl", scope: !291, file: !291, line: 316, type: !468, flags: DIFlagPrototyped, spFlags: 0)
!468 = !DISubroutineType(types: !469)
!469 = !{!207, !359}
!470 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !471, file: !294, line: 1954)
!471 = !DISubprogram(name: "llround", scope: !291, file: !291, line: 322, type: !462, flags: DIFlagPrototyped, spFlags: 0)
!472 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !473, file: !294, line: 1955)
!473 = !DISubprogram(name: "llroundf", scope: !291, file: !291, line: 322, type: !210, flags: DIFlagPrototyped, spFlags: 0)
!474 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !475, file: !294, line: 1956)
!475 = !DISubprogram(name: "llroundl", scope: !291, file: !291, line: 322, type: !468, flags: DIFlagPrototyped, spFlags: 0)
!476 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !477, file: !294, line: 1959)
!477 = !DISubprogram(name: "log1p", scope: !291, file: !291, line: 122, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!478 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !479, file: !294, line: 1960)
!479 = !DISubprogram(name: "log1pf", scope: !291, file: !291, line: 122, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!480 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !481, file: !294, line: 1961)
!481 = !DISubprogram(name: "log1pl", scope: !291, file: !291, line: 122, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!482 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !483, file: !294, line: 1963)
!483 = !DISubprogram(name: "log2", scope: !291, file: !291, line: 133, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!484 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !485, file: !294, line: 1964)
!485 = !DISubprogram(name: "log2f", scope: !291, file: !291, line: 133, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!486 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !487, file: !294, line: 1965)
!487 = !DISubprogram(name: "log2l", scope: !291, file: !291, line: 133, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!488 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !489, file: !294, line: 1967)
!489 = !DISubprogram(name: "logb", scope: !291, file: !291, line: 125, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!490 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !491, file: !294, line: 1968)
!491 = !DISubprogram(name: "logbf", scope: !291, file: !291, line: 125, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!492 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !493, file: !294, line: 1969)
!493 = !DISubprogram(name: "logbl", scope: !291, file: !291, line: 125, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!494 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !495, file: !294, line: 1971)
!495 = !DISubprogram(name: "lrint", scope: !291, file: !291, line: 314, type: !496, flags: DIFlagPrototyped, spFlags: 0)
!496 = !DISubroutineType(types: !497)
!497 = !{!196, !239}
!498 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !499, file: !294, line: 1972)
!499 = !DISubprogram(name: "lrintf", scope: !291, file: !291, line: 314, type: !224, flags: DIFlagPrototyped, spFlags: 0)
!500 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !501, file: !294, line: 1973)
!501 = !DISubprogram(name: "lrintl", scope: !291, file: !291, line: 314, type: !502, flags: DIFlagPrototyped, spFlags: 0)
!502 = !DISubroutineType(types: !503)
!503 = !{!196, !359}
!504 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !505, file: !294, line: 1975)
!505 = !DISubprogram(name: "lround", scope: !291, file: !291, line: 320, type: !496, flags: DIFlagPrototyped, spFlags: 0)
!506 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !507, file: !294, line: 1976)
!507 = !DISubprogram(name: "lroundf", scope: !291, file: !291, line: 320, type: !224, flags: DIFlagPrototyped, spFlags: 0)
!508 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !509, file: !294, line: 1977)
!509 = !DISubprogram(name: "lroundl", scope: !291, file: !291, line: 320, type: !502, flags: DIFlagPrototyped, spFlags: 0)
!510 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !511, file: !294, line: 1979)
!511 = !DISubprogram(name: "nan", scope: !291, file: !291, line: 201, type: !237, flags: DIFlagPrototyped, spFlags: 0)
!512 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !513, file: !294, line: 1980)
!513 = !DISubprogram(name: "nanf", scope: !291, file: !291, line: 201, type: !245, flags: DIFlagPrototyped, spFlags: 0)
!514 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !515, file: !294, line: 1981)
!515 = !DISubprogram(name: "nanl", scope: !291, file: !291, line: 201, type: !516, flags: DIFlagPrototyped, spFlags: 0)
!516 = !DISubroutineType(types: !517)
!517 = !{!359, !240}
!518 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !519, file: !294, line: 1983)
!519 = !DISubprogram(name: "nearbyint", scope: !291, file: !291, line: 294, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!520 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !521, file: !294, line: 1984)
!521 = !DISubprogram(name: "nearbyintf", scope: !291, file: !291, line: 294, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!522 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !523, file: !294, line: 1985)
!523 = !DISubprogram(name: "nearbyintl", scope: !291, file: !291, line: 294, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!524 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !525, file: !294, line: 1987)
!525 = !DISubprogram(name: "nextafter", scope: !291, file: !291, line: 259, type: !301, flags: DIFlagPrototyped, spFlags: 0)
!526 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !527, file: !294, line: 1988)
!527 = !DISubprogram(name: "nextafterf", scope: !291, file: !291, line: 259, type: !114, flags: DIFlagPrototyped, spFlags: 0)
!528 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !529, file: !294, line: 1989)
!529 = !DISubprogram(name: "nextafterl", scope: !291, file: !291, line: 259, type: !384, flags: DIFlagPrototyped, spFlags: 0)
!530 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !531, file: !294, line: 1991)
!531 = !DISubprogram(name: "nexttoward", scope: !291, file: !291, line: 261, type: !532, flags: DIFlagPrototyped, spFlags: 0)
!532 = !DISubroutineType(types: !533)
!533 = !{!239, !239, !359}
!534 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !535, file: !294, line: 1992)
!535 = !DISubprogram(name: "nexttowardf", scope: !291, file: !291, line: 261, type: !536, flags: DIFlagPrototyped, spFlags: 0)
!536 = !DISubroutineType(types: !537)
!537 = !{!103, !103, !359}
!538 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !539, file: !294, line: 1993)
!539 = !DISubprogram(name: "nexttowardl", scope: !291, file: !291, line: 261, type: !384, flags: DIFlagPrototyped, spFlags: 0)
!540 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !541, file: !294, line: 1995)
!541 = !DISubprogram(name: "remainder", scope: !291, file: !291, line: 272, type: !301, flags: DIFlagPrototyped, spFlags: 0)
!542 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !543, file: !294, line: 1996)
!543 = !DISubprogram(name: "remainderf", scope: !291, file: !291, line: 272, type: !114, flags: DIFlagPrototyped, spFlags: 0)
!544 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !545, file: !294, line: 1997)
!545 = !DISubprogram(name: "remainderl", scope: !291, file: !291, line: 272, type: !384, flags: DIFlagPrototyped, spFlags: 0)
!546 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !547, file: !294, line: 1999)
!547 = !DISubprogram(name: "remquo", scope: !291, file: !291, line: 307, type: !548, flags: DIFlagPrototyped, spFlags: 0)
!548 = !DISubroutineType(types: !549)
!549 = !{!239, !239, !239, !162}
!550 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !551, file: !294, line: 2000)
!551 = !DISubprogram(name: "remquof", scope: !291, file: !291, line: 307, type: !257, flags: DIFlagPrototyped, spFlags: 0)
!552 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !553, file: !294, line: 2001)
!553 = !DISubprogram(name: "remquol", scope: !291, file: !291, line: 307, type: !554, flags: DIFlagPrototyped, spFlags: 0)
!554 = !DISubroutineType(types: !555)
!555 = !{!359, !359, !359, !162}
!556 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !557, file: !294, line: 2003)
!557 = !DISubprogram(name: "rint", scope: !291, file: !291, line: 256, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!558 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !559, file: !294, line: 2004)
!559 = !DISubprogram(name: "rintf", scope: !291, file: !291, line: 256, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!560 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !561, file: !294, line: 2005)
!561 = !DISubprogram(name: "rintl", scope: !291, file: !291, line: 256, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!562 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !563, file: !294, line: 2007)
!563 = !DISubprogram(name: "round", scope: !291, file: !291, line: 298, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!564 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !565, file: !294, line: 2008)
!565 = !DISubprogram(name: "roundf", scope: !291, file: !291, line: 298, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!566 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !567, file: !294, line: 2009)
!567 = !DISubprogram(name: "roundl", scope: !291, file: !291, line: 298, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!568 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !569, file: !294, line: 2011)
!569 = !DISubprogram(name: "scalbln", scope: !291, file: !291, line: 290, type: !570, flags: DIFlagPrototyped, spFlags: 0)
!570 = !DISubroutineType(types: !571)
!571 = !{!239, !239, !196}
!572 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !573, file: !294, line: 2012)
!573 = !DISubprogram(name: "scalblnf", scope: !291, file: !291, line: 290, type: !265, flags: DIFlagPrototyped, spFlags: 0)
!574 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !575, file: !294, line: 2013)
!575 = !DISubprogram(name: "scalblnl", scope: !291, file: !291, line: 290, type: !576, flags: DIFlagPrototyped, spFlags: 0)
!576 = !DISubroutineType(types: !577)
!577 = !{!359, !359, !196}
!578 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !579, file: !294, line: 2015)
!579 = !DISubprogram(name: "scalbn", scope: !291, file: !291, line: 276, type: !323, flags: DIFlagPrototyped, spFlags: 0)
!580 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !581, file: !294, line: 2016)
!581 = !DISubprogram(name: "scalbnf", scope: !291, file: !291, line: 276, type: !199, flags: DIFlagPrototyped, spFlags: 0)
!582 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !583, file: !294, line: 2017)
!583 = !DISubprogram(name: "scalbnl", scope: !291, file: !291, line: 276, type: !584, flags: DIFlagPrototyped, spFlags: 0)
!584 = !DISubroutineType(types: !585)
!585 = !{!359, !359, !98}
!586 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !587, file: !294, line: 2019)
!587 = !DISubprogram(name: "tgamma", scope: !291, file: !291, line: 235, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!588 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !589, file: !294, line: 2020)
!589 = !DISubprogram(name: "tgammaf", scope: !291, file: !291, line: 235, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!590 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !591, file: !294, line: 2021)
!591 = !DISubprogram(name: "tgammal", scope: !291, file: !291, line: 235, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!592 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !593, file: !294, line: 2023)
!593 = !DISubprogram(name: "trunc", scope: !291, file: !291, line: 302, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!594 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !595, file: !294, line: 2024)
!595 = !DISubprogram(name: "truncf", scope: !291, file: !291, line: 302, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!596 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !597, file: !294, line: 2025)
!597 = !DISubprogram(name: "truncl", scope: !291, file: !291, line: 302, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!598 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !599, entity: !600, file: !601, line: 58)
!599 = !DINamespace(name: "__gnu_debug", scope: null)
!600 = !DINamespace(name: "__debug", scope: !93)
!601 = !DIFile(filename: "/opt/rh/gcc-toolset-13/root/usr/lib/gcc/x86_64-redhat-linux/13/../../../../include/c++/13/debug/debug.h", directory: "")
!602 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !603, file: !605, line: 131)
!603 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !287, line: 62, baseType: !604)
!604 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !287, line: 58, size: 64, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!605 = !DIFile(filename: "/opt/rh/gcc-toolset-13/root/usr/lib/gcc/x86_64-redhat-linux/13/../../../../include/c++/13/cstdlib", directory: "")
!606 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !607, file: !605, line: 132)
!607 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !287, line: 70, baseType: !608)
!608 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !287, line: 66, size: 128, flags: DIFlagTypePassByValue, elements: !609, identifier: "_ZTS6ldiv_t")
!609 = !{!610, !611}
!610 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !608, file: !287, line: 68, baseType: !196, size: 64)
!611 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !608, file: !287, line: 69, baseType: !196, size: 64, offset: 64)
!612 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !613, file: !605, line: 134)
!613 = !DISubprogram(name: "abort", scope: !287, file: !287, line: 588, type: !614, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!614 = !DISubroutineType(types: !615)
!615 = !{null}
!616 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !617, file: !605, line: 136)
!617 = !DISubprogram(name: "aligned_alloc", scope: !287, file: !287, line: 583, type: !618, flags: DIFlagPrototyped, spFlags: 0)
!618 = !DISubroutineType(types: !619)
!619 = !{!620, !621, !621}
!620 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!621 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !622, line: 18, baseType: !623)
!622 = !DIFile(filename: "/storage/users/sislam3/opt/llvm-22/lib/clang/22/include/__stddef_size_t.h", directory: "")
!623 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!624 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !625, file: !605, line: 138)
!625 = !DISubprogram(name: "atexit", scope: !287, file: !287, line: 592, type: !626, flags: DIFlagPrototyped, spFlags: 0)
!626 = !DISubroutineType(types: !627)
!627 = !{!98, !628}
!628 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !614, size: 64)
!629 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !630, file: !605, line: 141)
!630 = !DISubprogram(name: "at_quick_exit", scope: !287, file: !287, line: 597, type: !626, flags: DIFlagPrototyped, spFlags: 0)
!631 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !632, file: !605, line: 144)
!632 = !DISubprogram(name: "atof", scope: !287, file: !287, line: 101, type: !237, flags: DIFlagPrototyped, spFlags: 0)
!633 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !634, file: !605, line: 145)
!634 = !DISubprogram(name: "atoi", scope: !287, file: !287, line: 104, type: !635, flags: DIFlagPrototyped, spFlags: 0)
!635 = !DISubroutineType(types: !636)
!636 = !{!98, !240}
!637 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !638, file: !605, line: 146)
!638 = !DISubprogram(name: "atol", scope: !287, file: !287, line: 107, type: !639, flags: DIFlagPrototyped, spFlags: 0)
!639 = !DISubroutineType(types: !640)
!640 = !{!196, !240}
!641 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !642, file: !605, line: 147)
!642 = !DISubprogram(name: "bsearch", scope: !287, file: !287, line: 817, type: !643, flags: DIFlagPrototyped, spFlags: 0)
!643 = !DISubroutineType(types: !644)
!644 = !{!620, !645, !645, !621, !621, !647}
!645 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !646, size: 64)
!646 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!647 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !287, line: 805, baseType: !648)
!648 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !649, size: 64)
!649 = !DISubroutineType(types: !650)
!650 = !{!98, !645, !645}
!651 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !652, file: !605, line: 148)
!652 = !DISubprogram(name: "calloc", scope: !287, file: !287, line: 541, type: !618, flags: DIFlagPrototyped, spFlags: 0)
!653 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !654, file: !605, line: 149)
!654 = !DISubprogram(name: "div", scope: !287, file: !287, line: 849, type: !655, flags: DIFlagPrototyped, spFlags: 0)
!655 = !DISubroutineType(types: !656)
!656 = !{!603, !98, !98}
!657 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !658, file: !605, line: 150)
!658 = !DISubprogram(name: "exit", scope: !287, file: !287, line: 614, type: !659, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!659 = !DISubroutineType(types: !660)
!660 = !{null, !98}
!661 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !662, file: !605, line: 151)
!662 = !DISubprogram(name: "free", scope: !287, file: !287, line: 563, type: !663, flags: DIFlagPrototyped, spFlags: 0)
!663 = !DISubroutineType(types: !664)
!664 = !{null, !620}
!665 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !666, file: !605, line: 152)
!666 = !DISubprogram(name: "getenv", scope: !287, file: !287, line: 631, type: !667, flags: DIFlagPrototyped, spFlags: 0)
!667 = !DISubroutineType(types: !668)
!668 = !{!669, !240}
!669 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !242, size: 64)
!670 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !671, file: !605, line: 153)
!671 = !DISubprogram(name: "labs", scope: !287, file: !287, line: 838, type: !194, flags: DIFlagPrototyped, spFlags: 0)
!672 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !673, file: !605, line: 154)
!673 = !DISubprogram(name: "ldiv", scope: !287, file: !287, line: 851, type: !674, flags: DIFlagPrototyped, spFlags: 0)
!674 = !DISubroutineType(types: !675)
!675 = !{!607, !196, !196}
!676 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !677, file: !605, line: 155)
!677 = !DISubprogram(name: "malloc", scope: !287, file: !287, line: 539, type: !678, flags: DIFlagPrototyped, spFlags: 0)
!678 = !DISubroutineType(types: !679)
!679 = !{!620, !621}
!680 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !681, file: !605, line: 157)
!681 = !DISubprogram(name: "mblen", scope: !287, file: !287, line: 919, type: !682, flags: DIFlagPrototyped, spFlags: 0)
!682 = !DISubroutineType(types: !683)
!683 = !{!98, !240, !621}
!684 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !685, file: !605, line: 158)
!685 = !DISubprogram(name: "mbstowcs", scope: !287, file: !287, line: 930, type: !686, flags: DIFlagPrototyped, spFlags: 0)
!686 = !DISubroutineType(types: !687)
!687 = !{!621, !688, !691, !621}
!688 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !689)
!689 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !690, size: 64)
!690 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!691 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !240)
!692 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !693, file: !605, line: 159)
!693 = !DISubprogram(name: "mbtowc", scope: !287, file: !287, line: 922, type: !694, flags: DIFlagPrototyped, spFlags: 0)
!694 = !DISubroutineType(types: !695)
!695 = !{!98, !688, !691, !621}
!696 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !697, file: !605, line: 161)
!697 = !DISubprogram(name: "qsort", scope: !287, file: !287, line: 827, type: !698, flags: DIFlagPrototyped, spFlags: 0)
!698 = !DISubroutineType(types: !699)
!699 = !{null, !620, !621, !621, !647}
!700 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !701, file: !605, line: 164)
!701 = !DISubprogram(name: "quick_exit", scope: !287, file: !287, line: 620, type: !659, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!702 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !703, file: !605, line: 167)
!703 = !DISubprogram(name: "rand", scope: !287, file: !287, line: 453, type: !704, flags: DIFlagPrototyped, spFlags: 0)
!704 = !DISubroutineType(types: !705)
!705 = !{!98}
!706 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !707, file: !605, line: 168)
!707 = !DISubprogram(name: "realloc", scope: !287, file: !287, line: 549, type: !708, flags: DIFlagPrototyped, spFlags: 0)
!708 = !DISubroutineType(types: !709)
!709 = !{!620, !620, !621}
!710 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !711, file: !605, line: 169)
!711 = !DISubprogram(name: "srand", scope: !287, file: !287, line: 455, type: !712, flags: DIFlagPrototyped, spFlags: 0)
!712 = !DISubroutineType(types: !713)
!713 = !{null, !39}
!714 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !715, file: !605, line: 170)
!715 = !DISubprogram(name: "strtod", scope: !287, file: !287, line: 117, type: !716, flags: DIFlagPrototyped, spFlags: 0)
!716 = !DISubroutineType(types: !717)
!717 = !{!239, !691, !718}
!718 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !719)
!719 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !669, size: 64)
!720 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !721, file: !605, line: 171)
!721 = !DISubprogram(name: "strtol", scope: !287, file: !287, line: 176, type: !722, flags: DIFlagPrototyped, spFlags: 0)
!722 = !DISubroutineType(types: !723)
!723 = !{!196, !691, !718, !98}
!724 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !725, file: !605, line: 172)
!725 = !DISubprogram(name: "strtoul", scope: !287, file: !287, line: 180, type: !726, flags: DIFlagPrototyped, spFlags: 0)
!726 = !DISubroutineType(types: !727)
!727 = !{!623, !691, !718, !98}
!728 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !729, file: !605, line: 173)
!729 = !DISubprogram(name: "system", scope: !287, file: !287, line: 781, type: !635, flags: DIFlagPrototyped, spFlags: 0)
!730 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !731, file: !605, line: 175)
!731 = !DISubprogram(name: "wcstombs", scope: !287, file: !287, line: 933, type: !732, flags: DIFlagPrototyped, spFlags: 0)
!732 = !DISubroutineType(types: !733)
!733 = !{!621, !734, !735, !621}
!734 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !669)
!735 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !736)
!736 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !737, size: 64)
!737 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !690)
!738 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !739, file: !605, line: 176)
!739 = !DISubprogram(name: "wctomb", scope: !287, file: !287, line: 926, type: !740, flags: DIFlagPrototyped, spFlags: 0)
!740 = !DISubroutineType(types: !741)
!741 = !{!98, !669, !690}
!742 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !743, entity: !744, file: !605, line: 204)
!743 = !DINamespace(name: "__gnu_cxx", scope: null)
!744 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !287, line: 80, baseType: !745)
!745 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !287, line: 76, size: 128, flags: DIFlagTypePassByValue, elements: !746, identifier: "_ZTS7lldiv_t")
!746 = !{!747, !748}
!747 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !745, file: !287, line: 78, baseType: !207, size: 64)
!748 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !745, file: !287, line: 79, baseType: !207, size: 64, offset: 64)
!749 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !743, entity: !750, file: !605, line: 210)
!750 = !DISubprogram(name: "_Exit", scope: !287, file: !287, line: 626, type: !659, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!751 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !743, entity: !752, file: !605, line: 214)
!752 = !DISubprogram(name: "llabs", scope: !287, file: !287, line: 841, type: !205, flags: DIFlagPrototyped, spFlags: 0)
!753 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !743, entity: !754, file: !605, line: 220)
!754 = !DISubprogram(name: "lldiv", scope: !287, file: !287, line: 855, type: !755, flags: DIFlagPrototyped, spFlags: 0)
!755 = !DISubroutineType(types: !756)
!756 = !{!744, !207, !207}
!757 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !743, entity: !758, file: !605, line: 231)
!758 = !DISubprogram(name: "atoll", scope: !287, file: !287, line: 112, type: !759, flags: DIFlagPrototyped, spFlags: 0)
!759 = !DISubroutineType(types: !760)
!760 = !{!207, !240}
!761 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !743, entity: !762, file: !605, line: 232)
!762 = !DISubprogram(name: "strtoll", scope: !287, file: !287, line: 200, type: !763, flags: DIFlagPrototyped, spFlags: 0)
!763 = !DISubroutineType(types: !764)
!764 = !{!207, !691, !718, !98}
!765 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !743, entity: !766, file: !605, line: 233)
!766 = !DISubprogram(name: "strtoull", scope: !287, file: !287, line: 205, type: !767, flags: DIFlagPrototyped, spFlags: 0)
!767 = !DISubroutineType(types: !768)
!768 = !{!9, !691, !718, !98}
!769 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !743, entity: !770, file: !605, line: 235)
!770 = !DISubprogram(name: "strtof", scope: !287, file: !287, line: 123, type: !771, flags: DIFlagPrototyped, spFlags: 0)
!771 = !DISubroutineType(types: !772)
!772 = !{!103, !691, !718}
!773 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !743, entity: !774, file: !605, line: 236)
!774 = !DISubprogram(name: "strtold", scope: !287, file: !287, line: 126, type: !775, flags: DIFlagPrototyped, spFlags: 0)
!775 = !DISubroutineType(types: !776)
!776 = !{!359, !691, !718}
!777 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !744, file: !605, line: 244)
!778 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !750, file: !605, line: 246)
!779 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !752, file: !605, line: 248)
!780 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !781, file: !605, line: 249)
!781 = !DISubprogram(name: "div", linkageName: "_ZN9__gnu_cxx3divExx", scope: !743, file: !605, line: 217, type: !755, flags: DIFlagPrototyped, spFlags: 0)
!782 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !754, file: !605, line: 250)
!783 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !758, file: !605, line: 252)
!784 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !770, file: !605, line: 253)
!785 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !762, file: !605, line: 254)
!786 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !766, file: !605, line: 255)
!787 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !774, file: !605, line: 256)
!788 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !613, file: !789, line: 38)
!789 = !DIFile(filename: "/opt/rh/gcc-toolset-13/root/usr/lib/gcc/x86_64-redhat-linux/13/../../../../include/c++/13/stdlib.h", directory: "")
!790 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !625, file: !789, line: 39)
!791 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !658, file: !789, line: 40)
!792 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !630, file: !789, line: 43)
!793 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !701, file: !789, line: 46)
!794 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !750, file: !789, line: 49)
!795 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !603, file: !789, line: 54)
!796 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !607, file: !789, line: 55)
!797 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !798, file: !789, line: 57)
!798 = !DISubprogram(name: "abs", linkageName: "_ZSt3absg", scope: !93, file: !288, line: 137, type: !799, flags: DIFlagPrototyped, spFlags: 0)
!799 = !DISubroutineType(types: !800)
!800 = !{!801, !801}
!801 = !DIBasicType(name: "__float128", size: 128, encoding: DW_ATE_float)
!802 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !632, file: !789, line: 58)
!803 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !634, file: !789, line: 59)
!804 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !638, file: !789, line: 60)
!805 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !642, file: !789, line: 61)
!806 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !652, file: !789, line: 62)
!807 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !781, file: !789, line: 63)
!808 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !662, file: !789, line: 64)
!809 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !666, file: !789, line: 65)
!810 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !671, file: !789, line: 66)
!811 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !673, file: !789, line: 67)
!812 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !677, file: !789, line: 68)
!813 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !681, file: !789, line: 70)
!814 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !685, file: !789, line: 71)
!815 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !693, file: !789, line: 72)
!816 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !697, file: !789, line: 74)
!817 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !703, file: !789, line: 75)
!818 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !707, file: !789, line: 76)
!819 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !711, file: !789, line: 77)
!820 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !715, file: !789, line: 78)
!821 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !721, file: !789, line: 79)
!822 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !725, file: !789, line: 80)
!823 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !729, file: !789, line: 81)
!824 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !731, file: !789, line: 83)
!825 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !739, file: !789, line: 84)
!826 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !827, file: !829, line: 443)
!827 = !DISubprogram(name: "acosf", linkageName: "_ZL5acosff", scope: !828, file: !828, line: 63, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!828 = !DIFile(filename: "/storage/users/sislam3/opt/llvm-22/lib/clang/22/include/__clang_cuda_math.h", directory: "")
!829 = !DIFile(filename: "/storage/users/sislam3/opt/llvm-22/lib/clang/22/include/__clang_cuda_cmath.h", directory: "")
!830 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !831, file: !829, line: 444)
!831 = !DISubprogram(name: "acoshf", linkageName: "_ZL6acoshff", scope: !828, file: !828, line: 65, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!832 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !833, file: !829, line: 445)
!833 = !DISubprogram(name: "asinf", linkageName: "_ZL5asinff", scope: !828, file: !828, line: 67, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!834 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !835, file: !829, line: 446)
!835 = !DISubprogram(name: "asinhf", linkageName: "_ZL6asinhff", scope: !828, file: !828, line: 69, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!836 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !837, file: !829, line: 447)
!837 = !DISubprogram(name: "atan2f", linkageName: "_ZL6atan2fff", scope: !828, file: !828, line: 72, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!838 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !839, file: !829, line: 448)
!839 = !DISubprogram(name: "atanf", linkageName: "_ZL5atanff", scope: !828, file: !828, line: 73, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!840 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !841, file: !829, line: 449)
!841 = !DISubprogram(name: "atanhf", linkageName: "_ZL6atanhff", scope: !828, file: !828, line: 75, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!842 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !843, file: !829, line: 450)
!843 = !DISubprogram(name: "cbrtf", linkageName: "_ZL5cbrtff", scope: !828, file: !828, line: 77, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!844 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !845, file: !829, line: 451)
!845 = !DISubprogram(name: "ceilf", linkageName: "_ZL5ceilff", scope: !828, file: !828, line: 79, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!846 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !847, file: !829, line: 452)
!847 = !DISubprogram(name: "copysignf", linkageName: "_ZL9copysignfff", scope: !828, file: !828, line: 83, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!848 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !849, file: !829, line: 453)
!849 = !DISubprogram(name: "cosf", linkageName: "_ZL4cosff", scope: !828, file: !828, line: 87, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!850 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !851, file: !829, line: 454)
!851 = !DISubprogram(name: "coshf", linkageName: "_ZL5coshff", scope: !828, file: !828, line: 91, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!852 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !853, file: !829, line: 455)
!853 = !DISubprogram(name: "erfcf", linkageName: "_ZL5erfcff", scope: !828, file: !828, line: 100, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!854 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !855, file: !829, line: 456)
!855 = !DISubprogram(name: "erff", linkageName: "_ZL4erfff", scope: !828, file: !828, line: 105, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!856 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !857, file: !829, line: 457)
!857 = !DISubprogram(name: "exp2f", linkageName: "_ZL5exp2ff", scope: !828, file: !828, line: 112, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!858 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !859, file: !829, line: 458)
!859 = distinct !DISubprogram(name: "expf", linkageName: "_ZL4expff", scope: !828, file: !828, line: 113, type: !101, scopeLine: 113, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !860)
!860 = !{}
!861 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !862, file: !829, line: 459)
!862 = !DISubprogram(name: "expm1f", linkageName: "_ZL6expm1ff", scope: !828, file: !828, line: 115, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!863 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !864, file: !829, line: 460)
!864 = distinct !DISubprogram(name: "fabsf", linkageName: "_ZL5fabsff", scope: !828, file: !828, line: 116, type: !101, scopeLine: 116, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !860)
!865 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !866, file: !829, line: 461)
!866 = !DISubprogram(name: "fdimf", linkageName: "_ZL5fdimfff", scope: !828, file: !828, line: 118, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!867 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !868, file: !829, line: 462)
!868 = !DISubprogram(name: "floorf", linkageName: "_ZL6floorff", scope: !828, file: !828, line: 128, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!869 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !870, file: !829, line: 463)
!870 = !DISubprogram(name: "fmaf", linkageName: "_ZL4fmaffff", scope: !828, file: !828, line: 132, type: !146, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!871 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !872, file: !829, line: 464)
!872 = !DISubprogram(name: "fmaxf", linkageName: "_ZL5fmaxfff", scope: !828, file: !828, line: 136, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!873 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !874, file: !829, line: 465)
!874 = !DISubprogram(name: "fminf", linkageName: "_ZL5fminfff", scope: !828, file: !828, line: 138, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!875 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !876, file: !829, line: 466)
!876 = !DISubprogram(name: "fmodf", linkageName: "_ZL5fmodfff", scope: !828, file: !828, line: 140, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!877 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !878, file: !829, line: 467)
!878 = !DISubprogram(name: "frexpf", linkageName: "_ZL6frexpffPi", scope: !828, file: !828, line: 142, type: !160, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!879 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !880, file: !829, line: 468)
!880 = !DISubprogram(name: "hypotf", linkageName: "_ZL6hypotfff", scope: !828, file: !828, line: 144, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!881 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !882, file: !829, line: 469)
!882 = !DISubprogram(name: "ilogbf", linkageName: "_ZL6ilogbff", scope: !828, file: !828, line: 146, type: !156, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!883 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !884, file: !829, line: 470)
!884 = !DISubprogram(name: "ldexpf", linkageName: "_ZL6ldexpffi", scope: !828, file: !828, line: 159, type: !199, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!885 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !886, file: !829, line: 471)
!886 = !DISubprogram(name: "lgammaf", linkageName: "_ZL7lgammaff", scope: !828, file: !828, line: 161, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!887 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !888, file: !829, line: 472)
!888 = !DISubprogram(name: "llrintf", linkageName: "_ZL7llrintff", scope: !828, file: !828, line: 170, type: !210, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!889 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !890, file: !829, line: 473)
!890 = !DISubprogram(name: "llroundf", linkageName: "_ZL8llroundff", scope: !828, file: !828, line: 172, type: !210, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!891 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !892, file: !829, line: 474)
!892 = !DISubprogram(name: "log10f", linkageName: "_ZL6log10ff", scope: !828, file: !828, line: 177, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!893 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !894, file: !829, line: 475)
!894 = !DISubprogram(name: "log1pf", linkageName: "_ZL6log1pff", scope: !828, file: !828, line: 179, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!895 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !896, file: !829, line: 476)
!896 = !DISubprogram(name: "log2f", linkageName: "_ZL5log2ff", scope: !828, file: !828, line: 181, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!897 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !898, file: !829, line: 477)
!898 = !DISubprogram(name: "logbf", linkageName: "_ZL5logbff", scope: !828, file: !828, line: 185, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!899 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !900, file: !829, line: 478)
!900 = distinct !DISubprogram(name: "logf", linkageName: "_ZL4logff", scope: !828, file: !828, line: 186, type: !101, scopeLine: 186, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !860)
!901 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !902, file: !829, line: 479)
!902 = !DISubprogram(name: "lrintf", linkageName: "_ZL6lrintff", scope: !828, file: !828, line: 191, type: !224, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!903 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !904, file: !829, line: 480)
!904 = !DISubprogram(name: "lroundf", linkageName: "_ZL7lroundff", scope: !828, file: !828, line: 193, type: !224, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!905 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !906, file: !829, line: 481)
!906 = !DISubprogram(name: "modff", linkageName: "_ZL5modfffPf", scope: !828, file: !828, line: 203, type: !232, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!907 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !908, file: !829, line: 482)
!908 = !DISubprogram(name: "nearbyintf", linkageName: "_ZL10nearbyintff", scope: !828, file: !828, line: 205, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!909 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !910, file: !829, line: 483)
!910 = !DISubprogram(name: "nextafterf", linkageName: "_ZL10nextafterfff", scope: !828, file: !828, line: 209, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!911 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !912, file: !829, line: 484)
!912 = distinct !DISubprogram(name: "powf", linkageName: "_ZL4powfff", scope: !828, file: !828, line: 235, type: !114, scopeLine: 235, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !860)
!913 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !914, file: !829, line: 485)
!914 = !DISubprogram(name: "remainderf", linkageName: "_ZL10remainderfff", scope: !828, file: !828, line: 243, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!915 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !916, file: !829, line: 486)
!916 = !DISubprogram(name: "remquof", linkageName: "_ZL7remquofffPi", scope: !828, file: !828, line: 249, type: !257, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!917 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !918, file: !829, line: 487)
!918 = !DISubprogram(name: "rintf", linkageName: "_ZL5rintff", scope: !828, file: !828, line: 260, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!919 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !920, file: !829, line: 488)
!920 = !DISubprogram(name: "roundf", linkageName: "_ZL6roundff", scope: !828, file: !828, line: 174, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!921 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !922, file: !829, line: 489)
!922 = !DISubprogram(name: "scalblnf", linkageName: "_ZL8scalblnffl", scope: !828, file: !828, line: 290, type: !265, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!923 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !924, file: !829, line: 490)
!924 = !DISubprogram(name: "scalbnf", linkageName: "_ZL7scalbnffi", scope: !828, file: !828, line: 282, type: !199, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!925 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !926, file: !829, line: 491)
!926 = !DISubprogram(name: "sinf", linkageName: "_ZL4sinff", scope: !828, file: !828, line: 310, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!927 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !928, file: !829, line: 492)
!928 = !DISubprogram(name: "sinhf", linkageName: "_ZL5sinhff", scope: !828, file: !828, line: 314, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!929 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !930, file: !829, line: 493)
!930 = distinct !DISubprogram(name: "sqrtf", linkageName: "_ZL5sqrtff", scope: !828, file: !828, line: 318, type: !101, scopeLine: 318, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !860)
!931 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !932, file: !829, line: 494)
!932 = !DISubprogram(name: "tanf", linkageName: "_ZL4tanff", scope: !828, file: !828, line: 320, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!933 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !934, file: !829, line: 495)
!934 = !DISubprogram(name: "tanhf", linkageName: "_ZL5tanhff", scope: !828, file: !828, line: 322, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!935 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !936, file: !829, line: 496)
!936 = !DISubprogram(name: "tgammaf", linkageName: "_ZL7tgammaff", scope: !828, file: !828, line: 324, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!937 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !938, file: !829, line: 497)
!938 = !DISubprogram(name: "truncf", linkageName: "_ZL6truncff", scope: !828, file: !828, line: 326, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!939 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !3, file: !4, line: 181)
!940 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !28, file: !4, line: 182)
!941 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !942, file: !4, line: 208)
!942 = !DISubprogram(name: "is_exactly", linkageName: "_ZN2nv6target6detail10is_exactlyENS1_11sm_selectorE", scope: !5, file: !4, line: 153, type: !943, flags: DIFlagPrototyped, spFlags: 0)
!943 = !DISubroutineType(types: !944)
!944 = !{!28, !3}
!945 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !946, file: !4, line: 209)
!946 = !DISubprogram(name: "provides", linkageName: "_ZN2nv6target6detail8providesENS1_11sm_selectorE", scope: !5, file: !4, line: 158, type: !943, flags: DIFlagPrototyped, spFlags: 0)
!947 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !798, file: !948, line: 38)
!948 = !DIFile(filename: "/opt/rh/gcc-toolset-13/root/usr/lib/gcc/x86_64-redhat-linux/13/../../../../include/c++/13/math.h", directory: "")
!949 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !950, file: !948, line: 54)
!950 = !DISubprogram(name: "modf", linkageName: "_ZSt4modfePe", scope: !93, file: !294, line: 364, type: !951, flags: DIFlagPrototyped, spFlags: 0)
!951 = !DISubroutineType(types: !952)
!952 = !{!359, !359, !953}
!953 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !359, size: 64)
!954 = !{!"clang version 22.1.5 (https://github.com/llvm/llvm-project.git 5ea218a153f4d2f815b8244eab3e4b4ba5e00e6c)"}
!955 = !{!"clang version 3.8.0 (tags/RELEASE_380/final)"}
!956 = !{i32 2, i32 0}
!957 = !{i32 2, !"SDK Version", [2 x i32] [i32 12, i32 8]}
!958 = !{i32 7, !"Dwarf Version", i32 2}
!959 = !{i32 2, !"Debug Info Version", i32 3}
!960 = !{i32 1, !"wchar_size", i32 4}
!961 = !{i32 4, !"nvvm-reflect-ftz", i32 0}
!962 = !{i32 7, !"frame-pointer", i32 2}
!963 = distinct !DISubprogram(name: "is_subnormal", linkageName: "_Z12is_subnormalf", scope: !1, file: !1, line: 6, type: !169, scopeLine: 6, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !860)
!964 = !DILocalVariable(name: "x", arg: 1, scope: !963, file: !1, line: 6, type: !103)
!965 = !DILocation(line: 6, column: 36, scope: !963)
!966 = !DILocation(line: 7, column: 13, scope: !963)
!967 = !DILocation(line: 7, column: 15, scope: !963)
!968 = !DILocation(line: 7, column: 24, scope: !963)
!969 = !DILocation(line: 7, column: 34, scope: !963)
!970 = !DILocalVariable(name: "__a", arg: 1, scope: !864, file: !828, line: 116, type: !103)
!971 = !DILocation(line: 116, column: 30, scope: !864, inlinedAt: !972)
!972 = distinct !DILocation(line: 7, column: 28, scope: !963)
!973 = !DILocation(line: 116, column: 55, scope: !864, inlinedAt: !972)
!974 = !DILocation(line: 116, column: 44, scope: !864, inlinedAt: !972)
!975 = !DILocation(line: 7, column: 37, scope: !963)
!976 = !DILocation(line: 0, scope: !963)
!977 = !DILocation(line: 7, column: 5, scope: !963)
!978 = distinct !DISubprogram(name: "testUnderflow_Operations", linkageName: "_Z24testUnderflow_OperationsPfPi", scope: !1, file: !1, line: 10, type: !979, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !860)
!979 = !DISubroutineType(types: !980)
!980 = !{null, !234, !162}
!981 = !DILocalVariable(name: "result", arg: 1, scope: !978, file: !1, line: 10, type: !234)
!982 = !DILocation(line: 10, column: 49, scope: !978)
!983 = !DILocalVariable(name: "is_denorm", arg: 2, scope: !978, file: !1, line: 10, type: !162)
!984 = !DILocation(line: 10, column: 62, scope: !978)
!985 = !DILocalVariable(name: "idx", scope: !978, file: !1, line: 11, type: !98)
!986 = !DILocation(line: 11, column: 9, scope: !978)
!987 = !DILocation(line: 53, column: 27, scope: !988, inlinedAt: !989)
!988 = distinct !DISubprogram(name: "__fetch_builtin_x", linkageName: "_ZN26__cuda_builtin_threadIdx_t17__fetch_builtin_xEv", scope: !60, file: !61, line: 53, type: !64, scopeLine: 53, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, declaration: !63)
!989 = distinct !DILocation(line: 11, column: 15, scope: !978)
!990 = !DILocalVariable(name: "tiny", scope: !978, file: !1, line: 13, type: !103)
!991 = !DILocation(line: 13, column: 11, scope: !978)
!992 = !DILocation(line: 17, column: 9, scope: !993)
!993 = distinct !DILexicalBlock(scope: !978, file: !1, line: 17, column: 9)
!994 = !DILocation(line: 17, column: 13, scope: !993)
!995 = !DILocation(line: 19, column: 21, scope: !996)
!996 = distinct !DILexicalBlock(scope: !993, file: !1, line: 17, column: 19)
!997 = !DILocation(line: 19, column: 26, scope: !996)
!998 = !DILocation(line: 19, column: 9, scope: !996)
!999 = !DILocation(line: 19, column: 19, scope: !996)
!1000 = !DILocation(line: 20, column: 37, scope: !996)
!1001 = !DILocation(line: 20, column: 24, scope: !996)
!1002 = !DILocation(line: 20, column: 9, scope: !996)
!1003 = !DILocation(line: 20, column: 22, scope: !996)
!1004 = !DILocation(line: 21, column: 5, scope: !996)
!1005 = !DILocation(line: 23, column: 9, scope: !1006)
!1006 = distinct !DILexicalBlock(scope: !978, file: !1, line: 23, column: 9)
!1007 = !DILocation(line: 23, column: 13, scope: !1006)
!1008 = !DILocation(line: 25, column: 21, scope: !1009)
!1009 = distinct !DILexicalBlock(scope: !1006, file: !1, line: 23, column: 19)
!1010 = !DILocation(line: 25, column: 26, scope: !1009)
!1011 = !DILocation(line: 25, column: 9, scope: !1009)
!1012 = !DILocation(line: 25, column: 19, scope: !1009)
!1013 = !DILocation(line: 26, column: 37, scope: !1009)
!1014 = !DILocation(line: 26, column: 24, scope: !1009)
!1015 = !DILocation(line: 26, column: 9, scope: !1009)
!1016 = !DILocation(line: 26, column: 22, scope: !1009)
!1017 = !DILocation(line: 27, column: 5, scope: !1009)
!1018 = !DILocation(line: 29, column: 9, scope: !1019)
!1019 = distinct !DILexicalBlock(scope: !978, file: !1, line: 29, column: 9)
!1020 = !DILocation(line: 29, column: 13, scope: !1019)
!1021 = !DILocalVariable(name: "a", scope: !1022, file: !1, line: 31, type: !103)
!1022 = distinct !DILexicalBlock(scope: !1019, file: !1, line: 29, column: 19)
!1023 = !DILocation(line: 31, column: 15, scope: !1022)
!1024 = !DILocalVariable(name: "b", scope: !1022, file: !1, line: 32, type: !103)
!1025 = !DILocation(line: 32, column: 15, scope: !1022)
!1026 = !DILocation(line: 33, column: 21, scope: !1022)
!1027 = !DILocation(line: 33, column: 25, scope: !1022)
!1028 = !DILocation(line: 33, column: 23, scope: !1022)
!1029 = !DILocation(line: 33, column: 9, scope: !1022)
!1030 = !DILocation(line: 33, column: 19, scope: !1022)
!1031 = !DILocation(line: 34, column: 37, scope: !1022)
!1032 = !DILocation(line: 34, column: 24, scope: !1022)
!1033 = !DILocation(line: 34, column: 9, scope: !1022)
!1034 = !DILocation(line: 34, column: 22, scope: !1022)
!1035 = !DILocation(line: 35, column: 5, scope: !1022)
!1036 = !DILocation(line: 37, column: 9, scope: !1037)
!1037 = distinct !DILexicalBlock(scope: !978, file: !1, line: 37, column: 9)
!1038 = !DILocation(line: 37, column: 13, scope: !1037)
!1039 = !DILocalVariable(name: "denorm", scope: !1040, file: !1, line: 39, type: !103)
!1040 = distinct !DILexicalBlock(scope: !1037, file: !1, line: 37, column: 19)
!1041 = !DILocation(line: 39, column: 15, scope: !1040)
!1042 = !DILocation(line: 40, column: 21, scope: !1040)
!1043 = !DILocation(line: 40, column: 30, scope: !1040)
!1044 = !DILocation(line: 40, column: 28, scope: !1040)
!1045 = !DILocation(line: 40, column: 9, scope: !1040)
!1046 = !DILocation(line: 40, column: 19, scope: !1040)
!1047 = !DILocation(line: 41, column: 37, scope: !1040)
!1048 = !DILocation(line: 41, column: 24, scope: !1040)
!1049 = !DILocation(line: 41, column: 9, scope: !1040)
!1050 = !DILocation(line: 41, column: 22, scope: !1040)
!1051 = !DILocation(line: 42, column: 5, scope: !1040)
!1052 = !DILocation(line: 44, column: 9, scope: !1053)
!1053 = distinct !DILexicalBlock(scope: !978, file: !1, line: 44, column: 9)
!1054 = !DILocation(line: 44, column: 13, scope: !1053)
!1055 = !DILocation(line: 46, column: 27, scope: !1056)
!1056 = distinct !DILexicalBlock(scope: !1053, file: !1, line: 44, column: 19)
!1057 = !DILocalVariable(name: "__a", arg: 1, scope: !930, file: !828, line: 318, type: !103)
!1058 = !DILocation(line: 318, column: 30, scope: !930, inlinedAt: !1059)
!1059 = distinct !DILocation(line: 46, column: 21, scope: !1056)
!1060 = !DILocation(line: 318, column: 55, scope: !930, inlinedAt: !1059)
!1061 = !DILocation(line: 318, column: 44, scope: !930, inlinedAt: !1059)
!1062 = !DILocation(line: 46, column: 9, scope: !1056)
!1063 = !DILocation(line: 46, column: 19, scope: !1056)
!1064 = !DILocation(line: 47, column: 37, scope: !1056)
!1065 = !DILocation(line: 47, column: 24, scope: !1056)
!1066 = !DILocation(line: 47, column: 9, scope: !1056)
!1067 = !DILocation(line: 47, column: 22, scope: !1056)
!1068 = !DILocation(line: 48, column: 5, scope: !1056)
!1069 = !DILocation(line: 50, column: 9, scope: !1070)
!1070 = distinct !DILexicalBlock(scope: !978, file: !1, line: 50, column: 9)
!1071 = !DILocation(line: 50, column: 13, scope: !1070)
!1072 = !DILocalVariable(name: "__a", arg: 1, scope: !859, file: !828, line: 113, type: !103)
!1073 = !DILocation(line: 113, column: 29, scope: !859, inlinedAt: !1074)
!1074 = distinct !DILocation(line: 52, column: 21, scope: !1075)
!1075 = distinct !DILexicalBlock(scope: !1070, file: !1, line: 50, column: 19)
!1076 = !DILocation(line: 113, column: 53, scope: !859, inlinedAt: !1074)
!1077 = !DILocation(line: 113, column: 43, scope: !859, inlinedAt: !1074)
!1078 = !DILocation(line: 52, column: 9, scope: !1075)
!1079 = !DILocation(line: 52, column: 19, scope: !1075)
!1080 = !DILocation(line: 53, column: 37, scope: !1075)
!1081 = !DILocation(line: 53, column: 24, scope: !1075)
!1082 = !DILocation(line: 53, column: 9, scope: !1075)
!1083 = !DILocation(line: 53, column: 22, scope: !1075)
!1084 = !DILocation(line: 54, column: 5, scope: !1075)
!1085 = !DILocation(line: 56, column: 9, scope: !1086)
!1086 = distinct !DILexicalBlock(scope: !978, file: !1, line: 56, column: 9)
!1087 = !DILocation(line: 56, column: 13, scope: !1086)
!1088 = !DILocalVariable(name: "__a", arg: 1, scope: !912, file: !828, line: 235, type: !103)
!1089 = !DILocation(line: 235, column: 29, scope: !912, inlinedAt: !1090)
!1090 = distinct !DILocation(line: 58, column: 21, scope: !1091)
!1091 = distinct !DILexicalBlock(scope: !1086, file: !1, line: 56, column: 19)
!1092 = !DILocalVariable(name: "__b", arg: 2, scope: !912, file: !828, line: 235, type: !103)
!1093 = !DILocation(line: 235, column: 40, scope: !912, inlinedAt: !1090)
!1094 = !DILocation(line: 235, column: 64, scope: !912, inlinedAt: !1090)
!1095 = !DILocation(line: 235, column: 69, scope: !912, inlinedAt: !1090)
!1096 = !DILocation(line: 235, column: 54, scope: !912, inlinedAt: !1090)
!1097 = !{i32 21684}
!1098 = !DILocation(line: 58, column: 9, scope: !1091)
!1099 = !DILocation(line: 58, column: 19, scope: !1091)
!1100 = !DILocation(line: 59, column: 37, scope: !1091)
!1101 = !DILocation(line: 59, column: 24, scope: !1091)
!1102 = !DILocation(line: 59, column: 9, scope: !1091)
!1103 = !DILocation(line: 59, column: 22, scope: !1091)
!1104 = !DILocation(line: 60, column: 5, scope: !1091)
!1105 = !DILocation(line: 62, column: 9, scope: !1106)
!1106 = distinct !DILexicalBlock(scope: !978, file: !1, line: 62, column: 9)
!1107 = !DILocation(line: 62, column: 13, scope: !1106)
!1108 = !DILocalVariable(name: "__a", arg: 1, scope: !900, file: !828, line: 186, type: !103)
!1109 = !DILocation(line: 186, column: 29, scope: !900, inlinedAt: !1110)
!1110 = distinct !DILocation(line: 64, column: 21, scope: !1111)
!1111 = distinct !DILexicalBlock(scope: !1106, file: !1, line: 62, column: 19)
!1112 = !DILocation(line: 187, column: 52, scope: !900, inlinedAt: !1110)
!1113 = !DILocation(line: 187, column: 41, scope: !900, inlinedAt: !1110)
!1114 = !DILocation(line: 64, column: 9, scope: !1111)
!1115 = !DILocation(line: 64, column: 19, scope: !1111)
!1116 = !DILocation(line: 65, column: 37, scope: !1111)
!1117 = !DILocation(line: 65, column: 24, scope: !1111)
!1118 = !DILocation(line: 65, column: 9, scope: !1111)
!1119 = !DILocation(line: 65, column: 22, scope: !1111)
!1120 = !DILocation(line: 66, column: 5, scope: !1111)
!1121 = !DILocation(line: 67, column: 1, scope: !978)
