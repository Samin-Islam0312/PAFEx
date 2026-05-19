; ModuleID = '/home/users/sislam3/SBAC-PAD/results/divZero/divByZero/instrumented_device.bc'
source_filename = "llvm-link"
target datalayout = "e-p6:32:32-i64:64-i128:128-i256:256-v16:16-v32:32-n16:32:64"
target triple = "nvptx64-nvidia-cuda"

@fp_counters = addrspace(1) global [6 x i64] zeroinitializer, align 8

; Function Attrs: convergent noinline norecurse nounwind optnone
define dso_local ptx_kernel void @_Z13testDivByZeroPfPiffff(ptr noundef %result, ptr noundef %sign_check, float noundef %pos_num, float noundef %neg_num, float noundef %pos_zero, float noundef %neg_zero) #0 !dbg !963 {
entry:
  %__a.addr.i107 = alloca float, align 4
  %__a.addr.i105 = alloca float, align 4
  %__a.addr.i103 = alloca float, align 4
  %__a.addr.i101 = alloca float, align 4
  %__a.addr.i99 = alloca float, align 4
  %__a.addr.i97 = alloca float, align 4
  %__a.addr.i95 = alloca float, align 4
  %__a.addr.i = alloca float, align 4
  %__x.addr.i91 = alloca float, align 4
  %__x.addr.i88 = alloca float, align 4
  %__x.addr.i85 = alloca float, align 4
  %__x.addr.i82 = alloca float, align 4
  %__x.addr.i79 = alloca float, align 4
  %__x.addr.i76 = alloca float, align 4
  %__x.addr.i73 = alloca float, align 4
  %__x.addr.i = alloca float, align 4
  %result.addr = alloca ptr, align 8
  %sign_check.addr = alloca ptr, align 8
  %pos_num.addr = alloca float, align 4
  %neg_num.addr = alloca float, align 4
  %pos_zero.addr = alloca float, align 4
  %neg_zero.addr = alloca float, align 4
  %idx = alloca i32, align 4
  store ptr %result, ptr %result.addr, align 8
    #dbg_declare(ptr %result.addr, !966, !DIExpression(), !967)
  store ptr %sign_check, ptr %sign_check.addr, align 8
    #dbg_declare(ptr %sign_check.addr, !968, !DIExpression(), !969)
  store float %pos_num, ptr %pos_num.addr, align 4
    #dbg_declare(ptr %pos_num.addr, !970, !DIExpression(), !971)
  store float %neg_num, ptr %neg_num.addr, align 4
    #dbg_declare(ptr %neg_num.addr, !972, !DIExpression(), !973)
  store float %pos_zero, ptr %pos_zero.addr, align 4
    #dbg_declare(ptr %pos_zero.addr, !974, !DIExpression(), !975)
  store float %neg_zero, ptr %neg_zero.addr, align 4
    #dbg_declare(ptr %neg_zero.addr, !976, !DIExpression(), !977)
    #dbg_declare(ptr %idx, !978, !DIExpression(), !979)
  %0 = call noundef i32 @llvm.nvvm.read.ptx.sreg.tid.x(), !dbg !980
  store i32 %0, ptr %idx, align 4, !dbg !979
  %1 = load i32, ptr %idx, align 4, !dbg !983
  %cmp = icmp eq i32 %1, 0, !dbg !985
  br i1 %cmp, label %if.then, label %if.end, !dbg !985

if.then:                                          ; preds = %entry
  %2 = load float, ptr %pos_num.addr, align 4, !dbg !986
  %3 = load float, ptr %pos_zero.addr, align 4, !dbg !988
  %4 = bitcast float %2 to i32, !dbg !989
  %5 = bitcast float %2 to i32, !dbg !989
  %6 = and i32 %5, 2139095040, !dbg !989
  %7 = icmp eq i32 %6, 2139095040, !dbg !989
  %8 = and i32 %5, 8388607, !dbg !989
  %9 = icmp ne i32 %8, 0, !dbg !989
  %is_nan = and i1 %7, %9, !dbg !989
  %10 = and i32 %4, 4194304, !dbg !989
  %11 = icmp eq i32 %10, 0, !dbg !989
  %is_snan = and i1 %is_nan, %11, !dbg !989
  %12 = bitcast float %3 to i32, !dbg !989
  %13 = bitcast float %3 to i32, !dbg !989
  %14 = and i32 %13, 2139095040, !dbg !989
  %15 = icmp eq i32 %14, 2139095040, !dbg !989
  %16 = and i32 %13, 8388607, !dbg !989
  %17 = icmp ne i32 %16, 0, !dbg !989
  %is_nan1 = and i1 %15, %17, !dbg !989
  %18 = and i32 %12, 4194304, !dbg !989
  %19 = icmp eq i32 %18, 0, !dbg !989
  %is_snan2 = and i1 %is_nan1, %19, !dbg !989
  %20 = or i1 %is_snan, %is_snan2, !dbg !989
  %21 = bitcast float %2 to i32, !dbg !989
  %22 = and i32 %21, 2147483647, !dbg !989
  %is_zero = icmp eq i32 %22, 0, !dbg !989
  %23 = bitcast float %3 to i32, !dbg !989
  %24 = and i32 %23, 2147483647, !dbg !989
  %is_zero3 = icmp eq i32 %24, 0, !dbg !989
  %25 = and i1 %is_zero, %is_zero3, !dbg !989
  %26 = bitcast float %2 to i32, !dbg !989
  %27 = and i32 %26, 2139095040, !dbg !989
  %28 = icmp eq i32 %27, 2139095040, !dbg !989
  %29 = and i32 %26, 8388607, !dbg !989
  %30 = icmp eq i32 %29, 0, !dbg !989
  %is_inf = and i1 %28, %30, !dbg !989
  %31 = bitcast float %3 to i32, !dbg !989
  %32 = and i32 %31, 2139095040, !dbg !989
  %33 = icmp eq i32 %32, 2139095040, !dbg !989
  %34 = and i32 %31, 8388607, !dbg !989
  %35 = icmp eq i32 %34, 0, !dbg !989
  %is_inf4 = and i1 %33, %35, !dbg !989
  %36 = and i1 %is_inf, %is_inf4, !dbg !989
  %37 = or i1 %25, %36, !dbg !989
  %38 = or i1 %20, %37, !dbg !989
  br i1 %38, label %39, label %41, !dbg !989

39:                                               ; preds = %if.then
  %40 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !989
  br label %41, !dbg !989

41:                                               ; preds = %if.then, %39
  %42 = bitcast float %3 to i32, !dbg !989
  %43 = and i32 %42, 2147483647, !dbg !989
  %is_zero5 = icmp eq i32 %43, 0, !dbg !989
  %44 = bitcast float %2 to i32, !dbg !989
  %45 = and i32 %44, 2139095040, !dbg !989
  %is_finite = icmp ne i32 %45, 2139095040, !dbg !989
  %46 = bitcast float %2 to i32, !dbg !989
  %47 = and i32 %46, 2147483647, !dbg !989
  %is_zero6 = icmp eq i32 %47, 0, !dbg !989
  %48 = xor i1 %is_zero6, true, !dbg !989
  %49 = and i1 %is_finite, %48, !dbg !989
  %divzero_cond = and i1 %is_zero5, %49, !dbg !989
  br i1 %divzero_cond, label %50, label %52, !dbg !989

50:                                               ; preds = %41
  %51 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 1), i64 1 monotonic, align 8, !dbg !989
  br label %52, !dbg !989

52:                                               ; preds = %41, %50
  %div = fdiv contract float %2, %3, !dbg !989
  %53 = bitcast float %2 to i32, !dbg !990
  %54 = and i32 %53, 2139095040, !dbg !990
  %is_finite7 = icmp ne i32 %54, 2139095040, !dbg !990
  %55 = and i1 true, %is_finite7, !dbg !990
  %56 = bitcast float %3 to i32, !dbg !990
  %57 = and i32 %56, 2139095040, !dbg !990
  %is_finite8 = icmp ne i32 %57, 2139095040, !dbg !990
  %58 = and i1 %55, %is_finite8, !dbg !990
  %59 = bitcast float %3 to i32, !dbg !990
  %60 = and i32 %59, 2147483647, !dbg !990
  %is_zero9 = icmp eq i32 %60, 0, !dbg !990
  %61 = xor i1 %is_zero9, true, !dbg !990
  %overflow_denom_nonzero = and i1 %58, %61, !dbg !990
  %62 = bitcast float %div to i32, !dbg !990
  %63 = and i32 %62, 2139095040, !dbg !990
  %64 = icmp eq i32 %63, 2139095040, !dbg !990
  %65 = and i32 %62, 8388607, !dbg !990
  %66 = icmp eq i32 %65, 0, !dbg !990
  %is_inf10 = and i1 %64, %66, !dbg !990
  %67 = bitcast float %div to i32, !dbg !990
  %68 = and i32 %67, 2147483647, !dbg !990
  %is_maxfinite = icmp eq i32 %68, 2139095039, !dbg !990
  %69 = bitcast float %div to i32, !dbg !990
  %70 = and i32 %69, -2147483648, !dbg !990
  %71 = icmp eq i32 %70, 0, !dbg !990
  %72 = icmp ne i32 %70, 0, !dbg !990
  %is_pos_inf = and i1 %is_inf10, %71, !dbg !990
  %is_neg_inf = and i1 %is_inf10, %72, !dbg !990
  %is_pos_max = and i1 %is_maxfinite, %71, !dbg !990
  %is_neg_max = and i1 %is_maxfinite, %72, !dbg !990
  %overflow_cond = and i1 %overflow_denom_nonzero, %is_inf10, !dbg !990
  br i1 %overflow_cond, label %73, label %75, !dbg !990

73:                                               ; preds = %52
  %74 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !990
  br label %75, !dbg !990

75:                                               ; preds = %52, %73
  %76 = bitcast float %2 to i32, !dbg !990
  %77 = and i32 %76, 2139095040, !dbg !990
  %78 = icmp eq i32 %77, 0, !dbg !990
  %79 = and i32 %76, 8388607, !dbg !990
  %80 = icmp ne i32 %79, 0, !dbg !990
  %is_subnormal = and i1 %78, %80, !dbg !990
  %81 = xor i1 %is_subnormal, true, !dbg !990
  %82 = and i1 true, %81, !dbg !990
  %83 = bitcast float %3 to i32, !dbg !990
  %84 = and i32 %83, 2139095040, !dbg !990
  %85 = icmp eq i32 %84, 0, !dbg !990
  %86 = and i32 %83, 8388607, !dbg !990
  %87 = icmp ne i32 %86, 0, !dbg !990
  %is_subnormal11 = and i1 %85, %87, !dbg !990
  %88 = xor i1 %is_subnormal11, true, !dbg !990
  %89 = and i1 %82, %88, !dbg !990
  %90 = bitcast float %div to i32, !dbg !990
  %91 = and i32 %90, 2139095040, !dbg !990
  %92 = icmp eq i32 %91, 0, !dbg !990
  %93 = and i32 %90, 8388607, !dbg !990
  %94 = icmp ne i32 %93, 0, !dbg !990
  %is_subnormal12 = and i1 %92, %94, !dbg !990
  %95 = bitcast float %div to i32, !dbg !990
  %96 = and i32 %95, 2147483647, !dbg !990
  %is_zero13 = icmp eq i32 %96, 0, !dbg !990
  %97 = bitcast float %2 to i32, !dbg !990
  %98 = and i32 %97, 2147483647, !dbg !990
  %is_zero14 = icmp eq i32 %98, 0, !dbg !990
  %99 = xor i1 %is_zero14, true, !dbg !990
  %100 = bitcast float %3 to i32, !dbg !990
  %101 = and i32 %100, 2147483647, !dbg !990
  %is_zero15 = icmp eq i32 %101, 0, !dbg !990
  %102 = xor i1 %is_zero15, true, !dbg !990
  %103 = and i1 %99, %102, !dbg !990
  %104 = and i1 %is_zero13, %103, !dbg !990
  %is_tiny = or i1 %is_subnormal12, %104, !dbg !990
  %underflow_cond = and i1 %89, %is_tiny, !dbg !990
  br i1 %underflow_cond, label %105, label %107, !dbg !990

105:                                              ; preds = %75
  %106 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !990
  br label %107, !dbg !990

107:                                              ; preds = %75, %105
  %108 = bitcast float %2 to i32, !dbg !990
  %109 = and i32 %108, 2139095040, !dbg !990
  %110 = icmp eq i32 %109, 0, !dbg !990
  %111 = and i32 %108, 8388607, !dbg !990
  %112 = icmp ne i32 %111, 0, !dbg !990
  %is_subnormal16 = and i1 %110, %112, !dbg !990
  %113 = xor i1 %is_subnormal16, true, !dbg !990
  %114 = and i1 true, %113, !dbg !990
  %115 = bitcast float %3 to i32, !dbg !990
  %116 = and i32 %115, 2139095040, !dbg !990
  %117 = icmp eq i32 %116, 0, !dbg !990
  %118 = and i32 %115, 8388607, !dbg !990
  %119 = icmp ne i32 %118, 0, !dbg !990
  %is_subnormal17 = and i1 %117, %119, !dbg !990
  %120 = xor i1 %is_subnormal17, true, !dbg !990
  %121 = and i1 %114, %120, !dbg !990
  %122 = bitcast float %div to i32, !dbg !990
  %123 = and i32 %122, 2139095040, !dbg !990
  %124 = icmp eq i32 %123, 0, !dbg !990
  %125 = and i32 %122, 8388607, !dbg !990
  %126 = icmp ne i32 %125, 0, !dbg !990
  %is_subnormal18 = and i1 %124, %126, !dbg !990
  %subnormal_cond = and i1 %121, %is_subnormal18, !dbg !990
  br i1 %subnormal_cond, label %127, label %129, !dbg !990

127:                                              ; preds = %107
  %128 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !990
  br label %129, !dbg !990

129:                                              ; preds = %107, %127
  %130 = load ptr, ptr %result.addr, align 8, !dbg !990
  %arrayidx = getelementptr inbounds float, ptr %130, i64 0, !dbg !990
  store float %div, ptr %arrayidx, align 4, !dbg !991
  %131 = load ptr, ptr %result.addr, align 8, !dbg !992
  %arrayidx1 = getelementptr inbounds float, ptr %131, i64 0, !dbg !992
  %132 = load float, ptr %arrayidx1, align 4, !dbg !992
  store float %132, ptr %__x.addr.i91, align 4
    #dbg_declare(ptr %__x.addr.i91, !993, !DIExpression(), !994)
  %133 = load float, ptr %__x.addr.i91, align 4, !dbg !996
  store float %133, ptr %__a.addr.i, align 4
    #dbg_declare(ptr %__a.addr.i, !997, !DIExpression(), !1000)
  %134 = load float, ptr %__a.addr.i, align 4, !dbg !1002
  %135 = bitcast float %134 to i32, !dbg !1003
  %136 = lshr i32 %135, 31, !dbg !1003
  %tobool.i93 = icmp ne i32 %136, 0, !dbg !1004
  %137 = zext i1 %tobool.i93 to i64, !dbg !1005
  %cond = select i1 %tobool.i93, i32 -1, i32 1, !dbg !1005
  %138 = load ptr, ptr %sign_check.addr, align 8, !dbg !1006
  %arrayidx3 = getelementptr inbounds i32, ptr %138, i64 0, !dbg !1006
  store i32 %cond, ptr %arrayidx3, align 4, !dbg !1007
  br label %if.end, !dbg !1008

if.end:                                           ; preds = %129, %entry
  %139 = load i32, ptr %idx, align 4, !dbg !1009
  %cmp4 = icmp eq i32 %139, 1, !dbg !1011
  br i1 %cmp4, label %if.then5, label %if.end12, !dbg !1011

if.then5:                                         ; preds = %if.end
  %140 = load float, ptr %pos_num.addr, align 4, !dbg !1012
  %141 = load float, ptr %neg_zero.addr, align 4, !dbg !1014
  %142 = bitcast float %140 to i32, !dbg !1015
  %143 = bitcast float %140 to i32, !dbg !1015
  %144 = and i32 %143, 2139095040, !dbg !1015
  %145 = icmp eq i32 %144, 2139095040, !dbg !1015
  %146 = and i32 %143, 8388607, !dbg !1015
  %147 = icmp ne i32 %146, 0, !dbg !1015
  %is_nan19 = and i1 %145, %147, !dbg !1015
  %148 = and i32 %142, 4194304, !dbg !1015
  %149 = icmp eq i32 %148, 0, !dbg !1015
  %is_snan20 = and i1 %is_nan19, %149, !dbg !1015
  %150 = bitcast float %141 to i32, !dbg !1015
  %151 = bitcast float %141 to i32, !dbg !1015
  %152 = and i32 %151, 2139095040, !dbg !1015
  %153 = icmp eq i32 %152, 2139095040, !dbg !1015
  %154 = and i32 %151, 8388607, !dbg !1015
  %155 = icmp ne i32 %154, 0, !dbg !1015
  %is_nan21 = and i1 %153, %155, !dbg !1015
  %156 = and i32 %150, 4194304, !dbg !1015
  %157 = icmp eq i32 %156, 0, !dbg !1015
  %is_snan22 = and i1 %is_nan21, %157, !dbg !1015
  %158 = or i1 %is_snan20, %is_snan22, !dbg !1015
  %159 = bitcast float %140 to i32, !dbg !1015
  %160 = and i32 %159, 2147483647, !dbg !1015
  %is_zero23 = icmp eq i32 %160, 0, !dbg !1015
  %161 = bitcast float %141 to i32, !dbg !1015
  %162 = and i32 %161, 2147483647, !dbg !1015
  %is_zero24 = icmp eq i32 %162, 0, !dbg !1015
  %163 = and i1 %is_zero23, %is_zero24, !dbg !1015
  %164 = bitcast float %140 to i32, !dbg !1015
  %165 = and i32 %164, 2139095040, !dbg !1015
  %166 = icmp eq i32 %165, 2139095040, !dbg !1015
  %167 = and i32 %164, 8388607, !dbg !1015
  %168 = icmp eq i32 %167, 0, !dbg !1015
  %is_inf25 = and i1 %166, %168, !dbg !1015
  %169 = bitcast float %141 to i32, !dbg !1015
  %170 = and i32 %169, 2139095040, !dbg !1015
  %171 = icmp eq i32 %170, 2139095040, !dbg !1015
  %172 = and i32 %169, 8388607, !dbg !1015
  %173 = icmp eq i32 %172, 0, !dbg !1015
  %is_inf26 = and i1 %171, %173, !dbg !1015
  %174 = and i1 %is_inf25, %is_inf26, !dbg !1015
  %175 = or i1 %163, %174, !dbg !1015
  %176 = or i1 %158, %175, !dbg !1015
  br i1 %176, label %177, label %179, !dbg !1015

177:                                              ; preds = %if.then5
  %178 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1015
  br label %179, !dbg !1015

179:                                              ; preds = %if.then5, %177
  %180 = bitcast float %141 to i32, !dbg !1015
  %181 = and i32 %180, 2147483647, !dbg !1015
  %is_zero27 = icmp eq i32 %181, 0, !dbg !1015
  %182 = bitcast float %140 to i32, !dbg !1015
  %183 = and i32 %182, 2139095040, !dbg !1015
  %is_finite28 = icmp ne i32 %183, 2139095040, !dbg !1015
  %184 = bitcast float %140 to i32, !dbg !1015
  %185 = and i32 %184, 2147483647, !dbg !1015
  %is_zero29 = icmp eq i32 %185, 0, !dbg !1015
  %186 = xor i1 %is_zero29, true, !dbg !1015
  %187 = and i1 %is_finite28, %186, !dbg !1015
  %divzero_cond30 = and i1 %is_zero27, %187, !dbg !1015
  br i1 %divzero_cond30, label %188, label %190, !dbg !1015

188:                                              ; preds = %179
  %189 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 1), i64 1 monotonic, align 8, !dbg !1015
  br label %190, !dbg !1015

190:                                              ; preds = %179, %188
  %div6 = fdiv contract float %140, %141, !dbg !1015
  %191 = bitcast float %140 to i32, !dbg !1016
  %192 = and i32 %191, 2139095040, !dbg !1016
  %is_finite31 = icmp ne i32 %192, 2139095040, !dbg !1016
  %193 = and i1 true, %is_finite31, !dbg !1016
  %194 = bitcast float %141 to i32, !dbg !1016
  %195 = and i32 %194, 2139095040, !dbg !1016
  %is_finite32 = icmp ne i32 %195, 2139095040, !dbg !1016
  %196 = and i1 %193, %is_finite32, !dbg !1016
  %197 = bitcast float %141 to i32, !dbg !1016
  %198 = and i32 %197, 2147483647, !dbg !1016
  %is_zero33 = icmp eq i32 %198, 0, !dbg !1016
  %199 = xor i1 %is_zero33, true, !dbg !1016
  %overflow_denom_nonzero34 = and i1 %196, %199, !dbg !1016
  %200 = bitcast float %div6 to i32, !dbg !1016
  %201 = and i32 %200, 2139095040, !dbg !1016
  %202 = icmp eq i32 %201, 2139095040, !dbg !1016
  %203 = and i32 %200, 8388607, !dbg !1016
  %204 = icmp eq i32 %203, 0, !dbg !1016
  %is_inf35 = and i1 %202, %204, !dbg !1016
  %205 = bitcast float %div6 to i32, !dbg !1016
  %206 = and i32 %205, 2147483647, !dbg !1016
  %is_maxfinite36 = icmp eq i32 %206, 2139095039, !dbg !1016
  %207 = bitcast float %div6 to i32, !dbg !1016
  %208 = and i32 %207, -2147483648, !dbg !1016
  %209 = icmp eq i32 %208, 0, !dbg !1016
  %210 = icmp ne i32 %208, 0, !dbg !1016
  %is_pos_inf37 = and i1 %is_inf35, %209, !dbg !1016
  %is_neg_inf38 = and i1 %is_inf35, %210, !dbg !1016
  %is_pos_max39 = and i1 %is_maxfinite36, %209, !dbg !1016
  %is_neg_max40 = and i1 %is_maxfinite36, %210, !dbg !1016
  %overflow_cond41 = and i1 %overflow_denom_nonzero34, %is_inf35, !dbg !1016
  br i1 %overflow_cond41, label %211, label %213, !dbg !1016

211:                                              ; preds = %190
  %212 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1016
  br label %213, !dbg !1016

213:                                              ; preds = %190, %211
  %214 = bitcast float %140 to i32, !dbg !1016
  %215 = and i32 %214, 2139095040, !dbg !1016
  %216 = icmp eq i32 %215, 0, !dbg !1016
  %217 = and i32 %214, 8388607, !dbg !1016
  %218 = icmp ne i32 %217, 0, !dbg !1016
  %is_subnormal42 = and i1 %216, %218, !dbg !1016
  %219 = xor i1 %is_subnormal42, true, !dbg !1016
  %220 = and i1 true, %219, !dbg !1016
  %221 = bitcast float %141 to i32, !dbg !1016
  %222 = and i32 %221, 2139095040, !dbg !1016
  %223 = icmp eq i32 %222, 0, !dbg !1016
  %224 = and i32 %221, 8388607, !dbg !1016
  %225 = icmp ne i32 %224, 0, !dbg !1016
  %is_subnormal43 = and i1 %223, %225, !dbg !1016
  %226 = xor i1 %is_subnormal43, true, !dbg !1016
  %227 = and i1 %220, %226, !dbg !1016
  %228 = bitcast float %div6 to i32, !dbg !1016
  %229 = and i32 %228, 2139095040, !dbg !1016
  %230 = icmp eq i32 %229, 0, !dbg !1016
  %231 = and i32 %228, 8388607, !dbg !1016
  %232 = icmp ne i32 %231, 0, !dbg !1016
  %is_subnormal44 = and i1 %230, %232, !dbg !1016
  %233 = bitcast float %div6 to i32, !dbg !1016
  %234 = and i32 %233, 2147483647, !dbg !1016
  %is_zero45 = icmp eq i32 %234, 0, !dbg !1016
  %235 = bitcast float %140 to i32, !dbg !1016
  %236 = and i32 %235, 2147483647, !dbg !1016
  %is_zero46 = icmp eq i32 %236, 0, !dbg !1016
  %237 = xor i1 %is_zero46, true, !dbg !1016
  %238 = bitcast float %141 to i32, !dbg !1016
  %239 = and i32 %238, 2147483647, !dbg !1016
  %is_zero47 = icmp eq i32 %239, 0, !dbg !1016
  %240 = xor i1 %is_zero47, true, !dbg !1016
  %241 = and i1 %237, %240, !dbg !1016
  %242 = and i1 %is_zero45, %241, !dbg !1016
  %is_tiny48 = or i1 %is_subnormal44, %242, !dbg !1016
  %underflow_cond49 = and i1 %227, %is_tiny48, !dbg !1016
  br i1 %underflow_cond49, label %243, label %245, !dbg !1016

243:                                              ; preds = %213
  %244 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1016
  br label %245, !dbg !1016

245:                                              ; preds = %213, %243
  %246 = bitcast float %140 to i32, !dbg !1016
  %247 = and i32 %246, 2139095040, !dbg !1016
  %248 = icmp eq i32 %247, 0, !dbg !1016
  %249 = and i32 %246, 8388607, !dbg !1016
  %250 = icmp ne i32 %249, 0, !dbg !1016
  %is_subnormal50 = and i1 %248, %250, !dbg !1016
  %251 = xor i1 %is_subnormal50, true, !dbg !1016
  %252 = and i1 true, %251, !dbg !1016
  %253 = bitcast float %141 to i32, !dbg !1016
  %254 = and i32 %253, 2139095040, !dbg !1016
  %255 = icmp eq i32 %254, 0, !dbg !1016
  %256 = and i32 %253, 8388607, !dbg !1016
  %257 = icmp ne i32 %256, 0, !dbg !1016
  %is_subnormal51 = and i1 %255, %257, !dbg !1016
  %258 = xor i1 %is_subnormal51, true, !dbg !1016
  %259 = and i1 %252, %258, !dbg !1016
  %260 = bitcast float %div6 to i32, !dbg !1016
  %261 = and i32 %260, 2139095040, !dbg !1016
  %262 = icmp eq i32 %261, 0, !dbg !1016
  %263 = and i32 %260, 8388607, !dbg !1016
  %264 = icmp ne i32 %263, 0, !dbg !1016
  %is_subnormal52 = and i1 %262, %264, !dbg !1016
  %subnormal_cond53 = and i1 %259, %is_subnormal52, !dbg !1016
  br i1 %subnormal_cond53, label %265, label %267, !dbg !1016

265:                                              ; preds = %245
  %266 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1016
  br label %267, !dbg !1016

267:                                              ; preds = %245, %265
  %268 = load ptr, ptr %result.addr, align 8, !dbg !1016
  %arrayidx7 = getelementptr inbounds float, ptr %268, i64 1, !dbg !1016
  store float %div6, ptr %arrayidx7, align 4, !dbg !1017
  %269 = load ptr, ptr %result.addr, align 8, !dbg !1018
  %arrayidx8 = getelementptr inbounds float, ptr %269, i64 1, !dbg !1018
  %270 = load float, ptr %arrayidx8, align 4, !dbg !1018
  store float %270, ptr %__x.addr.i88, align 4
    #dbg_declare(ptr %__x.addr.i88, !993, !DIExpression(), !1019)
  %271 = load float, ptr %__x.addr.i88, align 4, !dbg !1021
  store float %271, ptr %__a.addr.i95, align 4
    #dbg_declare(ptr %__a.addr.i95, !997, !DIExpression(), !1022)
  %272 = load float, ptr %__a.addr.i95, align 4, !dbg !1024
  %273 = bitcast float %272 to i32, !dbg !1025
  %274 = lshr i32 %273, 31, !dbg !1025
  %tobool.i90 = icmp ne i32 %274, 0, !dbg !1026
  %275 = zext i1 %tobool.i90 to i64, !dbg !1027
  %cond10 = select i1 %tobool.i90, i32 -1, i32 1, !dbg !1027
  %276 = load ptr, ptr %sign_check.addr, align 8, !dbg !1028
  %arrayidx11 = getelementptr inbounds i32, ptr %276, i64 1, !dbg !1028
  store i32 %cond10, ptr %arrayidx11, align 4, !dbg !1029
  br label %if.end12, !dbg !1030

if.end12:                                         ; preds = %267, %if.end
  %277 = load i32, ptr %idx, align 4, !dbg !1031
  %cmp13 = icmp eq i32 %277, 2, !dbg !1033
  br i1 %cmp13, label %if.then14, label %if.end21, !dbg !1033

if.then14:                                        ; preds = %if.end12
  %278 = load float, ptr %neg_num.addr, align 4, !dbg !1034
  %279 = load float, ptr %pos_zero.addr, align 4, !dbg !1036
  %280 = bitcast float %278 to i32, !dbg !1037
  %281 = bitcast float %278 to i32, !dbg !1037
  %282 = and i32 %281, 2139095040, !dbg !1037
  %283 = icmp eq i32 %282, 2139095040, !dbg !1037
  %284 = and i32 %281, 8388607, !dbg !1037
  %285 = icmp ne i32 %284, 0, !dbg !1037
  %is_nan54 = and i1 %283, %285, !dbg !1037
  %286 = and i32 %280, 4194304, !dbg !1037
  %287 = icmp eq i32 %286, 0, !dbg !1037
  %is_snan55 = and i1 %is_nan54, %287, !dbg !1037
  %288 = bitcast float %279 to i32, !dbg !1037
  %289 = bitcast float %279 to i32, !dbg !1037
  %290 = and i32 %289, 2139095040, !dbg !1037
  %291 = icmp eq i32 %290, 2139095040, !dbg !1037
  %292 = and i32 %289, 8388607, !dbg !1037
  %293 = icmp ne i32 %292, 0, !dbg !1037
  %is_nan56 = and i1 %291, %293, !dbg !1037
  %294 = and i32 %288, 4194304, !dbg !1037
  %295 = icmp eq i32 %294, 0, !dbg !1037
  %is_snan57 = and i1 %is_nan56, %295, !dbg !1037
  %296 = or i1 %is_snan55, %is_snan57, !dbg !1037
  %297 = bitcast float %278 to i32, !dbg !1037
  %298 = and i32 %297, 2147483647, !dbg !1037
  %is_zero58 = icmp eq i32 %298, 0, !dbg !1037
  %299 = bitcast float %279 to i32, !dbg !1037
  %300 = and i32 %299, 2147483647, !dbg !1037
  %is_zero59 = icmp eq i32 %300, 0, !dbg !1037
  %301 = and i1 %is_zero58, %is_zero59, !dbg !1037
  %302 = bitcast float %278 to i32, !dbg !1037
  %303 = and i32 %302, 2139095040, !dbg !1037
  %304 = icmp eq i32 %303, 2139095040, !dbg !1037
  %305 = and i32 %302, 8388607, !dbg !1037
  %306 = icmp eq i32 %305, 0, !dbg !1037
  %is_inf60 = and i1 %304, %306, !dbg !1037
  %307 = bitcast float %279 to i32, !dbg !1037
  %308 = and i32 %307, 2139095040, !dbg !1037
  %309 = icmp eq i32 %308, 2139095040, !dbg !1037
  %310 = and i32 %307, 8388607, !dbg !1037
  %311 = icmp eq i32 %310, 0, !dbg !1037
  %is_inf61 = and i1 %309, %311, !dbg !1037
  %312 = and i1 %is_inf60, %is_inf61, !dbg !1037
  %313 = or i1 %301, %312, !dbg !1037
  %314 = or i1 %296, %313, !dbg !1037
  br i1 %314, label %315, label %317, !dbg !1037

315:                                              ; preds = %if.then14
  %316 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1037
  br label %317, !dbg !1037

317:                                              ; preds = %if.then14, %315
  %318 = bitcast float %279 to i32, !dbg !1037
  %319 = and i32 %318, 2147483647, !dbg !1037
  %is_zero62 = icmp eq i32 %319, 0, !dbg !1037
  %320 = bitcast float %278 to i32, !dbg !1037
  %321 = and i32 %320, 2139095040, !dbg !1037
  %is_finite63 = icmp ne i32 %321, 2139095040, !dbg !1037
  %322 = bitcast float %278 to i32, !dbg !1037
  %323 = and i32 %322, 2147483647, !dbg !1037
  %is_zero64 = icmp eq i32 %323, 0, !dbg !1037
  %324 = xor i1 %is_zero64, true, !dbg !1037
  %325 = and i1 %is_finite63, %324, !dbg !1037
  %divzero_cond65 = and i1 %is_zero62, %325, !dbg !1037
  br i1 %divzero_cond65, label %326, label %328, !dbg !1037

326:                                              ; preds = %317
  %327 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 1), i64 1 monotonic, align 8, !dbg !1037
  br label %328, !dbg !1037

328:                                              ; preds = %317, %326
  %div15 = fdiv contract float %278, %279, !dbg !1037
  %329 = bitcast float %278 to i32, !dbg !1038
  %330 = and i32 %329, 2139095040, !dbg !1038
  %is_finite66 = icmp ne i32 %330, 2139095040, !dbg !1038
  %331 = and i1 true, %is_finite66, !dbg !1038
  %332 = bitcast float %279 to i32, !dbg !1038
  %333 = and i32 %332, 2139095040, !dbg !1038
  %is_finite67 = icmp ne i32 %333, 2139095040, !dbg !1038
  %334 = and i1 %331, %is_finite67, !dbg !1038
  %335 = bitcast float %279 to i32, !dbg !1038
  %336 = and i32 %335, 2147483647, !dbg !1038
  %is_zero68 = icmp eq i32 %336, 0, !dbg !1038
  %337 = xor i1 %is_zero68, true, !dbg !1038
  %overflow_denom_nonzero69 = and i1 %334, %337, !dbg !1038
  %338 = bitcast float %div15 to i32, !dbg !1038
  %339 = and i32 %338, 2139095040, !dbg !1038
  %340 = icmp eq i32 %339, 2139095040, !dbg !1038
  %341 = and i32 %338, 8388607, !dbg !1038
  %342 = icmp eq i32 %341, 0, !dbg !1038
  %is_inf70 = and i1 %340, %342, !dbg !1038
  %343 = bitcast float %div15 to i32, !dbg !1038
  %344 = and i32 %343, 2147483647, !dbg !1038
  %is_maxfinite71 = icmp eq i32 %344, 2139095039, !dbg !1038
  %345 = bitcast float %div15 to i32, !dbg !1038
  %346 = and i32 %345, -2147483648, !dbg !1038
  %347 = icmp eq i32 %346, 0, !dbg !1038
  %348 = icmp ne i32 %346, 0, !dbg !1038
  %is_pos_inf72 = and i1 %is_inf70, %347, !dbg !1038
  %is_neg_inf73 = and i1 %is_inf70, %348, !dbg !1038
  %is_pos_max74 = and i1 %is_maxfinite71, %347, !dbg !1038
  %is_neg_max75 = and i1 %is_maxfinite71, %348, !dbg !1038
  %overflow_cond76 = and i1 %overflow_denom_nonzero69, %is_inf70, !dbg !1038
  br i1 %overflow_cond76, label %349, label %351, !dbg !1038

349:                                              ; preds = %328
  %350 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1038
  br label %351, !dbg !1038

351:                                              ; preds = %328, %349
  %352 = bitcast float %278 to i32, !dbg !1038
  %353 = and i32 %352, 2139095040, !dbg !1038
  %354 = icmp eq i32 %353, 0, !dbg !1038
  %355 = and i32 %352, 8388607, !dbg !1038
  %356 = icmp ne i32 %355, 0, !dbg !1038
  %is_subnormal77 = and i1 %354, %356, !dbg !1038
  %357 = xor i1 %is_subnormal77, true, !dbg !1038
  %358 = and i1 true, %357, !dbg !1038
  %359 = bitcast float %279 to i32, !dbg !1038
  %360 = and i32 %359, 2139095040, !dbg !1038
  %361 = icmp eq i32 %360, 0, !dbg !1038
  %362 = and i32 %359, 8388607, !dbg !1038
  %363 = icmp ne i32 %362, 0, !dbg !1038
  %is_subnormal78 = and i1 %361, %363, !dbg !1038
  %364 = xor i1 %is_subnormal78, true, !dbg !1038
  %365 = and i1 %358, %364, !dbg !1038
  %366 = bitcast float %div15 to i32, !dbg !1038
  %367 = and i32 %366, 2139095040, !dbg !1038
  %368 = icmp eq i32 %367, 0, !dbg !1038
  %369 = and i32 %366, 8388607, !dbg !1038
  %370 = icmp ne i32 %369, 0, !dbg !1038
  %is_subnormal79 = and i1 %368, %370, !dbg !1038
  %371 = bitcast float %div15 to i32, !dbg !1038
  %372 = and i32 %371, 2147483647, !dbg !1038
  %is_zero80 = icmp eq i32 %372, 0, !dbg !1038
  %373 = bitcast float %278 to i32, !dbg !1038
  %374 = and i32 %373, 2147483647, !dbg !1038
  %is_zero81 = icmp eq i32 %374, 0, !dbg !1038
  %375 = xor i1 %is_zero81, true, !dbg !1038
  %376 = bitcast float %279 to i32, !dbg !1038
  %377 = and i32 %376, 2147483647, !dbg !1038
  %is_zero82 = icmp eq i32 %377, 0, !dbg !1038
  %378 = xor i1 %is_zero82, true, !dbg !1038
  %379 = and i1 %375, %378, !dbg !1038
  %380 = and i1 %is_zero80, %379, !dbg !1038
  %is_tiny83 = or i1 %is_subnormal79, %380, !dbg !1038
  %underflow_cond84 = and i1 %365, %is_tiny83, !dbg !1038
  br i1 %underflow_cond84, label %381, label %383, !dbg !1038

381:                                              ; preds = %351
  %382 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1038
  br label %383, !dbg !1038

383:                                              ; preds = %351, %381
  %384 = bitcast float %278 to i32, !dbg !1038
  %385 = and i32 %384, 2139095040, !dbg !1038
  %386 = icmp eq i32 %385, 0, !dbg !1038
  %387 = and i32 %384, 8388607, !dbg !1038
  %388 = icmp ne i32 %387, 0, !dbg !1038
  %is_subnormal85 = and i1 %386, %388, !dbg !1038
  %389 = xor i1 %is_subnormal85, true, !dbg !1038
  %390 = and i1 true, %389, !dbg !1038
  %391 = bitcast float %279 to i32, !dbg !1038
  %392 = and i32 %391, 2139095040, !dbg !1038
  %393 = icmp eq i32 %392, 0, !dbg !1038
  %394 = and i32 %391, 8388607, !dbg !1038
  %395 = icmp ne i32 %394, 0, !dbg !1038
  %is_subnormal86 = and i1 %393, %395, !dbg !1038
  %396 = xor i1 %is_subnormal86, true, !dbg !1038
  %397 = and i1 %390, %396, !dbg !1038
  %398 = bitcast float %div15 to i32, !dbg !1038
  %399 = and i32 %398, 2139095040, !dbg !1038
  %400 = icmp eq i32 %399, 0, !dbg !1038
  %401 = and i32 %398, 8388607, !dbg !1038
  %402 = icmp ne i32 %401, 0, !dbg !1038
  %is_subnormal87 = and i1 %400, %402, !dbg !1038
  %subnormal_cond88 = and i1 %397, %is_subnormal87, !dbg !1038
  br i1 %subnormal_cond88, label %403, label %405, !dbg !1038

403:                                              ; preds = %383
  %404 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1038
  br label %405, !dbg !1038

405:                                              ; preds = %383, %403
  %406 = load ptr, ptr %result.addr, align 8, !dbg !1038
  %arrayidx16 = getelementptr inbounds float, ptr %406, i64 2, !dbg !1038
  store float %div15, ptr %arrayidx16, align 4, !dbg !1039
  %407 = load ptr, ptr %result.addr, align 8, !dbg !1040
  %arrayidx17 = getelementptr inbounds float, ptr %407, i64 2, !dbg !1040
  %408 = load float, ptr %arrayidx17, align 4, !dbg !1040
  store float %408, ptr %__x.addr.i85, align 4
    #dbg_declare(ptr %__x.addr.i85, !993, !DIExpression(), !1041)
  %409 = load float, ptr %__x.addr.i85, align 4, !dbg !1043
  store float %409, ptr %__a.addr.i97, align 4
    #dbg_declare(ptr %__a.addr.i97, !997, !DIExpression(), !1044)
  %410 = load float, ptr %__a.addr.i97, align 4, !dbg !1046
  %411 = bitcast float %410 to i32, !dbg !1047
  %412 = lshr i32 %411, 31, !dbg !1047
  %tobool.i87 = icmp ne i32 %412, 0, !dbg !1048
  %413 = zext i1 %tobool.i87 to i64, !dbg !1049
  %cond19 = select i1 %tobool.i87, i32 -1, i32 1, !dbg !1049
  %414 = load ptr, ptr %sign_check.addr, align 8, !dbg !1050
  %arrayidx20 = getelementptr inbounds i32, ptr %414, i64 2, !dbg !1050
  store i32 %cond19, ptr %arrayidx20, align 4, !dbg !1051
  br label %if.end21, !dbg !1052

if.end21:                                         ; preds = %405, %if.end12
  %415 = load i32, ptr %idx, align 4, !dbg !1053
  %cmp22 = icmp eq i32 %415, 3, !dbg !1055
  br i1 %cmp22, label %if.then23, label %if.end30, !dbg !1055

if.then23:                                        ; preds = %if.end21
  %416 = load float, ptr %neg_num.addr, align 4, !dbg !1056
  %417 = load float, ptr %neg_zero.addr, align 4, !dbg !1058
  %418 = bitcast float %416 to i32, !dbg !1059
  %419 = bitcast float %416 to i32, !dbg !1059
  %420 = and i32 %419, 2139095040, !dbg !1059
  %421 = icmp eq i32 %420, 2139095040, !dbg !1059
  %422 = and i32 %419, 8388607, !dbg !1059
  %423 = icmp ne i32 %422, 0, !dbg !1059
  %is_nan89 = and i1 %421, %423, !dbg !1059
  %424 = and i32 %418, 4194304, !dbg !1059
  %425 = icmp eq i32 %424, 0, !dbg !1059
  %is_snan90 = and i1 %is_nan89, %425, !dbg !1059
  %426 = bitcast float %417 to i32, !dbg !1059
  %427 = bitcast float %417 to i32, !dbg !1059
  %428 = and i32 %427, 2139095040, !dbg !1059
  %429 = icmp eq i32 %428, 2139095040, !dbg !1059
  %430 = and i32 %427, 8388607, !dbg !1059
  %431 = icmp ne i32 %430, 0, !dbg !1059
  %is_nan91 = and i1 %429, %431, !dbg !1059
  %432 = and i32 %426, 4194304, !dbg !1059
  %433 = icmp eq i32 %432, 0, !dbg !1059
  %is_snan92 = and i1 %is_nan91, %433, !dbg !1059
  %434 = or i1 %is_snan90, %is_snan92, !dbg !1059
  %435 = bitcast float %416 to i32, !dbg !1059
  %436 = and i32 %435, 2147483647, !dbg !1059
  %is_zero93 = icmp eq i32 %436, 0, !dbg !1059
  %437 = bitcast float %417 to i32, !dbg !1059
  %438 = and i32 %437, 2147483647, !dbg !1059
  %is_zero94 = icmp eq i32 %438, 0, !dbg !1059
  %439 = and i1 %is_zero93, %is_zero94, !dbg !1059
  %440 = bitcast float %416 to i32, !dbg !1059
  %441 = and i32 %440, 2139095040, !dbg !1059
  %442 = icmp eq i32 %441, 2139095040, !dbg !1059
  %443 = and i32 %440, 8388607, !dbg !1059
  %444 = icmp eq i32 %443, 0, !dbg !1059
  %is_inf95 = and i1 %442, %444, !dbg !1059
  %445 = bitcast float %417 to i32, !dbg !1059
  %446 = and i32 %445, 2139095040, !dbg !1059
  %447 = icmp eq i32 %446, 2139095040, !dbg !1059
  %448 = and i32 %445, 8388607, !dbg !1059
  %449 = icmp eq i32 %448, 0, !dbg !1059
  %is_inf96 = and i1 %447, %449, !dbg !1059
  %450 = and i1 %is_inf95, %is_inf96, !dbg !1059
  %451 = or i1 %439, %450, !dbg !1059
  %452 = or i1 %434, %451, !dbg !1059
  br i1 %452, label %453, label %455, !dbg !1059

453:                                              ; preds = %if.then23
  %454 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1059
  br label %455, !dbg !1059

455:                                              ; preds = %if.then23, %453
  %456 = bitcast float %417 to i32, !dbg !1059
  %457 = and i32 %456, 2147483647, !dbg !1059
  %is_zero97 = icmp eq i32 %457, 0, !dbg !1059
  %458 = bitcast float %416 to i32, !dbg !1059
  %459 = and i32 %458, 2139095040, !dbg !1059
  %is_finite98 = icmp ne i32 %459, 2139095040, !dbg !1059
  %460 = bitcast float %416 to i32, !dbg !1059
  %461 = and i32 %460, 2147483647, !dbg !1059
  %is_zero99 = icmp eq i32 %461, 0, !dbg !1059
  %462 = xor i1 %is_zero99, true, !dbg !1059
  %463 = and i1 %is_finite98, %462, !dbg !1059
  %divzero_cond100 = and i1 %is_zero97, %463, !dbg !1059
  br i1 %divzero_cond100, label %464, label %466, !dbg !1059

464:                                              ; preds = %455
  %465 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 1), i64 1 monotonic, align 8, !dbg !1059
  br label %466, !dbg !1059

466:                                              ; preds = %455, %464
  %div24 = fdiv contract float %416, %417, !dbg !1059
  %467 = bitcast float %416 to i32, !dbg !1060
  %468 = and i32 %467, 2139095040, !dbg !1060
  %is_finite101 = icmp ne i32 %468, 2139095040, !dbg !1060
  %469 = and i1 true, %is_finite101, !dbg !1060
  %470 = bitcast float %417 to i32, !dbg !1060
  %471 = and i32 %470, 2139095040, !dbg !1060
  %is_finite102 = icmp ne i32 %471, 2139095040, !dbg !1060
  %472 = and i1 %469, %is_finite102, !dbg !1060
  %473 = bitcast float %417 to i32, !dbg !1060
  %474 = and i32 %473, 2147483647, !dbg !1060
  %is_zero103 = icmp eq i32 %474, 0, !dbg !1060
  %475 = xor i1 %is_zero103, true, !dbg !1060
  %overflow_denom_nonzero104 = and i1 %472, %475, !dbg !1060
  %476 = bitcast float %div24 to i32, !dbg !1060
  %477 = and i32 %476, 2139095040, !dbg !1060
  %478 = icmp eq i32 %477, 2139095040, !dbg !1060
  %479 = and i32 %476, 8388607, !dbg !1060
  %480 = icmp eq i32 %479, 0, !dbg !1060
  %is_inf105 = and i1 %478, %480, !dbg !1060
  %481 = bitcast float %div24 to i32, !dbg !1060
  %482 = and i32 %481, 2147483647, !dbg !1060
  %is_maxfinite106 = icmp eq i32 %482, 2139095039, !dbg !1060
  %483 = bitcast float %div24 to i32, !dbg !1060
  %484 = and i32 %483, -2147483648, !dbg !1060
  %485 = icmp eq i32 %484, 0, !dbg !1060
  %486 = icmp ne i32 %484, 0, !dbg !1060
  %is_pos_inf107 = and i1 %is_inf105, %485, !dbg !1060
  %is_neg_inf108 = and i1 %is_inf105, %486, !dbg !1060
  %is_pos_max109 = and i1 %is_maxfinite106, %485, !dbg !1060
  %is_neg_max110 = and i1 %is_maxfinite106, %486, !dbg !1060
  %overflow_cond111 = and i1 %overflow_denom_nonzero104, %is_inf105, !dbg !1060
  br i1 %overflow_cond111, label %487, label %489, !dbg !1060

487:                                              ; preds = %466
  %488 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1060
  br label %489, !dbg !1060

489:                                              ; preds = %466, %487
  %490 = bitcast float %416 to i32, !dbg !1060
  %491 = and i32 %490, 2139095040, !dbg !1060
  %492 = icmp eq i32 %491, 0, !dbg !1060
  %493 = and i32 %490, 8388607, !dbg !1060
  %494 = icmp ne i32 %493, 0, !dbg !1060
  %is_subnormal112 = and i1 %492, %494, !dbg !1060
  %495 = xor i1 %is_subnormal112, true, !dbg !1060
  %496 = and i1 true, %495, !dbg !1060
  %497 = bitcast float %417 to i32, !dbg !1060
  %498 = and i32 %497, 2139095040, !dbg !1060
  %499 = icmp eq i32 %498, 0, !dbg !1060
  %500 = and i32 %497, 8388607, !dbg !1060
  %501 = icmp ne i32 %500, 0, !dbg !1060
  %is_subnormal113 = and i1 %499, %501, !dbg !1060
  %502 = xor i1 %is_subnormal113, true, !dbg !1060
  %503 = and i1 %496, %502, !dbg !1060
  %504 = bitcast float %div24 to i32, !dbg !1060
  %505 = and i32 %504, 2139095040, !dbg !1060
  %506 = icmp eq i32 %505, 0, !dbg !1060
  %507 = and i32 %504, 8388607, !dbg !1060
  %508 = icmp ne i32 %507, 0, !dbg !1060
  %is_subnormal114 = and i1 %506, %508, !dbg !1060
  %509 = bitcast float %div24 to i32, !dbg !1060
  %510 = and i32 %509, 2147483647, !dbg !1060
  %is_zero115 = icmp eq i32 %510, 0, !dbg !1060
  %511 = bitcast float %416 to i32, !dbg !1060
  %512 = and i32 %511, 2147483647, !dbg !1060
  %is_zero116 = icmp eq i32 %512, 0, !dbg !1060
  %513 = xor i1 %is_zero116, true, !dbg !1060
  %514 = bitcast float %417 to i32, !dbg !1060
  %515 = and i32 %514, 2147483647, !dbg !1060
  %is_zero117 = icmp eq i32 %515, 0, !dbg !1060
  %516 = xor i1 %is_zero117, true, !dbg !1060
  %517 = and i1 %513, %516, !dbg !1060
  %518 = and i1 %is_zero115, %517, !dbg !1060
  %is_tiny118 = or i1 %is_subnormal114, %518, !dbg !1060
  %underflow_cond119 = and i1 %503, %is_tiny118, !dbg !1060
  br i1 %underflow_cond119, label %519, label %521, !dbg !1060

519:                                              ; preds = %489
  %520 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1060
  br label %521, !dbg !1060

521:                                              ; preds = %489, %519
  %522 = bitcast float %416 to i32, !dbg !1060
  %523 = and i32 %522, 2139095040, !dbg !1060
  %524 = icmp eq i32 %523, 0, !dbg !1060
  %525 = and i32 %522, 8388607, !dbg !1060
  %526 = icmp ne i32 %525, 0, !dbg !1060
  %is_subnormal120 = and i1 %524, %526, !dbg !1060
  %527 = xor i1 %is_subnormal120, true, !dbg !1060
  %528 = and i1 true, %527, !dbg !1060
  %529 = bitcast float %417 to i32, !dbg !1060
  %530 = and i32 %529, 2139095040, !dbg !1060
  %531 = icmp eq i32 %530, 0, !dbg !1060
  %532 = and i32 %529, 8388607, !dbg !1060
  %533 = icmp ne i32 %532, 0, !dbg !1060
  %is_subnormal121 = and i1 %531, %533, !dbg !1060
  %534 = xor i1 %is_subnormal121, true, !dbg !1060
  %535 = and i1 %528, %534, !dbg !1060
  %536 = bitcast float %div24 to i32, !dbg !1060
  %537 = and i32 %536, 2139095040, !dbg !1060
  %538 = icmp eq i32 %537, 0, !dbg !1060
  %539 = and i32 %536, 8388607, !dbg !1060
  %540 = icmp ne i32 %539, 0, !dbg !1060
  %is_subnormal122 = and i1 %538, %540, !dbg !1060
  %subnormal_cond123 = and i1 %535, %is_subnormal122, !dbg !1060
  br i1 %subnormal_cond123, label %541, label %543, !dbg !1060

541:                                              ; preds = %521
  %542 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1060
  br label %543, !dbg !1060

543:                                              ; preds = %521, %541
  %544 = load ptr, ptr %result.addr, align 8, !dbg !1060
  %arrayidx25 = getelementptr inbounds float, ptr %544, i64 3, !dbg !1060
  store float %div24, ptr %arrayidx25, align 4, !dbg !1061
  %545 = load ptr, ptr %result.addr, align 8, !dbg !1062
  %arrayidx26 = getelementptr inbounds float, ptr %545, i64 3, !dbg !1062
  %546 = load float, ptr %arrayidx26, align 4, !dbg !1062
  store float %546, ptr %__x.addr.i82, align 4
    #dbg_declare(ptr %__x.addr.i82, !993, !DIExpression(), !1063)
  %547 = load float, ptr %__x.addr.i82, align 4, !dbg !1065
  store float %547, ptr %__a.addr.i99, align 4
    #dbg_declare(ptr %__a.addr.i99, !997, !DIExpression(), !1066)
  %548 = load float, ptr %__a.addr.i99, align 4, !dbg !1068
  %549 = bitcast float %548 to i32, !dbg !1069
  %550 = lshr i32 %549, 31, !dbg !1069
  %tobool.i84 = icmp ne i32 %550, 0, !dbg !1070
  %551 = zext i1 %tobool.i84 to i64, !dbg !1071
  %cond28 = select i1 %tobool.i84, i32 -1, i32 1, !dbg !1071
  %552 = load ptr, ptr %sign_check.addr, align 8, !dbg !1072
  %arrayidx29 = getelementptr inbounds i32, ptr %552, i64 3, !dbg !1072
  store i32 %cond28, ptr %arrayidx29, align 4, !dbg !1073
  br label %if.end30, !dbg !1074

if.end30:                                         ; preds = %543, %if.end21
  %553 = load i32, ptr %idx, align 4, !dbg !1075
  %cmp31 = icmp eq i32 %553, 4, !dbg !1077
  br i1 %cmp31, label %if.then32, label %if.end39, !dbg !1077

if.then32:                                        ; preds = %if.end30
  %554 = load float, ptr %pos_zero.addr, align 4, !dbg !1078
  %555 = bitcast float %554 to i32, !dbg !1080
  %556 = bitcast float %554 to i32, !dbg !1080
  %557 = and i32 %556, 2139095040, !dbg !1080
  %558 = icmp eq i32 %557, 2139095040, !dbg !1080
  %559 = and i32 %556, 8388607, !dbg !1080
  %560 = icmp ne i32 %559, 0, !dbg !1080
  %is_nan124 = and i1 %558, %560, !dbg !1080
  %561 = and i32 %555, 4194304, !dbg !1080
  %562 = icmp eq i32 %561, 0, !dbg !1080
  %is_snan125 = and i1 %is_nan124, %562, !dbg !1080
  %563 = or i1 false, %is_snan125, !dbg !1080
  %564 = bitcast float %554 to i32, !dbg !1080
  %565 = and i32 %564, 2147483647, !dbg !1080
  %is_zero126 = icmp eq i32 %565, 0, !dbg !1080
  %566 = and i1 false, %is_zero126, !dbg !1080
  %567 = bitcast float %554 to i32, !dbg !1080
  %568 = and i32 %567, 2139095040, !dbg !1080
  %569 = icmp eq i32 %568, 2139095040, !dbg !1080
  %570 = and i32 %567, 8388607, !dbg !1080
  %571 = icmp eq i32 %570, 0, !dbg !1080
  %is_inf127 = and i1 %569, %571, !dbg !1080
  %572 = and i1 false, %is_inf127, !dbg !1080
  %573 = or i1 %566, %572, !dbg !1080
  %574 = or i1 %563, %573, !dbg !1080
  br i1 %574, label %575, label %577, !dbg !1080

575:                                              ; preds = %if.then32
  %576 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1080
  br label %577, !dbg !1080

577:                                              ; preds = %if.then32, %575
  %578 = bitcast float %554 to i32, !dbg !1080
  %579 = and i32 %578, 2147483647, !dbg !1080
  %is_zero128 = icmp eq i32 %579, 0, !dbg !1080
  %divzero_cond129 = and i1 %is_zero128, true, !dbg !1080
  br i1 %divzero_cond129, label %580, label %582, !dbg !1080

580:                                              ; preds = %577
  %581 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 1), i64 1 monotonic, align 8, !dbg !1080
  br label %582, !dbg !1080

582:                                              ; preds = %577, %580
  %div33 = fdiv contract float 1.000000e+00, %554, !dbg !1080
  %583 = bitcast float %554 to i32, !dbg !1081
  %584 = and i32 %583, 2139095040, !dbg !1081
  %is_finite130 = icmp ne i32 %584, 2139095040, !dbg !1081
  %585 = and i1 true, %is_finite130, !dbg !1081
  %586 = bitcast float %554 to i32, !dbg !1081
  %587 = and i32 %586, 2147483647, !dbg !1081
  %is_zero131 = icmp eq i32 %587, 0, !dbg !1081
  %588 = xor i1 %is_zero131, true, !dbg !1081
  %overflow_denom_nonzero132 = and i1 %585, %588, !dbg !1081
  %589 = bitcast float %div33 to i32, !dbg !1081
  %590 = and i32 %589, 2139095040, !dbg !1081
  %591 = icmp eq i32 %590, 2139095040, !dbg !1081
  %592 = and i32 %589, 8388607, !dbg !1081
  %593 = icmp eq i32 %592, 0, !dbg !1081
  %is_inf133 = and i1 %591, %593, !dbg !1081
  %594 = bitcast float %div33 to i32, !dbg !1081
  %595 = and i32 %594, 2147483647, !dbg !1081
  %is_maxfinite134 = icmp eq i32 %595, 2139095039, !dbg !1081
  %596 = bitcast float %div33 to i32, !dbg !1081
  %597 = and i32 %596, -2147483648, !dbg !1081
  %598 = icmp eq i32 %597, 0, !dbg !1081
  %599 = icmp ne i32 %597, 0, !dbg !1081
  %is_pos_inf135 = and i1 %is_inf133, %598, !dbg !1081
  %is_neg_inf136 = and i1 %is_inf133, %599, !dbg !1081
  %is_pos_max137 = and i1 %is_maxfinite134, %598, !dbg !1081
  %is_neg_max138 = and i1 %is_maxfinite134, %599, !dbg !1081
  %overflow_cond139 = and i1 %overflow_denom_nonzero132, %is_inf133, !dbg !1081
  br i1 %overflow_cond139, label %600, label %602, !dbg !1081

600:                                              ; preds = %582
  %601 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1081
  br label %602, !dbg !1081

602:                                              ; preds = %582, %600
  %603 = bitcast float %554 to i32, !dbg !1081
  %604 = and i32 %603, 2139095040, !dbg !1081
  %605 = icmp eq i32 %604, 0, !dbg !1081
  %606 = and i32 %603, 8388607, !dbg !1081
  %607 = icmp ne i32 %606, 0, !dbg !1081
  %is_subnormal140 = and i1 %605, %607, !dbg !1081
  %608 = xor i1 %is_subnormal140, true, !dbg !1081
  %609 = and i1 true, %608, !dbg !1081
  %610 = bitcast float %div33 to i32, !dbg !1081
  %611 = and i32 %610, 2139095040, !dbg !1081
  %612 = icmp eq i32 %611, 0, !dbg !1081
  %613 = and i32 %610, 8388607, !dbg !1081
  %614 = icmp ne i32 %613, 0, !dbg !1081
  %is_subnormal141 = and i1 %612, %614, !dbg !1081
  %615 = bitcast float %div33 to i32, !dbg !1081
  %616 = and i32 %615, 2147483647, !dbg !1081
  %is_zero142 = icmp eq i32 %616, 0, !dbg !1081
  %617 = bitcast float %554 to i32, !dbg !1081
  %618 = and i32 %617, 2147483647, !dbg !1081
  %is_zero143 = icmp eq i32 %618, 0, !dbg !1081
  %619 = xor i1 %is_zero143, true, !dbg !1081
  %620 = and i1 true, %619, !dbg !1081
  %621 = and i1 %is_zero142, %620, !dbg !1081
  %is_tiny144 = or i1 %is_subnormal141, %621, !dbg !1081
  %underflow_cond145 = and i1 %609, %is_tiny144, !dbg !1081
  br i1 %underflow_cond145, label %622, label %624, !dbg !1081

622:                                              ; preds = %602
  %623 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1081
  br label %624, !dbg !1081

624:                                              ; preds = %602, %622
  %625 = bitcast float %554 to i32, !dbg !1081
  %626 = and i32 %625, 2139095040, !dbg !1081
  %627 = icmp eq i32 %626, 0, !dbg !1081
  %628 = and i32 %625, 8388607, !dbg !1081
  %629 = icmp ne i32 %628, 0, !dbg !1081
  %is_subnormal146 = and i1 %627, %629, !dbg !1081
  %630 = xor i1 %is_subnormal146, true, !dbg !1081
  %631 = and i1 true, %630, !dbg !1081
  %632 = bitcast float %div33 to i32, !dbg !1081
  %633 = and i32 %632, 2139095040, !dbg !1081
  %634 = icmp eq i32 %633, 0, !dbg !1081
  %635 = and i32 %632, 8388607, !dbg !1081
  %636 = icmp ne i32 %635, 0, !dbg !1081
  %is_subnormal147 = and i1 %634, %636, !dbg !1081
  %subnormal_cond148 = and i1 %631, %is_subnormal147, !dbg !1081
  br i1 %subnormal_cond148, label %637, label %639, !dbg !1081

637:                                              ; preds = %624
  %638 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1081
  br label %639, !dbg !1081

639:                                              ; preds = %624, %637
  %640 = load ptr, ptr %result.addr, align 8, !dbg !1081
  %arrayidx34 = getelementptr inbounds float, ptr %640, i64 4, !dbg !1081
  store float %div33, ptr %arrayidx34, align 4, !dbg !1082
  %641 = load ptr, ptr %result.addr, align 8, !dbg !1083
  %arrayidx35 = getelementptr inbounds float, ptr %641, i64 4, !dbg !1083
  %642 = load float, ptr %arrayidx35, align 4, !dbg !1083
  store float %642, ptr %__x.addr.i79, align 4
    #dbg_declare(ptr %__x.addr.i79, !993, !DIExpression(), !1084)
  %643 = load float, ptr %__x.addr.i79, align 4, !dbg !1086
  store float %643, ptr %__a.addr.i101, align 4
    #dbg_declare(ptr %__a.addr.i101, !997, !DIExpression(), !1087)
  %644 = load float, ptr %__a.addr.i101, align 4, !dbg !1089
  %645 = bitcast float %644 to i32, !dbg !1090
  %646 = lshr i32 %645, 31, !dbg !1090
  %tobool.i81 = icmp ne i32 %646, 0, !dbg !1091
  %647 = zext i1 %tobool.i81 to i64, !dbg !1092
  %cond37 = select i1 %tobool.i81, i32 -1, i32 1, !dbg !1092
  %648 = load ptr, ptr %sign_check.addr, align 8, !dbg !1093
  %arrayidx38 = getelementptr inbounds i32, ptr %648, i64 4, !dbg !1093
  store i32 %cond37, ptr %arrayidx38, align 4, !dbg !1094
  br label %if.end39, !dbg !1095

if.end39:                                         ; preds = %639, %if.end30
  %649 = load i32, ptr %idx, align 4, !dbg !1096
  %cmp40 = icmp eq i32 %649, 5, !dbg !1098
  br i1 %cmp40, label %if.then41, label %if.end48, !dbg !1098

if.then41:                                        ; preds = %if.end39
  %650 = load float, ptr %neg_zero.addr, align 4, !dbg !1099
  %651 = bitcast float %650 to i32, !dbg !1101
  %652 = bitcast float %650 to i32, !dbg !1101
  %653 = and i32 %652, 2139095040, !dbg !1101
  %654 = icmp eq i32 %653, 2139095040, !dbg !1101
  %655 = and i32 %652, 8388607, !dbg !1101
  %656 = icmp ne i32 %655, 0, !dbg !1101
  %is_nan149 = and i1 %654, %656, !dbg !1101
  %657 = and i32 %651, 4194304, !dbg !1101
  %658 = icmp eq i32 %657, 0, !dbg !1101
  %is_snan150 = and i1 %is_nan149, %658, !dbg !1101
  %659 = or i1 false, %is_snan150, !dbg !1101
  %660 = bitcast float %650 to i32, !dbg !1101
  %661 = and i32 %660, 2147483647, !dbg !1101
  %is_zero151 = icmp eq i32 %661, 0, !dbg !1101
  %662 = and i1 false, %is_zero151, !dbg !1101
  %663 = bitcast float %650 to i32, !dbg !1101
  %664 = and i32 %663, 2139095040, !dbg !1101
  %665 = icmp eq i32 %664, 2139095040, !dbg !1101
  %666 = and i32 %663, 8388607, !dbg !1101
  %667 = icmp eq i32 %666, 0, !dbg !1101
  %is_inf152 = and i1 %665, %667, !dbg !1101
  %668 = and i1 false, %is_inf152, !dbg !1101
  %669 = or i1 %662, %668, !dbg !1101
  %670 = or i1 %659, %669, !dbg !1101
  br i1 %670, label %671, label %673, !dbg !1101

671:                                              ; preds = %if.then41
  %672 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1101
  br label %673, !dbg !1101

673:                                              ; preds = %if.then41, %671
  %674 = bitcast float %650 to i32, !dbg !1101
  %675 = and i32 %674, 2147483647, !dbg !1101
  %is_zero153 = icmp eq i32 %675, 0, !dbg !1101
  %divzero_cond154 = and i1 %is_zero153, true, !dbg !1101
  br i1 %divzero_cond154, label %676, label %678, !dbg !1101

676:                                              ; preds = %673
  %677 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 1), i64 1 monotonic, align 8, !dbg !1101
  br label %678, !dbg !1101

678:                                              ; preds = %673, %676
  %div42 = fdiv contract float 1.000000e+00, %650, !dbg !1101
  %679 = bitcast float %650 to i32, !dbg !1102
  %680 = and i32 %679, 2139095040, !dbg !1102
  %is_finite155 = icmp ne i32 %680, 2139095040, !dbg !1102
  %681 = and i1 true, %is_finite155, !dbg !1102
  %682 = bitcast float %650 to i32, !dbg !1102
  %683 = and i32 %682, 2147483647, !dbg !1102
  %is_zero156 = icmp eq i32 %683, 0, !dbg !1102
  %684 = xor i1 %is_zero156, true, !dbg !1102
  %overflow_denom_nonzero157 = and i1 %681, %684, !dbg !1102
  %685 = bitcast float %div42 to i32, !dbg !1102
  %686 = and i32 %685, 2139095040, !dbg !1102
  %687 = icmp eq i32 %686, 2139095040, !dbg !1102
  %688 = and i32 %685, 8388607, !dbg !1102
  %689 = icmp eq i32 %688, 0, !dbg !1102
  %is_inf158 = and i1 %687, %689, !dbg !1102
  %690 = bitcast float %div42 to i32, !dbg !1102
  %691 = and i32 %690, 2147483647, !dbg !1102
  %is_maxfinite159 = icmp eq i32 %691, 2139095039, !dbg !1102
  %692 = bitcast float %div42 to i32, !dbg !1102
  %693 = and i32 %692, -2147483648, !dbg !1102
  %694 = icmp eq i32 %693, 0, !dbg !1102
  %695 = icmp ne i32 %693, 0, !dbg !1102
  %is_pos_inf160 = and i1 %is_inf158, %694, !dbg !1102
  %is_neg_inf161 = and i1 %is_inf158, %695, !dbg !1102
  %is_pos_max162 = and i1 %is_maxfinite159, %694, !dbg !1102
  %is_neg_max163 = and i1 %is_maxfinite159, %695, !dbg !1102
  %overflow_cond164 = and i1 %overflow_denom_nonzero157, %is_inf158, !dbg !1102
  br i1 %overflow_cond164, label %696, label %698, !dbg !1102

696:                                              ; preds = %678
  %697 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1102
  br label %698, !dbg !1102

698:                                              ; preds = %678, %696
  %699 = bitcast float %650 to i32, !dbg !1102
  %700 = and i32 %699, 2139095040, !dbg !1102
  %701 = icmp eq i32 %700, 0, !dbg !1102
  %702 = and i32 %699, 8388607, !dbg !1102
  %703 = icmp ne i32 %702, 0, !dbg !1102
  %is_subnormal165 = and i1 %701, %703, !dbg !1102
  %704 = xor i1 %is_subnormal165, true, !dbg !1102
  %705 = and i1 true, %704, !dbg !1102
  %706 = bitcast float %div42 to i32, !dbg !1102
  %707 = and i32 %706, 2139095040, !dbg !1102
  %708 = icmp eq i32 %707, 0, !dbg !1102
  %709 = and i32 %706, 8388607, !dbg !1102
  %710 = icmp ne i32 %709, 0, !dbg !1102
  %is_subnormal166 = and i1 %708, %710, !dbg !1102
  %711 = bitcast float %div42 to i32, !dbg !1102
  %712 = and i32 %711, 2147483647, !dbg !1102
  %is_zero167 = icmp eq i32 %712, 0, !dbg !1102
  %713 = bitcast float %650 to i32, !dbg !1102
  %714 = and i32 %713, 2147483647, !dbg !1102
  %is_zero168 = icmp eq i32 %714, 0, !dbg !1102
  %715 = xor i1 %is_zero168, true, !dbg !1102
  %716 = and i1 true, %715, !dbg !1102
  %717 = and i1 %is_zero167, %716, !dbg !1102
  %is_tiny169 = or i1 %is_subnormal166, %717, !dbg !1102
  %underflow_cond170 = and i1 %705, %is_tiny169, !dbg !1102
  br i1 %underflow_cond170, label %718, label %720, !dbg !1102

718:                                              ; preds = %698
  %719 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1102
  br label %720, !dbg !1102

720:                                              ; preds = %698, %718
  %721 = bitcast float %650 to i32, !dbg !1102
  %722 = and i32 %721, 2139095040, !dbg !1102
  %723 = icmp eq i32 %722, 0, !dbg !1102
  %724 = and i32 %721, 8388607, !dbg !1102
  %725 = icmp ne i32 %724, 0, !dbg !1102
  %is_subnormal171 = and i1 %723, %725, !dbg !1102
  %726 = xor i1 %is_subnormal171, true, !dbg !1102
  %727 = and i1 true, %726, !dbg !1102
  %728 = bitcast float %div42 to i32, !dbg !1102
  %729 = and i32 %728, 2139095040, !dbg !1102
  %730 = icmp eq i32 %729, 0, !dbg !1102
  %731 = and i32 %728, 8388607, !dbg !1102
  %732 = icmp ne i32 %731, 0, !dbg !1102
  %is_subnormal172 = and i1 %730, %732, !dbg !1102
  %subnormal_cond173 = and i1 %727, %is_subnormal172, !dbg !1102
  br i1 %subnormal_cond173, label %733, label %735, !dbg !1102

733:                                              ; preds = %720
  %734 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1102
  br label %735, !dbg !1102

735:                                              ; preds = %720, %733
  %736 = load ptr, ptr %result.addr, align 8, !dbg !1102
  %arrayidx43 = getelementptr inbounds float, ptr %736, i64 5, !dbg !1102
  store float %div42, ptr %arrayidx43, align 4, !dbg !1103
  %737 = load ptr, ptr %result.addr, align 8, !dbg !1104
  %arrayidx44 = getelementptr inbounds float, ptr %737, i64 5, !dbg !1104
  %738 = load float, ptr %arrayidx44, align 4, !dbg !1104
  store float %738, ptr %__x.addr.i76, align 4
    #dbg_declare(ptr %__x.addr.i76, !993, !DIExpression(), !1105)
  %739 = load float, ptr %__x.addr.i76, align 4, !dbg !1107
  store float %739, ptr %__a.addr.i103, align 4
    #dbg_declare(ptr %__a.addr.i103, !997, !DIExpression(), !1108)
  %740 = load float, ptr %__a.addr.i103, align 4, !dbg !1110
  %741 = bitcast float %740 to i32, !dbg !1111
  %742 = lshr i32 %741, 31, !dbg !1111
  %tobool.i78 = icmp ne i32 %742, 0, !dbg !1112
  %743 = zext i1 %tobool.i78 to i64, !dbg !1113
  %cond46 = select i1 %tobool.i78, i32 -1, i32 1, !dbg !1113
  %744 = load ptr, ptr %sign_check.addr, align 8, !dbg !1114
  %arrayidx47 = getelementptr inbounds i32, ptr %744, i64 5, !dbg !1114
  store i32 %cond46, ptr %arrayidx47, align 4, !dbg !1115
  br label %if.end48, !dbg !1116

if.end48:                                         ; preds = %735, %if.end39
  %745 = load i32, ptr %idx, align 4, !dbg !1117
  %cmp49 = icmp eq i32 %745, 6, !dbg !1119
  br i1 %cmp49, label %if.then50, label %if.end57, !dbg !1119

if.then50:                                        ; preds = %if.end48
  %746 = load float, ptr %pos_zero.addr, align 4, !dbg !1120
  %747 = bitcast float %746 to i32, !dbg !1122
  %748 = bitcast float %746 to i32, !dbg !1122
  %749 = and i32 %748, 2139095040, !dbg !1122
  %750 = icmp eq i32 %749, 2139095040, !dbg !1122
  %751 = and i32 %748, 8388607, !dbg !1122
  %752 = icmp ne i32 %751, 0, !dbg !1122
  %is_nan174 = and i1 %750, %752, !dbg !1122
  %753 = and i32 %747, 4194304, !dbg !1122
  %754 = icmp eq i32 %753, 0, !dbg !1122
  %is_snan175 = and i1 %is_nan174, %754, !dbg !1122
  %755 = or i1 false, %is_snan175, !dbg !1122
  %756 = bitcast float %746 to i32, !dbg !1122
  %757 = and i32 %756, 2147483647, !dbg !1122
  %is_zero176 = icmp eq i32 %757, 0, !dbg !1122
  %758 = and i1 false, %is_zero176, !dbg !1122
  %759 = bitcast float %746 to i32, !dbg !1122
  %760 = and i32 %759, 2139095040, !dbg !1122
  %761 = icmp eq i32 %760, 2139095040, !dbg !1122
  %762 = and i32 %759, 8388607, !dbg !1122
  %763 = icmp eq i32 %762, 0, !dbg !1122
  %is_inf177 = and i1 %761, %763, !dbg !1122
  %764 = and i1 false, %is_inf177, !dbg !1122
  %765 = or i1 %758, %764, !dbg !1122
  %766 = or i1 %755, %765, !dbg !1122
  br i1 %766, label %767, label %769, !dbg !1122

767:                                              ; preds = %if.then50
  %768 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1122
  br label %769, !dbg !1122

769:                                              ; preds = %if.then50, %767
  %770 = bitcast float %746 to i32, !dbg !1122
  %771 = and i32 %770, 2147483647, !dbg !1122
  %is_zero178 = icmp eq i32 %771, 0, !dbg !1122
  %divzero_cond179 = and i1 %is_zero178, true, !dbg !1122
  br i1 %divzero_cond179, label %772, label %774, !dbg !1122

772:                                              ; preds = %769
  %773 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 1), i64 1 monotonic, align 8, !dbg !1122
  br label %774, !dbg !1122

774:                                              ; preds = %769, %772
  %div51 = fdiv contract float 0x3F1A36E2E0000000, %746, !dbg !1122
  %775 = bitcast float %746 to i32, !dbg !1123
  %776 = and i32 %775, 2139095040, !dbg !1123
  %is_finite180 = icmp ne i32 %776, 2139095040, !dbg !1123
  %777 = and i1 true, %is_finite180, !dbg !1123
  %778 = bitcast float %746 to i32, !dbg !1123
  %779 = and i32 %778, 2147483647, !dbg !1123
  %is_zero181 = icmp eq i32 %779, 0, !dbg !1123
  %780 = xor i1 %is_zero181, true, !dbg !1123
  %overflow_denom_nonzero182 = and i1 %777, %780, !dbg !1123
  %781 = bitcast float %div51 to i32, !dbg !1123
  %782 = and i32 %781, 2139095040, !dbg !1123
  %783 = icmp eq i32 %782, 2139095040, !dbg !1123
  %784 = and i32 %781, 8388607, !dbg !1123
  %785 = icmp eq i32 %784, 0, !dbg !1123
  %is_inf183 = and i1 %783, %785, !dbg !1123
  %786 = bitcast float %div51 to i32, !dbg !1123
  %787 = and i32 %786, 2147483647, !dbg !1123
  %is_maxfinite184 = icmp eq i32 %787, 2139095039, !dbg !1123
  %788 = bitcast float %div51 to i32, !dbg !1123
  %789 = and i32 %788, -2147483648, !dbg !1123
  %790 = icmp eq i32 %789, 0, !dbg !1123
  %791 = icmp ne i32 %789, 0, !dbg !1123
  %is_pos_inf185 = and i1 %is_inf183, %790, !dbg !1123
  %is_neg_inf186 = and i1 %is_inf183, %791, !dbg !1123
  %is_pos_max187 = and i1 %is_maxfinite184, %790, !dbg !1123
  %is_neg_max188 = and i1 %is_maxfinite184, %791, !dbg !1123
  %overflow_cond189 = and i1 %overflow_denom_nonzero182, %is_inf183, !dbg !1123
  br i1 %overflow_cond189, label %792, label %794, !dbg !1123

792:                                              ; preds = %774
  %793 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1123
  br label %794, !dbg !1123

794:                                              ; preds = %774, %792
  %795 = bitcast float %746 to i32, !dbg !1123
  %796 = and i32 %795, 2139095040, !dbg !1123
  %797 = icmp eq i32 %796, 0, !dbg !1123
  %798 = and i32 %795, 8388607, !dbg !1123
  %799 = icmp ne i32 %798, 0, !dbg !1123
  %is_subnormal190 = and i1 %797, %799, !dbg !1123
  %800 = xor i1 %is_subnormal190, true, !dbg !1123
  %801 = and i1 true, %800, !dbg !1123
  %802 = bitcast float %div51 to i32, !dbg !1123
  %803 = and i32 %802, 2139095040, !dbg !1123
  %804 = icmp eq i32 %803, 0, !dbg !1123
  %805 = and i32 %802, 8388607, !dbg !1123
  %806 = icmp ne i32 %805, 0, !dbg !1123
  %is_subnormal191 = and i1 %804, %806, !dbg !1123
  %807 = bitcast float %div51 to i32, !dbg !1123
  %808 = and i32 %807, 2147483647, !dbg !1123
  %is_zero192 = icmp eq i32 %808, 0, !dbg !1123
  %809 = bitcast float %746 to i32, !dbg !1123
  %810 = and i32 %809, 2147483647, !dbg !1123
  %is_zero193 = icmp eq i32 %810, 0, !dbg !1123
  %811 = xor i1 %is_zero193, true, !dbg !1123
  %812 = and i1 true, %811, !dbg !1123
  %813 = and i1 %is_zero192, %812, !dbg !1123
  %is_tiny194 = or i1 %is_subnormal191, %813, !dbg !1123
  %underflow_cond195 = and i1 %801, %is_tiny194, !dbg !1123
  br i1 %underflow_cond195, label %814, label %816, !dbg !1123

814:                                              ; preds = %794
  %815 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1123
  br label %816, !dbg !1123

816:                                              ; preds = %794, %814
  %817 = bitcast float %746 to i32, !dbg !1123
  %818 = and i32 %817, 2139095040, !dbg !1123
  %819 = icmp eq i32 %818, 0, !dbg !1123
  %820 = and i32 %817, 8388607, !dbg !1123
  %821 = icmp ne i32 %820, 0, !dbg !1123
  %is_subnormal196 = and i1 %819, %821, !dbg !1123
  %822 = xor i1 %is_subnormal196, true, !dbg !1123
  %823 = and i1 true, %822, !dbg !1123
  %824 = bitcast float %div51 to i32, !dbg !1123
  %825 = and i32 %824, 2139095040, !dbg !1123
  %826 = icmp eq i32 %825, 0, !dbg !1123
  %827 = and i32 %824, 8388607, !dbg !1123
  %828 = icmp ne i32 %827, 0, !dbg !1123
  %is_subnormal197 = and i1 %826, %828, !dbg !1123
  %subnormal_cond198 = and i1 %823, %is_subnormal197, !dbg !1123
  br i1 %subnormal_cond198, label %829, label %831, !dbg !1123

829:                                              ; preds = %816
  %830 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1123
  br label %831, !dbg !1123

831:                                              ; preds = %816, %829
  %832 = load ptr, ptr %result.addr, align 8, !dbg !1123
  %arrayidx52 = getelementptr inbounds float, ptr %832, i64 6, !dbg !1123
  store float %div51, ptr %arrayidx52, align 4, !dbg !1124
  %833 = load ptr, ptr %result.addr, align 8, !dbg !1125
  %arrayidx53 = getelementptr inbounds float, ptr %833, i64 6, !dbg !1125
  %834 = load float, ptr %arrayidx53, align 4, !dbg !1125
  store float %834, ptr %__x.addr.i73, align 4
    #dbg_declare(ptr %__x.addr.i73, !993, !DIExpression(), !1126)
  %835 = load float, ptr %__x.addr.i73, align 4, !dbg !1128
  store float %835, ptr %__a.addr.i105, align 4
    #dbg_declare(ptr %__a.addr.i105, !997, !DIExpression(), !1129)
  %836 = load float, ptr %__a.addr.i105, align 4, !dbg !1131
  %837 = bitcast float %836 to i32, !dbg !1132
  %838 = lshr i32 %837, 31, !dbg !1132
  %tobool.i75 = icmp ne i32 %838, 0, !dbg !1133
  %839 = zext i1 %tobool.i75 to i64, !dbg !1134
  %cond55 = select i1 %tobool.i75, i32 -1, i32 1, !dbg !1134
  %840 = load ptr, ptr %sign_check.addr, align 8, !dbg !1135
  %arrayidx56 = getelementptr inbounds i32, ptr %840, i64 6, !dbg !1135
  store i32 %cond55, ptr %arrayidx56, align 4, !dbg !1136
  br label %if.end57, !dbg !1137

if.end57:                                         ; preds = %831, %if.end48
  %841 = load i32, ptr %idx, align 4, !dbg !1138
  %cmp58 = icmp eq i32 %841, 7, !dbg !1140
  br i1 %cmp58, label %if.then59, label %if.end66, !dbg !1140

if.then59:                                        ; preds = %if.end57
  %842 = load float, ptr %pos_zero.addr, align 4, !dbg !1141
  %843 = bitcast float %842 to i32, !dbg !1143
  %844 = bitcast float %842 to i32, !dbg !1143
  %845 = and i32 %844, 2139095040, !dbg !1143
  %846 = icmp eq i32 %845, 2139095040, !dbg !1143
  %847 = and i32 %844, 8388607, !dbg !1143
  %848 = icmp ne i32 %847, 0, !dbg !1143
  %is_nan199 = and i1 %846, %848, !dbg !1143
  %849 = and i32 %843, 4194304, !dbg !1143
  %850 = icmp eq i32 %849, 0, !dbg !1143
  %is_snan200 = and i1 %is_nan199, %850, !dbg !1143
  %851 = or i1 false, %is_snan200, !dbg !1143
  %852 = bitcast float %842 to i32, !dbg !1143
  %853 = and i32 %852, 2147483647, !dbg !1143
  %is_zero201 = icmp eq i32 %853, 0, !dbg !1143
  %854 = and i1 false, %is_zero201, !dbg !1143
  %855 = bitcast float %842 to i32, !dbg !1143
  %856 = and i32 %855, 2139095040, !dbg !1143
  %857 = icmp eq i32 %856, 2139095040, !dbg !1143
  %858 = and i32 %855, 8388607, !dbg !1143
  %859 = icmp eq i32 %858, 0, !dbg !1143
  %is_inf202 = and i1 %857, %859, !dbg !1143
  %860 = and i1 false, %is_inf202, !dbg !1143
  %861 = or i1 %854, %860, !dbg !1143
  %862 = or i1 %851, %861, !dbg !1143
  br i1 %862, label %863, label %865, !dbg !1143

863:                                              ; preds = %if.then59
  %864 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1143
  br label %865, !dbg !1143

865:                                              ; preds = %if.then59, %863
  %866 = bitcast float %842 to i32, !dbg !1143
  %867 = and i32 %866, 2147483647, !dbg !1143
  %is_zero203 = icmp eq i32 %867, 0, !dbg !1143
  %divzero_cond204 = and i1 %is_zero203, true, !dbg !1143
  br i1 %divzero_cond204, label %868, label %870, !dbg !1143

868:                                              ; preds = %865
  %869 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 1), i64 1 monotonic, align 8, !dbg !1143
  br label %870, !dbg !1143

870:                                              ; preds = %865, %868
  %div60 = fdiv contract float 0xBF1A36E2E0000000, %842, !dbg !1143
  %871 = bitcast float %842 to i32, !dbg !1144
  %872 = and i32 %871, 2139095040, !dbg !1144
  %is_finite205 = icmp ne i32 %872, 2139095040, !dbg !1144
  %873 = and i1 true, %is_finite205, !dbg !1144
  %874 = bitcast float %842 to i32, !dbg !1144
  %875 = and i32 %874, 2147483647, !dbg !1144
  %is_zero206 = icmp eq i32 %875, 0, !dbg !1144
  %876 = xor i1 %is_zero206, true, !dbg !1144
  %overflow_denom_nonzero207 = and i1 %873, %876, !dbg !1144
  %877 = bitcast float %div60 to i32, !dbg !1144
  %878 = and i32 %877, 2139095040, !dbg !1144
  %879 = icmp eq i32 %878, 2139095040, !dbg !1144
  %880 = and i32 %877, 8388607, !dbg !1144
  %881 = icmp eq i32 %880, 0, !dbg !1144
  %is_inf208 = and i1 %879, %881, !dbg !1144
  %882 = bitcast float %div60 to i32, !dbg !1144
  %883 = and i32 %882, 2147483647, !dbg !1144
  %is_maxfinite209 = icmp eq i32 %883, 2139095039, !dbg !1144
  %884 = bitcast float %div60 to i32, !dbg !1144
  %885 = and i32 %884, -2147483648, !dbg !1144
  %886 = icmp eq i32 %885, 0, !dbg !1144
  %887 = icmp ne i32 %885, 0, !dbg !1144
  %is_pos_inf210 = and i1 %is_inf208, %886, !dbg !1144
  %is_neg_inf211 = and i1 %is_inf208, %887, !dbg !1144
  %is_pos_max212 = and i1 %is_maxfinite209, %886, !dbg !1144
  %is_neg_max213 = and i1 %is_maxfinite209, %887, !dbg !1144
  %overflow_cond214 = and i1 %overflow_denom_nonzero207, %is_inf208, !dbg !1144
  br i1 %overflow_cond214, label %888, label %890, !dbg !1144

888:                                              ; preds = %870
  %889 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1144
  br label %890, !dbg !1144

890:                                              ; preds = %870, %888
  %891 = bitcast float %842 to i32, !dbg !1144
  %892 = and i32 %891, 2139095040, !dbg !1144
  %893 = icmp eq i32 %892, 0, !dbg !1144
  %894 = and i32 %891, 8388607, !dbg !1144
  %895 = icmp ne i32 %894, 0, !dbg !1144
  %is_subnormal215 = and i1 %893, %895, !dbg !1144
  %896 = xor i1 %is_subnormal215, true, !dbg !1144
  %897 = and i1 true, %896, !dbg !1144
  %898 = bitcast float %div60 to i32, !dbg !1144
  %899 = and i32 %898, 2139095040, !dbg !1144
  %900 = icmp eq i32 %899, 0, !dbg !1144
  %901 = and i32 %898, 8388607, !dbg !1144
  %902 = icmp ne i32 %901, 0, !dbg !1144
  %is_subnormal216 = and i1 %900, %902, !dbg !1144
  %903 = bitcast float %div60 to i32, !dbg !1144
  %904 = and i32 %903, 2147483647, !dbg !1144
  %is_zero217 = icmp eq i32 %904, 0, !dbg !1144
  %905 = bitcast float %842 to i32, !dbg !1144
  %906 = and i32 %905, 2147483647, !dbg !1144
  %is_zero218 = icmp eq i32 %906, 0, !dbg !1144
  %907 = xor i1 %is_zero218, true, !dbg !1144
  %908 = and i1 true, %907, !dbg !1144
  %909 = and i1 %is_zero217, %908, !dbg !1144
  %is_tiny219 = or i1 %is_subnormal216, %909, !dbg !1144
  %underflow_cond220 = and i1 %897, %is_tiny219, !dbg !1144
  br i1 %underflow_cond220, label %910, label %912, !dbg !1144

910:                                              ; preds = %890
  %911 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1144
  br label %912, !dbg !1144

912:                                              ; preds = %890, %910
  %913 = bitcast float %842 to i32, !dbg !1144
  %914 = and i32 %913, 2139095040, !dbg !1144
  %915 = icmp eq i32 %914, 0, !dbg !1144
  %916 = and i32 %913, 8388607, !dbg !1144
  %917 = icmp ne i32 %916, 0, !dbg !1144
  %is_subnormal221 = and i1 %915, %917, !dbg !1144
  %918 = xor i1 %is_subnormal221, true, !dbg !1144
  %919 = and i1 true, %918, !dbg !1144
  %920 = bitcast float %div60 to i32, !dbg !1144
  %921 = and i32 %920, 2139095040, !dbg !1144
  %922 = icmp eq i32 %921, 0, !dbg !1144
  %923 = and i32 %920, 8388607, !dbg !1144
  %924 = icmp ne i32 %923, 0, !dbg !1144
  %is_subnormal222 = and i1 %922, %924, !dbg !1144
  %subnormal_cond223 = and i1 %919, %is_subnormal222, !dbg !1144
  br i1 %subnormal_cond223, label %925, label %927, !dbg !1144

925:                                              ; preds = %912
  %926 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1144
  br label %927, !dbg !1144

927:                                              ; preds = %912, %925
  %928 = load ptr, ptr %result.addr, align 8, !dbg !1144
  %arrayidx61 = getelementptr inbounds float, ptr %928, i64 7, !dbg !1144
  store float %div60, ptr %arrayidx61, align 4, !dbg !1145
  %929 = load ptr, ptr %result.addr, align 8, !dbg !1146
  %arrayidx62 = getelementptr inbounds float, ptr %929, i64 7, !dbg !1146
  %930 = load float, ptr %arrayidx62, align 4, !dbg !1146
  store float %930, ptr %__x.addr.i, align 4
    #dbg_declare(ptr %__x.addr.i, !993, !DIExpression(), !1147)
  %931 = load float, ptr %__x.addr.i, align 4, !dbg !1149
  store float %931, ptr %__a.addr.i107, align 4
    #dbg_declare(ptr %__a.addr.i107, !997, !DIExpression(), !1150)
  %932 = load float, ptr %__a.addr.i107, align 4, !dbg !1152
  %933 = bitcast float %932 to i32, !dbg !1153
  %934 = lshr i32 %933, 31, !dbg !1153
  %tobool.i = icmp ne i32 %934, 0, !dbg !1154
  %935 = zext i1 %tobool.i to i64, !dbg !1155
  %cond64 = select i1 %tobool.i, i32 -1, i32 1, !dbg !1155
  %936 = load ptr, ptr %sign_check.addr, align 8, !dbg !1156
  %arrayidx65 = getelementptr inbounds i32, ptr %936, i64 7, !dbg !1156
  store i32 %cond64, ptr %arrayidx65, align 4, !dbg !1157
  br label %if.end66, !dbg !1158

if.end66:                                         ; preds = %927, %if.end57
  %937 = load i32, ptr %idx, align 4, !dbg !1159
  %cmp67 = icmp eq i32 %937, 8, !dbg !1161
  br i1 %cmp67, label %if.then68, label %if.end72, !dbg !1161

if.then68:                                        ; preds = %if.end66
  %938 = load float, ptr %pos_zero.addr, align 4, !dbg !1162
  %939 = load float, ptr %pos_zero.addr, align 4, !dbg !1164
  %940 = bitcast float %938 to i32, !dbg !1165
  %941 = bitcast float %938 to i32, !dbg !1165
  %942 = and i32 %941, 2139095040, !dbg !1165
  %943 = icmp eq i32 %942, 2139095040, !dbg !1165
  %944 = and i32 %941, 8388607, !dbg !1165
  %945 = icmp ne i32 %944, 0, !dbg !1165
  %is_nan224 = and i1 %943, %945, !dbg !1165
  %946 = and i32 %940, 4194304, !dbg !1165
  %947 = icmp eq i32 %946, 0, !dbg !1165
  %is_snan225 = and i1 %is_nan224, %947, !dbg !1165
  %948 = bitcast float %939 to i32, !dbg !1165
  %949 = bitcast float %939 to i32, !dbg !1165
  %950 = and i32 %949, 2139095040, !dbg !1165
  %951 = icmp eq i32 %950, 2139095040, !dbg !1165
  %952 = and i32 %949, 8388607, !dbg !1165
  %953 = icmp ne i32 %952, 0, !dbg !1165
  %is_nan226 = and i1 %951, %953, !dbg !1165
  %954 = and i32 %948, 4194304, !dbg !1165
  %955 = icmp eq i32 %954, 0, !dbg !1165
  %is_snan227 = and i1 %is_nan226, %955, !dbg !1165
  %956 = or i1 %is_snan225, %is_snan227, !dbg !1165
  %957 = bitcast float %938 to i32, !dbg !1165
  %958 = and i32 %957, 2147483647, !dbg !1165
  %is_zero228 = icmp eq i32 %958, 0, !dbg !1165
  %959 = bitcast float %939 to i32, !dbg !1165
  %960 = and i32 %959, 2147483647, !dbg !1165
  %is_zero229 = icmp eq i32 %960, 0, !dbg !1165
  %961 = and i1 %is_zero228, %is_zero229, !dbg !1165
  %962 = bitcast float %938 to i32, !dbg !1165
  %963 = and i32 %962, 2139095040, !dbg !1165
  %964 = icmp eq i32 %963, 2139095040, !dbg !1165
  %965 = and i32 %962, 8388607, !dbg !1165
  %966 = icmp eq i32 %965, 0, !dbg !1165
  %is_inf230 = and i1 %964, %966, !dbg !1165
  %967 = bitcast float %939 to i32, !dbg !1165
  %968 = and i32 %967, 2139095040, !dbg !1165
  %969 = icmp eq i32 %968, 2139095040, !dbg !1165
  %970 = and i32 %967, 8388607, !dbg !1165
  %971 = icmp eq i32 %970, 0, !dbg !1165
  %is_inf231 = and i1 %969, %971, !dbg !1165
  %972 = and i1 %is_inf230, %is_inf231, !dbg !1165
  %973 = or i1 %961, %972, !dbg !1165
  %974 = or i1 %956, %973, !dbg !1165
  br i1 %974, label %975, label %977, !dbg !1165

975:                                              ; preds = %if.then68
  %976 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1165
  br label %977, !dbg !1165

977:                                              ; preds = %if.then68, %975
  %978 = bitcast float %939 to i32, !dbg !1165
  %979 = and i32 %978, 2147483647, !dbg !1165
  %is_zero232 = icmp eq i32 %979, 0, !dbg !1165
  %980 = bitcast float %938 to i32, !dbg !1165
  %981 = and i32 %980, 2139095040, !dbg !1165
  %is_finite233 = icmp ne i32 %981, 2139095040, !dbg !1165
  %982 = bitcast float %938 to i32, !dbg !1165
  %983 = and i32 %982, 2147483647, !dbg !1165
  %is_zero234 = icmp eq i32 %983, 0, !dbg !1165
  %984 = xor i1 %is_zero234, true, !dbg !1165
  %985 = and i1 %is_finite233, %984, !dbg !1165
  %divzero_cond235 = and i1 %is_zero232, %985, !dbg !1165
  br i1 %divzero_cond235, label %986, label %988, !dbg !1165

986:                                              ; preds = %977
  %987 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 1), i64 1 monotonic, align 8, !dbg !1165
  br label %988, !dbg !1165

988:                                              ; preds = %977, %986
  %div69 = fdiv contract float %938, %939, !dbg !1165
  %989 = bitcast float %938 to i32, !dbg !1166
  %990 = and i32 %989, 2139095040, !dbg !1166
  %is_finite236 = icmp ne i32 %990, 2139095040, !dbg !1166
  %991 = and i1 true, %is_finite236, !dbg !1166
  %992 = bitcast float %939 to i32, !dbg !1166
  %993 = and i32 %992, 2139095040, !dbg !1166
  %is_finite237 = icmp ne i32 %993, 2139095040, !dbg !1166
  %994 = and i1 %991, %is_finite237, !dbg !1166
  %995 = bitcast float %939 to i32, !dbg !1166
  %996 = and i32 %995, 2147483647, !dbg !1166
  %is_zero238 = icmp eq i32 %996, 0, !dbg !1166
  %997 = xor i1 %is_zero238, true, !dbg !1166
  %overflow_denom_nonzero239 = and i1 %994, %997, !dbg !1166
  %998 = bitcast float %div69 to i32, !dbg !1166
  %999 = and i32 %998, 2139095040, !dbg !1166
  %1000 = icmp eq i32 %999, 2139095040, !dbg !1166
  %1001 = and i32 %998, 8388607, !dbg !1166
  %1002 = icmp eq i32 %1001, 0, !dbg !1166
  %is_inf240 = and i1 %1000, %1002, !dbg !1166
  %1003 = bitcast float %div69 to i32, !dbg !1166
  %1004 = and i32 %1003, 2147483647, !dbg !1166
  %is_maxfinite241 = icmp eq i32 %1004, 2139095039, !dbg !1166
  %1005 = bitcast float %div69 to i32, !dbg !1166
  %1006 = and i32 %1005, -2147483648, !dbg !1166
  %1007 = icmp eq i32 %1006, 0, !dbg !1166
  %1008 = icmp ne i32 %1006, 0, !dbg !1166
  %is_pos_inf242 = and i1 %is_inf240, %1007, !dbg !1166
  %is_neg_inf243 = and i1 %is_inf240, %1008, !dbg !1166
  %is_pos_max244 = and i1 %is_maxfinite241, %1007, !dbg !1166
  %is_neg_max245 = and i1 %is_maxfinite241, %1008, !dbg !1166
  %overflow_cond246 = and i1 %overflow_denom_nonzero239, %is_inf240, !dbg !1166
  br i1 %overflow_cond246, label %1009, label %1011, !dbg !1166

1009:                                             ; preds = %988
  %1010 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1166
  br label %1011, !dbg !1166

1011:                                             ; preds = %988, %1009
  %1012 = bitcast float %938 to i32, !dbg !1166
  %1013 = and i32 %1012, 2139095040, !dbg !1166
  %1014 = icmp eq i32 %1013, 0, !dbg !1166
  %1015 = and i32 %1012, 8388607, !dbg !1166
  %1016 = icmp ne i32 %1015, 0, !dbg !1166
  %is_subnormal247 = and i1 %1014, %1016, !dbg !1166
  %1017 = xor i1 %is_subnormal247, true, !dbg !1166
  %1018 = and i1 true, %1017, !dbg !1166
  %1019 = bitcast float %939 to i32, !dbg !1166
  %1020 = and i32 %1019, 2139095040, !dbg !1166
  %1021 = icmp eq i32 %1020, 0, !dbg !1166
  %1022 = and i32 %1019, 8388607, !dbg !1166
  %1023 = icmp ne i32 %1022, 0, !dbg !1166
  %is_subnormal248 = and i1 %1021, %1023, !dbg !1166
  %1024 = xor i1 %is_subnormal248, true, !dbg !1166
  %1025 = and i1 %1018, %1024, !dbg !1166
  %1026 = bitcast float %div69 to i32, !dbg !1166
  %1027 = and i32 %1026, 2139095040, !dbg !1166
  %1028 = icmp eq i32 %1027, 0, !dbg !1166
  %1029 = and i32 %1026, 8388607, !dbg !1166
  %1030 = icmp ne i32 %1029, 0, !dbg !1166
  %is_subnormal249 = and i1 %1028, %1030, !dbg !1166
  %1031 = bitcast float %div69 to i32, !dbg !1166
  %1032 = and i32 %1031, 2147483647, !dbg !1166
  %is_zero250 = icmp eq i32 %1032, 0, !dbg !1166
  %1033 = bitcast float %938 to i32, !dbg !1166
  %1034 = and i32 %1033, 2147483647, !dbg !1166
  %is_zero251 = icmp eq i32 %1034, 0, !dbg !1166
  %1035 = xor i1 %is_zero251, true, !dbg !1166
  %1036 = bitcast float %939 to i32, !dbg !1166
  %1037 = and i32 %1036, 2147483647, !dbg !1166
  %is_zero252 = icmp eq i32 %1037, 0, !dbg !1166
  %1038 = xor i1 %is_zero252, true, !dbg !1166
  %1039 = and i1 %1035, %1038, !dbg !1166
  %1040 = and i1 %is_zero250, %1039, !dbg !1166
  %is_tiny253 = or i1 %is_subnormal249, %1040, !dbg !1166
  %underflow_cond254 = and i1 %1025, %is_tiny253, !dbg !1166
  br i1 %underflow_cond254, label %1041, label %1043, !dbg !1166

1041:                                             ; preds = %1011
  %1042 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1166
  br label %1043, !dbg !1166

1043:                                             ; preds = %1011, %1041
  %1044 = bitcast float %938 to i32, !dbg !1166
  %1045 = and i32 %1044, 2139095040, !dbg !1166
  %1046 = icmp eq i32 %1045, 0, !dbg !1166
  %1047 = and i32 %1044, 8388607, !dbg !1166
  %1048 = icmp ne i32 %1047, 0, !dbg !1166
  %is_subnormal255 = and i1 %1046, %1048, !dbg !1166
  %1049 = xor i1 %is_subnormal255, true, !dbg !1166
  %1050 = and i1 true, %1049, !dbg !1166
  %1051 = bitcast float %939 to i32, !dbg !1166
  %1052 = and i32 %1051, 2139095040, !dbg !1166
  %1053 = icmp eq i32 %1052, 0, !dbg !1166
  %1054 = and i32 %1051, 8388607, !dbg !1166
  %1055 = icmp ne i32 %1054, 0, !dbg !1166
  %is_subnormal256 = and i1 %1053, %1055, !dbg !1166
  %1056 = xor i1 %is_subnormal256, true, !dbg !1166
  %1057 = and i1 %1050, %1056, !dbg !1166
  %1058 = bitcast float %div69 to i32, !dbg !1166
  %1059 = and i32 %1058, 2139095040, !dbg !1166
  %1060 = icmp eq i32 %1059, 0, !dbg !1166
  %1061 = and i32 %1058, 8388607, !dbg !1166
  %1062 = icmp ne i32 %1061, 0, !dbg !1166
  %is_subnormal257 = and i1 %1060, %1062, !dbg !1166
  %subnormal_cond258 = and i1 %1057, %is_subnormal257, !dbg !1166
  br i1 %subnormal_cond258, label %1063, label %1065, !dbg !1166

1063:                                             ; preds = %1043
  %1064 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1166
  br label %1065, !dbg !1166

1065:                                             ; preds = %1043, %1063
  %1066 = load ptr, ptr %result.addr, align 8, !dbg !1166
  %arrayidx70 = getelementptr inbounds float, ptr %1066, i64 8, !dbg !1166
  store float %div69, ptr %arrayidx70, align 4, !dbg !1167
  %1067 = load ptr, ptr %sign_check.addr, align 8, !dbg !1168
  %arrayidx71 = getelementptr inbounds i32, ptr %1067, i64 8, !dbg !1168
  store i32 0, ptr %arrayidx71, align 4, !dbg !1169
  br label %if.end72, !dbg !1170

if.end72:                                         ; preds = %1065, %if.end66
  ret void, !dbg !1171
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare noundef range(i32 0, 1024) i32 @llvm.nvvm.read.ptx.sreg.tid.x() #1

attributes #0 = { convergent noinline norecurse nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_80" "target-features"="+ptx87,+sm_80" "uniform-work-group-size"="true" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!954, !955}
!nvvmir.version = !{!956}
!llvm.module.flags = !{!957, !958, !959, !960, !961, !962}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !1, producer: "clang version 22.1.5 (https://github.com/llvm/llvm-project.git 5ea218a153f4d2f815b8244eab3e4b4ba5e00e6c)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !27, imports: !91, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "tests/basic_tests/divZero/divByZero.cu", directory: "/home/users/sislam3/SBAC-PAD")
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
!91 = !{!92, !99, !104, !106, !108, !110, !112, !116, !118, !120, !122, !124, !126, !128, !130, !132, !134, !136, !138, !140, !142, !144, !148, !150, !152, !154, !158, !163, !165, !167, !172, !176, !178, !180, !182, !184, !186, !188, !190, !192, !197, !201, !203, !208, !212, !214, !216, !218, !220, !222, !226, !228, !230, !235, !243, !247, !249, !251, !253, !255, !259, !261, !263, !267, !269, !273, !275, !277, !279, !281, !283, !285, !287, !291, !297, !299, !301, !305, !307, !309, !311, !313, !315, !317, !319, !323, !327, !329, !331, !336, !338, !340, !342, !344, !346, !348, !351, !353, !355, !357, !362, !364, !366, !368, !370, !372, !374, !376, !378, !380, !382, !384, !388, !390, !392, !394, !396, !398, !400, !402, !404, !406, !408, !410, !412, !414, !416, !418, !422, !424, !428, !430, !432, !434, !436, !438, !440, !442, !444, !446, !450, !452, !456, !458, !460, !462, !466, !468, !472, !474, !476, !478, !480, !482, !484, !486, !488, !490, !492, !494, !496, !500, !502, !506, !508, !510, !512, !514, !516, !520, !522, !524, !526, !528, !530, !532, !536, !540, !542, !544, !546, !548, !552, !554, !558, !560, !562, !564, !566, !568, !570, !574, !576, !580, !582, !584, !588, !590, !592, !594, !596, !598, !600, !604, !608, !614, !618, !626, !631, !633, !635, !639, !643, !653, !655, !659, !663, !667, !672, !674, !678, !682, !686, !694, !698, !702, !704, !708, !712, !716, !722, !726, !730, !732, !740, !744, !751, !753, !755, !759, !763, !767, !771, !775, !779, !780, !781, !782, !784, !785, !786, !787, !788, !789, !790, !792, !793, !794, !795, !796, !797, !798, !799, !804, !805, !806, !807, !808, !809, !810, !811, !812, !813, !814, !815, !816, !817, !818, !819, !820, !821, !822, !823, !824, !825, !826, !827, !828, !831, !833, !835, !837, !839, !841, !843, !845, !847, !849, !851, !853, !855, !857, !859, !861, !863, !865, !867, !869, !871, !873, !875, !877, !879, !881, !883, !885, !887, !889, !891, !893, !895, !897, !899, !901, !903, !905, !907, !909, !911, !913, !915, !917, !919, !921, !923, !925, !927, !929, !931, !933, !935, !937, !939, !940, !941, !945, !947, !949}
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
!270 = distinct !DISubprogram(name: "signbit", linkageName: "_ZL7signbitf", scope: !271, file: !271, line: 170, type: !169, scopeLine: 170, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !272)
!271 = !DIFile(filename: "/storage/users/sislam3/opt/llvm-22/lib/clang/22/include/__clang_cuda_cmath.h", directory: "")
!272 = !{}
!273 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !274, file: !95, line: 265)
!274 = !DISubprogram(name: "sin", linkageName: "_ZL3sinf", scope: !95, file: !95, line: 169, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!275 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !276, file: !95, line: 266)
!276 = !DISubprogram(name: "sinh", linkageName: "_ZL4sinhf", scope: !95, file: !95, line: 171, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!277 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !278, file: !95, line: 267)
!278 = !DISubprogram(name: "sqrt", linkageName: "_ZL4sqrtf", scope: !95, file: !95, line: 173, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!279 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !280, file: !95, line: 268)
!280 = !DISubprogram(name: "tan", linkageName: "_ZL3tanf", scope: !95, file: !95, line: 175, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!281 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !282, file: !95, line: 269)
!282 = !DISubprogram(name: "tanh", linkageName: "_ZL4tanhf", scope: !95, file: !95, line: 177, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!283 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !284, file: !95, line: 270)
!284 = !DISubprogram(name: "tgamma", linkageName: "_ZL6tgammaf", scope: !95, file: !95, line: 179, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!285 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !286, file: !95, line: 271)
!286 = !DISubprogram(name: "trunc", linkageName: "_ZL5truncf", scope: !95, file: !95, line: 181, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!287 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !288, file: !290, line: 52)
!288 = !DISubprogram(name: "abs", scope: !289, file: !289, line: 837, type: !96, flags: DIFlagPrototyped, spFlags: 0)
!289 = !DIFile(filename: "/usr/include/stdlib.h", directory: "")
!290 = !DIFile(filename: "/opt/rh/gcc-toolset-13/root/usr/lib/gcc/x86_64-redhat-linux/13/../../../../include/c++/13/bits/std_abs.h", directory: "")
!291 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !292, file: !296, line: 85)
!292 = !DISubprogram(name: "acos", scope: !293, file: !293, line: 53, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!293 = !DIFile(filename: "/usr/include/bits/mathcalls.h", directory: "")
!294 = !DISubroutineType(types: !295)
!295 = !{!239, !239}
!296 = !DIFile(filename: "/opt/rh/gcc-toolset-13/root/usr/lib/gcc/x86_64-redhat-linux/13/../../../../include/c++/13/cmath", directory: "")
!297 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !298, file: !296, line: 104)
!298 = !DISubprogram(name: "asin", scope: !293, file: !293, line: 55, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!299 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !300, file: !296, line: 123)
!300 = !DISubprogram(name: "atan", scope: !293, file: !293, line: 57, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!301 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !302, file: !296, line: 142)
!302 = !DISubprogram(name: "atan2", scope: !293, file: !293, line: 59, type: !303, flags: DIFlagPrototyped, spFlags: 0)
!303 = !DISubroutineType(types: !304)
!304 = !{!239, !239, !239}
!305 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !306, file: !296, line: 154)
!306 = !DISubprogram(name: "ceil", scope: !293, file: !293, line: 159, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!307 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !308, file: !296, line: 173)
!308 = !DISubprogram(name: "cos", scope: !293, file: !293, line: 62, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!309 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !310, file: !296, line: 192)
!310 = !DISubprogram(name: "cosh", scope: !293, file: !293, line: 71, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!311 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !312, file: !296, line: 211)
!312 = !DISubprogram(name: "exp", scope: !293, file: !293, line: 95, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!313 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !314, file: !296, line: 230)
!314 = !DISubprogram(name: "fabs", scope: !293, file: !293, line: 162, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!315 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !316, file: !296, line: 249)
!316 = !DISubprogram(name: "floor", scope: !293, file: !293, line: 165, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!317 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !318, file: !296, line: 268)
!318 = !DISubprogram(name: "fmod", scope: !293, file: !293, line: 168, type: !303, flags: DIFlagPrototyped, spFlags: 0)
!319 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !320, file: !296, line: 280)
!320 = !DISubprogram(name: "frexp", scope: !293, file: !293, line: 98, type: !321, flags: DIFlagPrototyped, spFlags: 0)
!321 = !DISubroutineType(types: !322)
!322 = !{!239, !239, !162}
!323 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !324, file: !296, line: 299)
!324 = !DISubprogram(name: "ldexp", scope: !293, file: !293, line: 101, type: !325, flags: DIFlagPrototyped, spFlags: 0)
!325 = !DISubroutineType(types: !326)
!326 = !{!239, !239, !98}
!327 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !328, file: !296, line: 318)
!328 = !DISubprogram(name: "log", scope: !293, file: !293, line: 104, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!329 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !330, file: !296, line: 337)
!330 = !DISubprogram(name: "log10", scope: !293, file: !293, line: 107, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!331 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !332, file: !296, line: 356)
!332 = !DISubprogram(name: "modf", scope: !293, file: !293, line: 110, type: !333, flags: DIFlagPrototyped, spFlags: 0)
!333 = !DISubroutineType(types: !334)
!334 = !{!239, !239, !335}
!335 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !239, size: 64)
!336 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !337, file: !296, line: 368)
!337 = !DISubprogram(name: "pow", scope: !293, file: !293, line: 140, type: !303, flags: DIFlagPrototyped, spFlags: 0)
!338 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !339, file: !296, line: 396)
!339 = !DISubprogram(name: "sin", scope: !293, file: !293, line: 64, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!340 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !341, file: !296, line: 415)
!341 = !DISubprogram(name: "sinh", scope: !293, file: !293, line: 73, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!342 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !343, file: !296, line: 434)
!343 = !DISubprogram(name: "sqrt", scope: !293, file: !293, line: 143, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!344 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !345, file: !296, line: 453)
!345 = !DISubprogram(name: "tan", scope: !293, file: !293, line: 66, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!346 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !347, file: !296, line: 472)
!347 = !DISubprogram(name: "tanh", scope: !293, file: !293, line: 75, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!348 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !349, file: !296, line: 1881)
!349 = !DIDerivedType(tag: DW_TAG_typedef, name: "double_t", file: !350, line: 150, baseType: !239)
!350 = !DIFile(filename: "/usr/include/math.h", directory: "")
!351 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !352, file: !296, line: 1882)
!352 = !DIDerivedType(tag: DW_TAG_typedef, name: "float_t", file: !350, line: 149, baseType: !103)
!353 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !354, file: !296, line: 1885)
!354 = !DISubprogram(name: "acosh", scope: !293, file: !293, line: 85, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!355 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !356, file: !296, line: 1886)
!356 = !DISubprogram(name: "acoshf", scope: !293, file: !293, line: 85, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!357 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !358, file: !296, line: 1887)
!358 = !DISubprogram(name: "acoshl", scope: !293, file: !293, line: 85, type: !359, flags: DIFlagPrototyped, spFlags: 0)
!359 = !DISubroutineType(types: !360)
!360 = !{!361, !361}
!361 = !DIBasicType(name: "long double", size: 64, encoding: DW_ATE_float)
!362 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !363, file: !296, line: 1889)
!363 = !DISubprogram(name: "asinh", scope: !293, file: !293, line: 87, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!364 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !365, file: !296, line: 1890)
!365 = !DISubprogram(name: "asinhf", scope: !293, file: !293, line: 87, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!366 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !367, file: !296, line: 1891)
!367 = !DISubprogram(name: "asinhl", scope: !293, file: !293, line: 87, type: !359, flags: DIFlagPrototyped, spFlags: 0)
!368 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !369, file: !296, line: 1893)
!369 = !DISubprogram(name: "atanh", scope: !293, file: !293, line: 89, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!370 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !371, file: !296, line: 1894)
!371 = !DISubprogram(name: "atanhf", scope: !293, file: !293, line: 89, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!372 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !373, file: !296, line: 1895)
!373 = !DISubprogram(name: "atanhl", scope: !293, file: !293, line: 89, type: !359, flags: DIFlagPrototyped, spFlags: 0)
!374 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !375, file: !296, line: 1897)
!375 = !DISubprogram(name: "cbrt", scope: !293, file: !293, line: 152, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!376 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !377, file: !296, line: 1898)
!377 = !DISubprogram(name: "cbrtf", scope: !293, file: !293, line: 152, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!378 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !379, file: !296, line: 1899)
!379 = !DISubprogram(name: "cbrtl", scope: !293, file: !293, line: 152, type: !359, flags: DIFlagPrototyped, spFlags: 0)
!380 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !381, file: !296, line: 1901)
!381 = !DISubprogram(name: "copysign", scope: !293, file: !293, line: 196, type: !303, flags: DIFlagPrototyped, spFlags: 0)
!382 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !383, file: !296, line: 1902)
!383 = !DISubprogram(name: "copysignf", scope: !293, file: !293, line: 196, type: !114, flags: DIFlagPrototyped, spFlags: 0)
!384 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !385, file: !296, line: 1903)
!385 = !DISubprogram(name: "copysignl", scope: !293, file: !293, line: 196, type: !386, flags: DIFlagPrototyped, spFlags: 0)
!386 = !DISubroutineType(types: !387)
!387 = !{!361, !361, !361}
!388 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !389, file: !296, line: 1905)
!389 = !DISubprogram(name: "erf", scope: !293, file: !293, line: 228, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!390 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !391, file: !296, line: 1906)
!391 = !DISubprogram(name: "erff", scope: !293, file: !293, line: 228, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!392 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !393, file: !296, line: 1907)
!393 = !DISubprogram(name: "erfl", scope: !293, file: !293, line: 228, type: !359, flags: DIFlagPrototyped, spFlags: 0)
!394 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !395, file: !296, line: 1909)
!395 = !DISubprogram(name: "erfc", scope: !293, file: !293, line: 229, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!396 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !397, file: !296, line: 1910)
!397 = !DISubprogram(name: "erfcf", scope: !293, file: !293, line: 229, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!398 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !399, file: !296, line: 1911)
!399 = !DISubprogram(name: "erfcl", scope: !293, file: !293, line: 229, type: !359, flags: DIFlagPrototyped, spFlags: 0)
!400 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !401, file: !296, line: 1913)
!401 = !DISubprogram(name: "exp2", scope: !293, file: !293, line: 130, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!402 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !403, file: !296, line: 1914)
!403 = !DISubprogram(name: "exp2f", scope: !293, file: !293, line: 130, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!404 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !405, file: !296, line: 1915)
!405 = !DISubprogram(name: "exp2l", scope: !293, file: !293, line: 130, type: !359, flags: DIFlagPrototyped, spFlags: 0)
!406 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !407, file: !296, line: 1917)
!407 = !DISubprogram(name: "expm1", scope: !293, file: !293, line: 119, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!408 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !409, file: !296, line: 1918)
!409 = !DISubprogram(name: "expm1f", scope: !293, file: !293, line: 119, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!410 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !411, file: !296, line: 1919)
!411 = !DISubprogram(name: "expm1l", scope: !293, file: !293, line: 119, type: !359, flags: DIFlagPrototyped, spFlags: 0)
!412 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !413, file: !296, line: 1921)
!413 = !DISubprogram(name: "fdim", scope: !293, file: !293, line: 326, type: !303, flags: DIFlagPrototyped, spFlags: 0)
!414 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !415, file: !296, line: 1922)
!415 = !DISubprogram(name: "fdimf", scope: !293, file: !293, line: 326, type: !114, flags: DIFlagPrototyped, spFlags: 0)
!416 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !417, file: !296, line: 1923)
!417 = !DISubprogram(name: "fdiml", scope: !293, file: !293, line: 326, type: !386, flags: DIFlagPrototyped, spFlags: 0)
!418 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !419, file: !296, line: 1925)
!419 = !DISubprogram(name: "fma", scope: !293, file: !293, line: 335, type: !420, flags: DIFlagPrototyped, spFlags: 0)
!420 = !DISubroutineType(types: !421)
!421 = !{!239, !239, !239, !239}
!422 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !423, file: !296, line: 1926)
!423 = !DISubprogram(name: "fmaf", scope: !293, file: !293, line: 335, type: !146, flags: DIFlagPrototyped, spFlags: 0)
!424 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !425, file: !296, line: 1927)
!425 = !DISubprogram(name: "fmal", scope: !293, file: !293, line: 335, type: !426, flags: DIFlagPrototyped, spFlags: 0)
!426 = !DISubroutineType(types: !427)
!427 = !{!361, !361, !361, !361}
!428 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !429, file: !296, line: 1929)
!429 = !DISubprogram(name: "fmax", scope: !293, file: !293, line: 329, type: !303, flags: DIFlagPrototyped, spFlags: 0)
!430 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !431, file: !296, line: 1930)
!431 = !DISubprogram(name: "fmaxf", scope: !293, file: !293, line: 329, type: !114, flags: DIFlagPrototyped, spFlags: 0)
!432 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !433, file: !296, line: 1931)
!433 = !DISubprogram(name: "fmaxl", scope: !293, file: !293, line: 329, type: !386, flags: DIFlagPrototyped, spFlags: 0)
!434 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !435, file: !296, line: 1933)
!435 = !DISubprogram(name: "fmin", scope: !293, file: !293, line: 332, type: !303, flags: DIFlagPrototyped, spFlags: 0)
!436 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !437, file: !296, line: 1934)
!437 = !DISubprogram(name: "fminf", scope: !293, file: !293, line: 332, type: !114, flags: DIFlagPrototyped, spFlags: 0)
!438 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !439, file: !296, line: 1935)
!439 = !DISubprogram(name: "fminl", scope: !293, file: !293, line: 332, type: !386, flags: DIFlagPrototyped, spFlags: 0)
!440 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !441, file: !296, line: 1937)
!441 = !DISubprogram(name: "hypot", scope: !293, file: !293, line: 147, type: !303, flags: DIFlagPrototyped, spFlags: 0)
!442 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !443, file: !296, line: 1938)
!443 = !DISubprogram(name: "hypotf", scope: !293, file: !293, line: 147, type: !114, flags: DIFlagPrototyped, spFlags: 0)
!444 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !445, file: !296, line: 1939)
!445 = !DISubprogram(name: "hypotl", scope: !293, file: !293, line: 147, type: !386, flags: DIFlagPrototyped, spFlags: 0)
!446 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !447, file: !296, line: 1941)
!447 = !DISubprogram(name: "ilogb", scope: !293, file: !293, line: 280, type: !448, flags: DIFlagPrototyped, spFlags: 0)
!448 = !DISubroutineType(types: !449)
!449 = !{!98, !239}
!450 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !451, file: !296, line: 1942)
!451 = !DISubprogram(name: "ilogbf", scope: !293, file: !293, line: 280, type: !156, flags: DIFlagPrototyped, spFlags: 0)
!452 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !453, file: !296, line: 1943)
!453 = !DISubprogram(name: "ilogbl", scope: !293, file: !293, line: 280, type: !454, flags: DIFlagPrototyped, spFlags: 0)
!454 = !DISubroutineType(types: !455)
!455 = !{!98, !361}
!456 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !457, file: !296, line: 1945)
!457 = !DISubprogram(name: "lgamma", scope: !293, file: !293, line: 230, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!458 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !459, file: !296, line: 1946)
!459 = !DISubprogram(name: "lgammaf", scope: !293, file: !293, line: 230, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!460 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !461, file: !296, line: 1947)
!461 = !DISubprogram(name: "lgammal", scope: !293, file: !293, line: 230, type: !359, flags: DIFlagPrototyped, spFlags: 0)
!462 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !463, file: !296, line: 1950)
!463 = !DISubprogram(name: "llrint", scope: !293, file: !293, line: 316, type: !464, flags: DIFlagPrototyped, spFlags: 0)
!464 = !DISubroutineType(types: !465)
!465 = !{!207, !239}
!466 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !467, file: !296, line: 1951)
!467 = !DISubprogram(name: "llrintf", scope: !293, file: !293, line: 316, type: !210, flags: DIFlagPrototyped, spFlags: 0)
!468 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !469, file: !296, line: 1952)
!469 = !DISubprogram(name: "llrintl", scope: !293, file: !293, line: 316, type: !470, flags: DIFlagPrototyped, spFlags: 0)
!470 = !DISubroutineType(types: !471)
!471 = !{!207, !361}
!472 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !473, file: !296, line: 1954)
!473 = !DISubprogram(name: "llround", scope: !293, file: !293, line: 322, type: !464, flags: DIFlagPrototyped, spFlags: 0)
!474 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !475, file: !296, line: 1955)
!475 = !DISubprogram(name: "llroundf", scope: !293, file: !293, line: 322, type: !210, flags: DIFlagPrototyped, spFlags: 0)
!476 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !477, file: !296, line: 1956)
!477 = !DISubprogram(name: "llroundl", scope: !293, file: !293, line: 322, type: !470, flags: DIFlagPrototyped, spFlags: 0)
!478 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !479, file: !296, line: 1959)
!479 = !DISubprogram(name: "log1p", scope: !293, file: !293, line: 122, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!480 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !481, file: !296, line: 1960)
!481 = !DISubprogram(name: "log1pf", scope: !293, file: !293, line: 122, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!482 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !483, file: !296, line: 1961)
!483 = !DISubprogram(name: "log1pl", scope: !293, file: !293, line: 122, type: !359, flags: DIFlagPrototyped, spFlags: 0)
!484 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !485, file: !296, line: 1963)
!485 = !DISubprogram(name: "log2", scope: !293, file: !293, line: 133, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!486 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !487, file: !296, line: 1964)
!487 = !DISubprogram(name: "log2f", scope: !293, file: !293, line: 133, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!488 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !489, file: !296, line: 1965)
!489 = !DISubprogram(name: "log2l", scope: !293, file: !293, line: 133, type: !359, flags: DIFlagPrototyped, spFlags: 0)
!490 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !491, file: !296, line: 1967)
!491 = !DISubprogram(name: "logb", scope: !293, file: !293, line: 125, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!492 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !493, file: !296, line: 1968)
!493 = !DISubprogram(name: "logbf", scope: !293, file: !293, line: 125, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!494 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !495, file: !296, line: 1969)
!495 = !DISubprogram(name: "logbl", scope: !293, file: !293, line: 125, type: !359, flags: DIFlagPrototyped, spFlags: 0)
!496 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !497, file: !296, line: 1971)
!497 = !DISubprogram(name: "lrint", scope: !293, file: !293, line: 314, type: !498, flags: DIFlagPrototyped, spFlags: 0)
!498 = !DISubroutineType(types: !499)
!499 = !{!196, !239}
!500 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !501, file: !296, line: 1972)
!501 = !DISubprogram(name: "lrintf", scope: !293, file: !293, line: 314, type: !224, flags: DIFlagPrototyped, spFlags: 0)
!502 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !503, file: !296, line: 1973)
!503 = !DISubprogram(name: "lrintl", scope: !293, file: !293, line: 314, type: !504, flags: DIFlagPrototyped, spFlags: 0)
!504 = !DISubroutineType(types: !505)
!505 = !{!196, !361}
!506 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !507, file: !296, line: 1975)
!507 = !DISubprogram(name: "lround", scope: !293, file: !293, line: 320, type: !498, flags: DIFlagPrototyped, spFlags: 0)
!508 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !509, file: !296, line: 1976)
!509 = !DISubprogram(name: "lroundf", scope: !293, file: !293, line: 320, type: !224, flags: DIFlagPrototyped, spFlags: 0)
!510 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !511, file: !296, line: 1977)
!511 = !DISubprogram(name: "lroundl", scope: !293, file: !293, line: 320, type: !504, flags: DIFlagPrototyped, spFlags: 0)
!512 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !513, file: !296, line: 1979)
!513 = !DISubprogram(name: "nan", scope: !293, file: !293, line: 201, type: !237, flags: DIFlagPrototyped, spFlags: 0)
!514 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !515, file: !296, line: 1980)
!515 = !DISubprogram(name: "nanf", scope: !293, file: !293, line: 201, type: !245, flags: DIFlagPrototyped, spFlags: 0)
!516 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !517, file: !296, line: 1981)
!517 = !DISubprogram(name: "nanl", scope: !293, file: !293, line: 201, type: !518, flags: DIFlagPrototyped, spFlags: 0)
!518 = !DISubroutineType(types: !519)
!519 = !{!361, !240}
!520 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !521, file: !296, line: 1983)
!521 = !DISubprogram(name: "nearbyint", scope: !293, file: !293, line: 294, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!522 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !523, file: !296, line: 1984)
!523 = !DISubprogram(name: "nearbyintf", scope: !293, file: !293, line: 294, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!524 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !525, file: !296, line: 1985)
!525 = !DISubprogram(name: "nearbyintl", scope: !293, file: !293, line: 294, type: !359, flags: DIFlagPrototyped, spFlags: 0)
!526 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !527, file: !296, line: 1987)
!527 = !DISubprogram(name: "nextafter", scope: !293, file: !293, line: 259, type: !303, flags: DIFlagPrototyped, spFlags: 0)
!528 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !529, file: !296, line: 1988)
!529 = !DISubprogram(name: "nextafterf", scope: !293, file: !293, line: 259, type: !114, flags: DIFlagPrototyped, spFlags: 0)
!530 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !531, file: !296, line: 1989)
!531 = !DISubprogram(name: "nextafterl", scope: !293, file: !293, line: 259, type: !386, flags: DIFlagPrototyped, spFlags: 0)
!532 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !533, file: !296, line: 1991)
!533 = !DISubprogram(name: "nexttoward", scope: !293, file: !293, line: 261, type: !534, flags: DIFlagPrototyped, spFlags: 0)
!534 = !DISubroutineType(types: !535)
!535 = !{!239, !239, !361}
!536 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !537, file: !296, line: 1992)
!537 = !DISubprogram(name: "nexttowardf", scope: !293, file: !293, line: 261, type: !538, flags: DIFlagPrototyped, spFlags: 0)
!538 = !DISubroutineType(types: !539)
!539 = !{!103, !103, !361}
!540 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !541, file: !296, line: 1993)
!541 = !DISubprogram(name: "nexttowardl", scope: !293, file: !293, line: 261, type: !386, flags: DIFlagPrototyped, spFlags: 0)
!542 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !543, file: !296, line: 1995)
!543 = !DISubprogram(name: "remainder", scope: !293, file: !293, line: 272, type: !303, flags: DIFlagPrototyped, spFlags: 0)
!544 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !545, file: !296, line: 1996)
!545 = !DISubprogram(name: "remainderf", scope: !293, file: !293, line: 272, type: !114, flags: DIFlagPrototyped, spFlags: 0)
!546 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !547, file: !296, line: 1997)
!547 = !DISubprogram(name: "remainderl", scope: !293, file: !293, line: 272, type: !386, flags: DIFlagPrototyped, spFlags: 0)
!548 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !549, file: !296, line: 1999)
!549 = !DISubprogram(name: "remquo", scope: !293, file: !293, line: 307, type: !550, flags: DIFlagPrototyped, spFlags: 0)
!550 = !DISubroutineType(types: !551)
!551 = !{!239, !239, !239, !162}
!552 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !553, file: !296, line: 2000)
!553 = !DISubprogram(name: "remquof", scope: !293, file: !293, line: 307, type: !257, flags: DIFlagPrototyped, spFlags: 0)
!554 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !555, file: !296, line: 2001)
!555 = !DISubprogram(name: "remquol", scope: !293, file: !293, line: 307, type: !556, flags: DIFlagPrototyped, spFlags: 0)
!556 = !DISubroutineType(types: !557)
!557 = !{!361, !361, !361, !162}
!558 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !559, file: !296, line: 2003)
!559 = !DISubprogram(name: "rint", scope: !293, file: !293, line: 256, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!560 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !561, file: !296, line: 2004)
!561 = !DISubprogram(name: "rintf", scope: !293, file: !293, line: 256, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!562 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !563, file: !296, line: 2005)
!563 = !DISubprogram(name: "rintl", scope: !293, file: !293, line: 256, type: !359, flags: DIFlagPrototyped, spFlags: 0)
!564 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !565, file: !296, line: 2007)
!565 = !DISubprogram(name: "round", scope: !293, file: !293, line: 298, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!566 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !567, file: !296, line: 2008)
!567 = !DISubprogram(name: "roundf", scope: !293, file: !293, line: 298, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!568 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !569, file: !296, line: 2009)
!569 = !DISubprogram(name: "roundl", scope: !293, file: !293, line: 298, type: !359, flags: DIFlagPrototyped, spFlags: 0)
!570 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !571, file: !296, line: 2011)
!571 = !DISubprogram(name: "scalbln", scope: !293, file: !293, line: 290, type: !572, flags: DIFlagPrototyped, spFlags: 0)
!572 = !DISubroutineType(types: !573)
!573 = !{!239, !239, !196}
!574 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !575, file: !296, line: 2012)
!575 = !DISubprogram(name: "scalblnf", scope: !293, file: !293, line: 290, type: !265, flags: DIFlagPrototyped, spFlags: 0)
!576 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !577, file: !296, line: 2013)
!577 = !DISubprogram(name: "scalblnl", scope: !293, file: !293, line: 290, type: !578, flags: DIFlagPrototyped, spFlags: 0)
!578 = !DISubroutineType(types: !579)
!579 = !{!361, !361, !196}
!580 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !581, file: !296, line: 2015)
!581 = !DISubprogram(name: "scalbn", scope: !293, file: !293, line: 276, type: !325, flags: DIFlagPrototyped, spFlags: 0)
!582 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !583, file: !296, line: 2016)
!583 = !DISubprogram(name: "scalbnf", scope: !293, file: !293, line: 276, type: !199, flags: DIFlagPrototyped, spFlags: 0)
!584 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !585, file: !296, line: 2017)
!585 = !DISubprogram(name: "scalbnl", scope: !293, file: !293, line: 276, type: !586, flags: DIFlagPrototyped, spFlags: 0)
!586 = !DISubroutineType(types: !587)
!587 = !{!361, !361, !98}
!588 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !589, file: !296, line: 2019)
!589 = !DISubprogram(name: "tgamma", scope: !293, file: !293, line: 235, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!590 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !591, file: !296, line: 2020)
!591 = !DISubprogram(name: "tgammaf", scope: !293, file: !293, line: 235, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!592 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !593, file: !296, line: 2021)
!593 = !DISubprogram(name: "tgammal", scope: !293, file: !293, line: 235, type: !359, flags: DIFlagPrototyped, spFlags: 0)
!594 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !595, file: !296, line: 2023)
!595 = !DISubprogram(name: "trunc", scope: !293, file: !293, line: 302, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!596 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !597, file: !296, line: 2024)
!597 = !DISubprogram(name: "truncf", scope: !293, file: !293, line: 302, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!598 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !599, file: !296, line: 2025)
!599 = !DISubprogram(name: "truncl", scope: !293, file: !293, line: 302, type: !359, flags: DIFlagPrototyped, spFlags: 0)
!600 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !601, entity: !602, file: !603, line: 58)
!601 = !DINamespace(name: "__gnu_debug", scope: null)
!602 = !DINamespace(name: "__debug", scope: !93)
!603 = !DIFile(filename: "/opt/rh/gcc-toolset-13/root/usr/lib/gcc/x86_64-redhat-linux/13/../../../../include/c++/13/debug/debug.h", directory: "")
!604 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !605, file: !607, line: 131)
!605 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !289, line: 62, baseType: !606)
!606 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !289, line: 58, size: 64, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!607 = !DIFile(filename: "/opt/rh/gcc-toolset-13/root/usr/lib/gcc/x86_64-redhat-linux/13/../../../../include/c++/13/cstdlib", directory: "")
!608 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !609, file: !607, line: 132)
!609 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !289, line: 70, baseType: !610)
!610 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !289, line: 66, size: 128, flags: DIFlagTypePassByValue, elements: !611, identifier: "_ZTS6ldiv_t")
!611 = !{!612, !613}
!612 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !610, file: !289, line: 68, baseType: !196, size: 64)
!613 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !610, file: !289, line: 69, baseType: !196, size: 64, offset: 64)
!614 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !615, file: !607, line: 134)
!615 = !DISubprogram(name: "abort", scope: !289, file: !289, line: 588, type: !616, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!616 = !DISubroutineType(types: !617)
!617 = !{null}
!618 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !619, file: !607, line: 136)
!619 = !DISubprogram(name: "aligned_alloc", scope: !289, file: !289, line: 583, type: !620, flags: DIFlagPrototyped, spFlags: 0)
!620 = !DISubroutineType(types: !621)
!621 = !{!622, !623, !623}
!622 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!623 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !624, line: 18, baseType: !625)
!624 = !DIFile(filename: "/storage/users/sislam3/opt/llvm-22/lib/clang/22/include/__stddef_size_t.h", directory: "")
!625 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!626 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !627, file: !607, line: 138)
!627 = !DISubprogram(name: "atexit", scope: !289, file: !289, line: 592, type: !628, flags: DIFlagPrototyped, spFlags: 0)
!628 = !DISubroutineType(types: !629)
!629 = !{!98, !630}
!630 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !616, size: 64)
!631 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !632, file: !607, line: 141)
!632 = !DISubprogram(name: "at_quick_exit", scope: !289, file: !289, line: 597, type: !628, flags: DIFlagPrototyped, spFlags: 0)
!633 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !634, file: !607, line: 144)
!634 = !DISubprogram(name: "atof", scope: !289, file: !289, line: 101, type: !237, flags: DIFlagPrototyped, spFlags: 0)
!635 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !636, file: !607, line: 145)
!636 = !DISubprogram(name: "atoi", scope: !289, file: !289, line: 104, type: !637, flags: DIFlagPrototyped, spFlags: 0)
!637 = !DISubroutineType(types: !638)
!638 = !{!98, !240}
!639 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !640, file: !607, line: 146)
!640 = !DISubprogram(name: "atol", scope: !289, file: !289, line: 107, type: !641, flags: DIFlagPrototyped, spFlags: 0)
!641 = !DISubroutineType(types: !642)
!642 = !{!196, !240}
!643 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !644, file: !607, line: 147)
!644 = !DISubprogram(name: "bsearch", scope: !289, file: !289, line: 817, type: !645, flags: DIFlagPrototyped, spFlags: 0)
!645 = !DISubroutineType(types: !646)
!646 = !{!622, !647, !647, !623, !623, !649}
!647 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !648, size: 64)
!648 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!649 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !289, line: 805, baseType: !650)
!650 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !651, size: 64)
!651 = !DISubroutineType(types: !652)
!652 = !{!98, !647, !647}
!653 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !654, file: !607, line: 148)
!654 = !DISubprogram(name: "calloc", scope: !289, file: !289, line: 541, type: !620, flags: DIFlagPrototyped, spFlags: 0)
!655 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !656, file: !607, line: 149)
!656 = !DISubprogram(name: "div", scope: !289, file: !289, line: 849, type: !657, flags: DIFlagPrototyped, spFlags: 0)
!657 = !DISubroutineType(types: !658)
!658 = !{!605, !98, !98}
!659 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !660, file: !607, line: 150)
!660 = !DISubprogram(name: "exit", scope: !289, file: !289, line: 614, type: !661, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!661 = !DISubroutineType(types: !662)
!662 = !{null, !98}
!663 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !664, file: !607, line: 151)
!664 = !DISubprogram(name: "free", scope: !289, file: !289, line: 563, type: !665, flags: DIFlagPrototyped, spFlags: 0)
!665 = !DISubroutineType(types: !666)
!666 = !{null, !622}
!667 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !668, file: !607, line: 152)
!668 = !DISubprogram(name: "getenv", scope: !289, file: !289, line: 631, type: !669, flags: DIFlagPrototyped, spFlags: 0)
!669 = !DISubroutineType(types: !670)
!670 = !{!671, !240}
!671 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !242, size: 64)
!672 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !673, file: !607, line: 153)
!673 = !DISubprogram(name: "labs", scope: !289, file: !289, line: 838, type: !194, flags: DIFlagPrototyped, spFlags: 0)
!674 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !675, file: !607, line: 154)
!675 = !DISubprogram(name: "ldiv", scope: !289, file: !289, line: 851, type: !676, flags: DIFlagPrototyped, spFlags: 0)
!676 = !DISubroutineType(types: !677)
!677 = !{!609, !196, !196}
!678 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !679, file: !607, line: 155)
!679 = !DISubprogram(name: "malloc", scope: !289, file: !289, line: 539, type: !680, flags: DIFlagPrototyped, spFlags: 0)
!680 = !DISubroutineType(types: !681)
!681 = !{!622, !623}
!682 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !683, file: !607, line: 157)
!683 = !DISubprogram(name: "mblen", scope: !289, file: !289, line: 919, type: !684, flags: DIFlagPrototyped, spFlags: 0)
!684 = !DISubroutineType(types: !685)
!685 = !{!98, !240, !623}
!686 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !687, file: !607, line: 158)
!687 = !DISubprogram(name: "mbstowcs", scope: !289, file: !289, line: 930, type: !688, flags: DIFlagPrototyped, spFlags: 0)
!688 = !DISubroutineType(types: !689)
!689 = !{!623, !690, !693, !623}
!690 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !691)
!691 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !692, size: 64)
!692 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!693 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !240)
!694 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !695, file: !607, line: 159)
!695 = !DISubprogram(name: "mbtowc", scope: !289, file: !289, line: 922, type: !696, flags: DIFlagPrototyped, spFlags: 0)
!696 = !DISubroutineType(types: !697)
!697 = !{!98, !690, !693, !623}
!698 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !699, file: !607, line: 161)
!699 = !DISubprogram(name: "qsort", scope: !289, file: !289, line: 827, type: !700, flags: DIFlagPrototyped, spFlags: 0)
!700 = !DISubroutineType(types: !701)
!701 = !{null, !622, !623, !623, !649}
!702 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !703, file: !607, line: 164)
!703 = !DISubprogram(name: "quick_exit", scope: !289, file: !289, line: 620, type: !661, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!704 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !705, file: !607, line: 167)
!705 = !DISubprogram(name: "rand", scope: !289, file: !289, line: 453, type: !706, flags: DIFlagPrototyped, spFlags: 0)
!706 = !DISubroutineType(types: !707)
!707 = !{!98}
!708 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !709, file: !607, line: 168)
!709 = !DISubprogram(name: "realloc", scope: !289, file: !289, line: 549, type: !710, flags: DIFlagPrototyped, spFlags: 0)
!710 = !DISubroutineType(types: !711)
!711 = !{!622, !622, !623}
!712 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !713, file: !607, line: 169)
!713 = !DISubprogram(name: "srand", scope: !289, file: !289, line: 455, type: !714, flags: DIFlagPrototyped, spFlags: 0)
!714 = !DISubroutineType(types: !715)
!715 = !{null, !39}
!716 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !717, file: !607, line: 170)
!717 = !DISubprogram(name: "strtod", scope: !289, file: !289, line: 117, type: !718, flags: DIFlagPrototyped, spFlags: 0)
!718 = !DISubroutineType(types: !719)
!719 = !{!239, !693, !720}
!720 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !721)
!721 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !671, size: 64)
!722 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !723, file: !607, line: 171)
!723 = !DISubprogram(name: "strtol", scope: !289, file: !289, line: 176, type: !724, flags: DIFlagPrototyped, spFlags: 0)
!724 = !DISubroutineType(types: !725)
!725 = !{!196, !693, !720, !98}
!726 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !727, file: !607, line: 172)
!727 = !DISubprogram(name: "strtoul", scope: !289, file: !289, line: 180, type: !728, flags: DIFlagPrototyped, spFlags: 0)
!728 = !DISubroutineType(types: !729)
!729 = !{!625, !693, !720, !98}
!730 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !731, file: !607, line: 173)
!731 = !DISubprogram(name: "system", scope: !289, file: !289, line: 781, type: !637, flags: DIFlagPrototyped, spFlags: 0)
!732 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !733, file: !607, line: 175)
!733 = !DISubprogram(name: "wcstombs", scope: !289, file: !289, line: 933, type: !734, flags: DIFlagPrototyped, spFlags: 0)
!734 = !DISubroutineType(types: !735)
!735 = !{!623, !736, !737, !623}
!736 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !671)
!737 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !738)
!738 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !739, size: 64)
!739 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !692)
!740 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !741, file: !607, line: 176)
!741 = !DISubprogram(name: "wctomb", scope: !289, file: !289, line: 926, type: !742, flags: DIFlagPrototyped, spFlags: 0)
!742 = !DISubroutineType(types: !743)
!743 = !{!98, !671, !692}
!744 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !745, entity: !746, file: !607, line: 204)
!745 = !DINamespace(name: "__gnu_cxx", scope: null)
!746 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !289, line: 80, baseType: !747)
!747 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !289, line: 76, size: 128, flags: DIFlagTypePassByValue, elements: !748, identifier: "_ZTS7lldiv_t")
!748 = !{!749, !750}
!749 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !747, file: !289, line: 78, baseType: !207, size: 64)
!750 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !747, file: !289, line: 79, baseType: !207, size: 64, offset: 64)
!751 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !745, entity: !752, file: !607, line: 210)
!752 = !DISubprogram(name: "_Exit", scope: !289, file: !289, line: 626, type: !661, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!753 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !745, entity: !754, file: !607, line: 214)
!754 = !DISubprogram(name: "llabs", scope: !289, file: !289, line: 841, type: !205, flags: DIFlagPrototyped, spFlags: 0)
!755 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !745, entity: !756, file: !607, line: 220)
!756 = !DISubprogram(name: "lldiv", scope: !289, file: !289, line: 855, type: !757, flags: DIFlagPrototyped, spFlags: 0)
!757 = !DISubroutineType(types: !758)
!758 = !{!746, !207, !207}
!759 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !745, entity: !760, file: !607, line: 231)
!760 = !DISubprogram(name: "atoll", scope: !289, file: !289, line: 112, type: !761, flags: DIFlagPrototyped, spFlags: 0)
!761 = !DISubroutineType(types: !762)
!762 = !{!207, !240}
!763 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !745, entity: !764, file: !607, line: 232)
!764 = !DISubprogram(name: "strtoll", scope: !289, file: !289, line: 200, type: !765, flags: DIFlagPrototyped, spFlags: 0)
!765 = !DISubroutineType(types: !766)
!766 = !{!207, !693, !720, !98}
!767 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !745, entity: !768, file: !607, line: 233)
!768 = !DISubprogram(name: "strtoull", scope: !289, file: !289, line: 205, type: !769, flags: DIFlagPrototyped, spFlags: 0)
!769 = !DISubroutineType(types: !770)
!770 = !{!9, !693, !720, !98}
!771 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !745, entity: !772, file: !607, line: 235)
!772 = !DISubprogram(name: "strtof", scope: !289, file: !289, line: 123, type: !773, flags: DIFlagPrototyped, spFlags: 0)
!773 = !DISubroutineType(types: !774)
!774 = !{!103, !693, !720}
!775 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !745, entity: !776, file: !607, line: 236)
!776 = !DISubprogram(name: "strtold", scope: !289, file: !289, line: 126, type: !777, flags: DIFlagPrototyped, spFlags: 0)
!777 = !DISubroutineType(types: !778)
!778 = !{!361, !693, !720}
!779 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !746, file: !607, line: 244)
!780 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !752, file: !607, line: 246)
!781 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !754, file: !607, line: 248)
!782 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !783, file: !607, line: 249)
!783 = !DISubprogram(name: "div", linkageName: "_ZN9__gnu_cxx3divExx", scope: !745, file: !607, line: 217, type: !757, flags: DIFlagPrototyped, spFlags: 0)
!784 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !756, file: !607, line: 250)
!785 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !760, file: !607, line: 252)
!786 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !772, file: !607, line: 253)
!787 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !764, file: !607, line: 254)
!788 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !768, file: !607, line: 255)
!789 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !776, file: !607, line: 256)
!790 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !615, file: !791, line: 38)
!791 = !DIFile(filename: "/opt/rh/gcc-toolset-13/root/usr/lib/gcc/x86_64-redhat-linux/13/../../../../include/c++/13/stdlib.h", directory: "")
!792 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !627, file: !791, line: 39)
!793 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !660, file: !791, line: 40)
!794 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !632, file: !791, line: 43)
!795 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !703, file: !791, line: 46)
!796 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !752, file: !791, line: 49)
!797 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !605, file: !791, line: 54)
!798 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !609, file: !791, line: 55)
!799 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !800, file: !791, line: 57)
!800 = !DISubprogram(name: "abs", linkageName: "_ZSt3absg", scope: !93, file: !290, line: 137, type: !801, flags: DIFlagPrototyped, spFlags: 0)
!801 = !DISubroutineType(types: !802)
!802 = !{!803, !803}
!803 = !DIBasicType(name: "__float128", size: 128, encoding: DW_ATE_float)
!804 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !634, file: !791, line: 58)
!805 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !636, file: !791, line: 59)
!806 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !640, file: !791, line: 60)
!807 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !644, file: !791, line: 61)
!808 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !654, file: !791, line: 62)
!809 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !783, file: !791, line: 63)
!810 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !664, file: !791, line: 64)
!811 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !668, file: !791, line: 65)
!812 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !673, file: !791, line: 66)
!813 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !675, file: !791, line: 67)
!814 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !679, file: !791, line: 68)
!815 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !683, file: !791, line: 70)
!816 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !687, file: !791, line: 71)
!817 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !695, file: !791, line: 72)
!818 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !699, file: !791, line: 74)
!819 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !705, file: !791, line: 75)
!820 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !709, file: !791, line: 76)
!821 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !713, file: !791, line: 77)
!822 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !717, file: !791, line: 78)
!823 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !723, file: !791, line: 79)
!824 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !727, file: !791, line: 80)
!825 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !731, file: !791, line: 81)
!826 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !733, file: !791, line: 83)
!827 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !741, file: !791, line: 84)
!828 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !829, file: !271, line: 443)
!829 = !DISubprogram(name: "acosf", linkageName: "_ZL5acosff", scope: !830, file: !830, line: 63, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!830 = !DIFile(filename: "/storage/users/sislam3/opt/llvm-22/lib/clang/22/include/__clang_cuda_math.h", directory: "")
!831 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !832, file: !271, line: 444)
!832 = !DISubprogram(name: "acoshf", linkageName: "_ZL6acoshff", scope: !830, file: !830, line: 65, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!833 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !834, file: !271, line: 445)
!834 = !DISubprogram(name: "asinf", linkageName: "_ZL5asinff", scope: !830, file: !830, line: 67, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!835 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !836, file: !271, line: 446)
!836 = !DISubprogram(name: "asinhf", linkageName: "_ZL6asinhff", scope: !830, file: !830, line: 69, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!837 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !838, file: !271, line: 447)
!838 = !DISubprogram(name: "atan2f", linkageName: "_ZL6atan2fff", scope: !830, file: !830, line: 72, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!839 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !840, file: !271, line: 448)
!840 = !DISubprogram(name: "atanf", linkageName: "_ZL5atanff", scope: !830, file: !830, line: 73, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!841 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !842, file: !271, line: 449)
!842 = !DISubprogram(name: "atanhf", linkageName: "_ZL6atanhff", scope: !830, file: !830, line: 75, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!843 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !844, file: !271, line: 450)
!844 = !DISubprogram(name: "cbrtf", linkageName: "_ZL5cbrtff", scope: !830, file: !830, line: 77, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!845 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !846, file: !271, line: 451)
!846 = !DISubprogram(name: "ceilf", linkageName: "_ZL5ceilff", scope: !830, file: !830, line: 79, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!847 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !848, file: !271, line: 452)
!848 = !DISubprogram(name: "copysignf", linkageName: "_ZL9copysignfff", scope: !830, file: !830, line: 83, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!849 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !850, file: !271, line: 453)
!850 = !DISubprogram(name: "cosf", linkageName: "_ZL4cosff", scope: !830, file: !830, line: 87, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!851 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !852, file: !271, line: 454)
!852 = !DISubprogram(name: "coshf", linkageName: "_ZL5coshff", scope: !830, file: !830, line: 91, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!853 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !854, file: !271, line: 455)
!854 = !DISubprogram(name: "erfcf", linkageName: "_ZL5erfcff", scope: !830, file: !830, line: 100, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!855 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !856, file: !271, line: 456)
!856 = !DISubprogram(name: "erff", linkageName: "_ZL4erfff", scope: !830, file: !830, line: 105, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!857 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !858, file: !271, line: 457)
!858 = !DISubprogram(name: "exp2f", linkageName: "_ZL5exp2ff", scope: !830, file: !830, line: 112, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!859 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !860, file: !271, line: 458)
!860 = !DISubprogram(name: "expf", linkageName: "_ZL4expff", scope: !830, file: !830, line: 113, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!861 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !862, file: !271, line: 459)
!862 = !DISubprogram(name: "expm1f", linkageName: "_ZL6expm1ff", scope: !830, file: !830, line: 115, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!863 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !864, file: !271, line: 460)
!864 = !DISubprogram(name: "fabsf", linkageName: "_ZL5fabsff", scope: !830, file: !830, line: 116, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!865 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !866, file: !271, line: 461)
!866 = !DISubprogram(name: "fdimf", linkageName: "_ZL5fdimfff", scope: !830, file: !830, line: 118, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!867 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !868, file: !271, line: 462)
!868 = !DISubprogram(name: "floorf", linkageName: "_ZL6floorff", scope: !830, file: !830, line: 128, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!869 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !870, file: !271, line: 463)
!870 = !DISubprogram(name: "fmaf", linkageName: "_ZL4fmaffff", scope: !830, file: !830, line: 132, type: !146, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!871 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !872, file: !271, line: 464)
!872 = !DISubprogram(name: "fmaxf", linkageName: "_ZL5fmaxfff", scope: !830, file: !830, line: 136, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!873 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !874, file: !271, line: 465)
!874 = !DISubprogram(name: "fminf", linkageName: "_ZL5fminfff", scope: !830, file: !830, line: 138, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!875 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !876, file: !271, line: 466)
!876 = !DISubprogram(name: "fmodf", linkageName: "_ZL5fmodfff", scope: !830, file: !830, line: 140, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!877 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !878, file: !271, line: 467)
!878 = !DISubprogram(name: "frexpf", linkageName: "_ZL6frexpffPi", scope: !830, file: !830, line: 142, type: !160, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!879 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !880, file: !271, line: 468)
!880 = !DISubprogram(name: "hypotf", linkageName: "_ZL6hypotfff", scope: !830, file: !830, line: 144, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!881 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !882, file: !271, line: 469)
!882 = !DISubprogram(name: "ilogbf", linkageName: "_ZL6ilogbff", scope: !830, file: !830, line: 146, type: !156, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!883 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !884, file: !271, line: 470)
!884 = !DISubprogram(name: "ldexpf", linkageName: "_ZL6ldexpffi", scope: !830, file: !830, line: 159, type: !199, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!885 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !886, file: !271, line: 471)
!886 = !DISubprogram(name: "lgammaf", linkageName: "_ZL7lgammaff", scope: !830, file: !830, line: 161, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!887 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !888, file: !271, line: 472)
!888 = !DISubprogram(name: "llrintf", linkageName: "_ZL7llrintff", scope: !830, file: !830, line: 170, type: !210, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!889 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !890, file: !271, line: 473)
!890 = !DISubprogram(name: "llroundf", linkageName: "_ZL8llroundff", scope: !830, file: !830, line: 172, type: !210, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!891 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !892, file: !271, line: 474)
!892 = !DISubprogram(name: "log10f", linkageName: "_ZL6log10ff", scope: !830, file: !830, line: 177, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!893 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !894, file: !271, line: 475)
!894 = !DISubprogram(name: "log1pf", linkageName: "_ZL6log1pff", scope: !830, file: !830, line: 179, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!895 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !896, file: !271, line: 476)
!896 = !DISubprogram(name: "log2f", linkageName: "_ZL5log2ff", scope: !830, file: !830, line: 181, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!897 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !898, file: !271, line: 477)
!898 = !DISubprogram(name: "logbf", linkageName: "_ZL5logbff", scope: !830, file: !830, line: 185, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!899 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !900, file: !271, line: 478)
!900 = !DISubprogram(name: "logf", linkageName: "_ZL4logff", scope: !830, file: !830, line: 186, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!901 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !902, file: !271, line: 479)
!902 = !DISubprogram(name: "lrintf", linkageName: "_ZL6lrintff", scope: !830, file: !830, line: 191, type: !224, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!903 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !904, file: !271, line: 480)
!904 = !DISubprogram(name: "lroundf", linkageName: "_ZL7lroundff", scope: !830, file: !830, line: 193, type: !224, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!905 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !906, file: !271, line: 481)
!906 = !DISubprogram(name: "modff", linkageName: "_ZL5modfffPf", scope: !830, file: !830, line: 203, type: !232, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!907 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !908, file: !271, line: 482)
!908 = !DISubprogram(name: "nearbyintf", linkageName: "_ZL10nearbyintff", scope: !830, file: !830, line: 205, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!909 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !910, file: !271, line: 483)
!910 = !DISubprogram(name: "nextafterf", linkageName: "_ZL10nextafterfff", scope: !830, file: !830, line: 209, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!911 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !912, file: !271, line: 484)
!912 = !DISubprogram(name: "powf", linkageName: "_ZL4powfff", scope: !830, file: !830, line: 235, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!913 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !914, file: !271, line: 485)
!914 = !DISubprogram(name: "remainderf", linkageName: "_ZL10remainderfff", scope: !830, file: !830, line: 243, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!915 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !916, file: !271, line: 486)
!916 = !DISubprogram(name: "remquof", linkageName: "_ZL7remquofffPi", scope: !830, file: !830, line: 249, type: !257, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!917 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !918, file: !271, line: 487)
!918 = !DISubprogram(name: "rintf", linkageName: "_ZL5rintff", scope: !830, file: !830, line: 260, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!919 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !920, file: !271, line: 488)
!920 = !DISubprogram(name: "roundf", linkageName: "_ZL6roundff", scope: !830, file: !830, line: 174, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!921 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !922, file: !271, line: 489)
!922 = !DISubprogram(name: "scalblnf", linkageName: "_ZL8scalblnffl", scope: !830, file: !830, line: 290, type: !265, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!923 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !924, file: !271, line: 490)
!924 = !DISubprogram(name: "scalbnf", linkageName: "_ZL7scalbnffi", scope: !830, file: !830, line: 282, type: !199, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!925 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !926, file: !271, line: 491)
!926 = !DISubprogram(name: "sinf", linkageName: "_ZL4sinff", scope: !830, file: !830, line: 310, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!927 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !928, file: !271, line: 492)
!928 = !DISubprogram(name: "sinhf", linkageName: "_ZL5sinhff", scope: !830, file: !830, line: 314, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!929 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !930, file: !271, line: 493)
!930 = !DISubprogram(name: "sqrtf", linkageName: "_ZL5sqrtff", scope: !830, file: !830, line: 318, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!931 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !932, file: !271, line: 494)
!932 = !DISubprogram(name: "tanf", linkageName: "_ZL4tanff", scope: !830, file: !830, line: 320, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!933 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !934, file: !271, line: 495)
!934 = !DISubprogram(name: "tanhf", linkageName: "_ZL5tanhff", scope: !830, file: !830, line: 322, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!935 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !936, file: !271, line: 496)
!936 = !DISubprogram(name: "tgammaf", linkageName: "_ZL7tgammaff", scope: !830, file: !830, line: 324, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!937 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !938, file: !271, line: 497)
!938 = !DISubprogram(name: "truncf", linkageName: "_ZL6truncff", scope: !830, file: !830, line: 326, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!939 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !3, file: !4, line: 181)
!940 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !28, file: !4, line: 182)
!941 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !942, file: !4, line: 208)
!942 = !DISubprogram(name: "is_exactly", linkageName: "_ZN2nv6target6detail10is_exactlyENS1_11sm_selectorE", scope: !5, file: !4, line: 153, type: !943, flags: DIFlagPrototyped, spFlags: 0)
!943 = !DISubroutineType(types: !944)
!944 = !{!28, !3}
!945 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !946, file: !4, line: 209)
!946 = !DISubprogram(name: "provides", linkageName: "_ZN2nv6target6detail8providesENS1_11sm_selectorE", scope: !5, file: !4, line: 158, type: !943, flags: DIFlagPrototyped, spFlags: 0)
!947 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !800, file: !948, line: 38)
!948 = !DIFile(filename: "/opt/rh/gcc-toolset-13/root/usr/lib/gcc/x86_64-redhat-linux/13/../../../../include/c++/13/math.h", directory: "")
!949 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !950, file: !948, line: 54)
!950 = !DISubprogram(name: "modf", linkageName: "_ZSt4modfePe", scope: !93, file: !296, line: 364, type: !951, flags: DIFlagPrototyped, spFlags: 0)
!951 = !DISubroutineType(types: !952)
!952 = !{!361, !361, !953}
!953 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !361, size: 64)
!954 = !{!"clang version 22.1.5 (https://github.com/llvm/llvm-project.git 5ea218a153f4d2f815b8244eab3e4b4ba5e00e6c)"}
!955 = !{!"clang version 3.8.0 (tags/RELEASE_380/final)"}
!956 = !{i32 2, i32 0}
!957 = !{i32 2, !"SDK Version", [2 x i32] [i32 12, i32 8]}
!958 = !{i32 7, !"Dwarf Version", i32 2}
!959 = !{i32 2, !"Debug Info Version", i32 3}
!960 = !{i32 1, !"wchar_size", i32 4}
!961 = !{i32 4, !"nvvm-reflect-ftz", i32 0}
!962 = !{i32 7, !"frame-pointer", i32 2}
!963 = distinct !DISubprogram(name: "testDivByZero", linkageName: "_Z13testDivByZeroPfPiffff", scope: !1, file: !1, line: 5, type: !964, scopeLine: 7, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !272)
!964 = !DISubroutineType(types: !965)
!965 = !{null, !234, !162, !103, !103, !103, !103}
!966 = !DILocalVariable(name: "result", arg: 1, scope: !963, file: !1, line: 5, type: !234)
!967 = !DILocation(line: 5, column: 38, scope: !963)
!968 = !DILocalVariable(name: "sign_check", arg: 2, scope: !963, file: !1, line: 5, type: !162)
!969 = !DILocation(line: 5, column: 51, scope: !963)
!970 = !DILocalVariable(name: "pos_num", arg: 3, scope: !963, file: !1, line: 6, type: !103)
!971 = !DILocation(line: 6, column: 38, scope: !963)
!972 = !DILocalVariable(name: "neg_num", arg: 4, scope: !963, file: !1, line: 6, type: !103)
!973 = !DILocation(line: 6, column: 53, scope: !963)
!974 = !DILocalVariable(name: "pos_zero", arg: 5, scope: !963, file: !1, line: 7, type: !103)
!975 = !DILocation(line: 7, column: 38, scope: !963)
!976 = !DILocalVariable(name: "neg_zero", arg: 6, scope: !963, file: !1, line: 7, type: !103)
!977 = !DILocation(line: 7, column: 54, scope: !963)
!978 = !DILocalVariable(name: "idx", scope: !963, file: !1, line: 8, type: !98)
!979 = !DILocation(line: 8, column: 9, scope: !963)
!980 = !DILocation(line: 53, column: 27, scope: !981, inlinedAt: !982)
!981 = distinct !DISubprogram(name: "__fetch_builtin_x", linkageName: "_ZN26__cuda_builtin_threadIdx_t17__fetch_builtin_xEv", scope: !60, file: !61, line: 53, type: !64, scopeLine: 53, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, declaration: !63)
!982 = distinct !DILocation(line: 8, column: 15, scope: !963)
!983 = !DILocation(line: 11, column: 9, scope: !984)
!984 = distinct !DILexicalBlock(scope: !963, file: !1, line: 11, column: 9)
!985 = !DILocation(line: 11, column: 13, scope: !984)
!986 = !DILocation(line: 12, column: 21, scope: !987)
!987 = distinct !DILexicalBlock(scope: !984, file: !1, line: 11, column: 19)
!988 = !DILocation(line: 12, column: 31, scope: !987)
!989 = !DILocation(line: 12, column: 29, scope: !987)
!990 = !DILocation(line: 12, column: 9, scope: !987)
!991 = !DILocation(line: 12, column: 19, scope: !987)
!992 = !DILocation(line: 13, column: 33, scope: !987)
!993 = !DILocalVariable(name: "__x", arg: 1, scope: !270, file: !271, line: 170, type: !103)
!994 = !DILocation(line: 170, column: 31, scope: !270, inlinedAt: !995)
!995 = distinct !DILocation(line: 13, column: 25, scope: !987)
!996 = !DILocation(line: 170, column: 58, scope: !270, inlinedAt: !995)
!997 = !DILocalVariable(name: "__a", arg: 1, scope: !998, file: !999, line: 519, type: !103)
!998 = distinct !DISubprogram(name: "__signbitf", linkageName: "_ZL10__signbitff", scope: !999, file: !999, line: 519, type: !156, scopeLine: 519, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !272)
!999 = !DIFile(filename: "/storage/users/sislam3/opt/llvm-22/lib/clang/22/include/__clang_cuda_device_functions.h", directory: "")
!1000 = !DILocation(line: 519, column: 33, scope: !998, inlinedAt: !1001)
!1001 = distinct !DILocation(line: 170, column: 45, scope: !270, inlinedAt: !995)
!1002 = !DILocation(line: 519, column: 61, scope: !998, inlinedAt: !1001)
!1003 = !DILocation(line: 519, column: 47, scope: !998, inlinedAt: !1001)
!1004 = !DILocation(line: 170, column: 45, scope: !270, inlinedAt: !995)
!1005 = !DILocation(line: 13, column: 25, scope: !987)
!1006 = !DILocation(line: 13, column: 9, scope: !987)
!1007 = !DILocation(line: 13, column: 23, scope: !987)
!1008 = !DILocation(line: 14, column: 5, scope: !987)
!1009 = !DILocation(line: 17, column: 9, scope: !1010)
!1010 = distinct !DILexicalBlock(scope: !963, file: !1, line: 17, column: 9)
!1011 = !DILocation(line: 17, column: 13, scope: !1010)
!1012 = !DILocation(line: 18, column: 21, scope: !1013)
!1013 = distinct !DILexicalBlock(scope: !1010, file: !1, line: 17, column: 19)
!1014 = !DILocation(line: 18, column: 31, scope: !1013)
!1015 = !DILocation(line: 18, column: 29, scope: !1013)
!1016 = !DILocation(line: 18, column: 9, scope: !1013)
!1017 = !DILocation(line: 18, column: 19, scope: !1013)
!1018 = !DILocation(line: 19, column: 33, scope: !1013)
!1019 = !DILocation(line: 170, column: 31, scope: !270, inlinedAt: !1020)
!1020 = distinct !DILocation(line: 19, column: 25, scope: !1013)
!1021 = !DILocation(line: 170, column: 58, scope: !270, inlinedAt: !1020)
!1022 = !DILocation(line: 519, column: 33, scope: !998, inlinedAt: !1023)
!1023 = distinct !DILocation(line: 170, column: 45, scope: !270, inlinedAt: !1020)
!1024 = !DILocation(line: 519, column: 61, scope: !998, inlinedAt: !1023)
!1025 = !DILocation(line: 519, column: 47, scope: !998, inlinedAt: !1023)
!1026 = !DILocation(line: 170, column: 45, scope: !270, inlinedAt: !1020)
!1027 = !DILocation(line: 19, column: 25, scope: !1013)
!1028 = !DILocation(line: 19, column: 9, scope: !1013)
!1029 = !DILocation(line: 19, column: 23, scope: !1013)
!1030 = !DILocation(line: 20, column: 5, scope: !1013)
!1031 = !DILocation(line: 23, column: 9, scope: !1032)
!1032 = distinct !DILexicalBlock(scope: !963, file: !1, line: 23, column: 9)
!1033 = !DILocation(line: 23, column: 13, scope: !1032)
!1034 = !DILocation(line: 24, column: 21, scope: !1035)
!1035 = distinct !DILexicalBlock(scope: !1032, file: !1, line: 23, column: 19)
!1036 = !DILocation(line: 24, column: 31, scope: !1035)
!1037 = !DILocation(line: 24, column: 29, scope: !1035)
!1038 = !DILocation(line: 24, column: 9, scope: !1035)
!1039 = !DILocation(line: 24, column: 19, scope: !1035)
!1040 = !DILocation(line: 25, column: 33, scope: !1035)
!1041 = !DILocation(line: 170, column: 31, scope: !270, inlinedAt: !1042)
!1042 = distinct !DILocation(line: 25, column: 25, scope: !1035)
!1043 = !DILocation(line: 170, column: 58, scope: !270, inlinedAt: !1042)
!1044 = !DILocation(line: 519, column: 33, scope: !998, inlinedAt: !1045)
!1045 = distinct !DILocation(line: 170, column: 45, scope: !270, inlinedAt: !1042)
!1046 = !DILocation(line: 519, column: 61, scope: !998, inlinedAt: !1045)
!1047 = !DILocation(line: 519, column: 47, scope: !998, inlinedAt: !1045)
!1048 = !DILocation(line: 170, column: 45, scope: !270, inlinedAt: !1042)
!1049 = !DILocation(line: 25, column: 25, scope: !1035)
!1050 = !DILocation(line: 25, column: 9, scope: !1035)
!1051 = !DILocation(line: 25, column: 23, scope: !1035)
!1052 = !DILocation(line: 26, column: 5, scope: !1035)
!1053 = !DILocation(line: 29, column: 9, scope: !1054)
!1054 = distinct !DILexicalBlock(scope: !963, file: !1, line: 29, column: 9)
!1055 = !DILocation(line: 29, column: 13, scope: !1054)
!1056 = !DILocation(line: 30, column: 21, scope: !1057)
!1057 = distinct !DILexicalBlock(scope: !1054, file: !1, line: 29, column: 19)
!1058 = !DILocation(line: 30, column: 31, scope: !1057)
!1059 = !DILocation(line: 30, column: 29, scope: !1057)
!1060 = !DILocation(line: 30, column: 9, scope: !1057)
!1061 = !DILocation(line: 30, column: 19, scope: !1057)
!1062 = !DILocation(line: 31, column: 33, scope: !1057)
!1063 = !DILocation(line: 170, column: 31, scope: !270, inlinedAt: !1064)
!1064 = distinct !DILocation(line: 31, column: 25, scope: !1057)
!1065 = !DILocation(line: 170, column: 58, scope: !270, inlinedAt: !1064)
!1066 = !DILocation(line: 519, column: 33, scope: !998, inlinedAt: !1067)
!1067 = distinct !DILocation(line: 170, column: 45, scope: !270, inlinedAt: !1064)
!1068 = !DILocation(line: 519, column: 61, scope: !998, inlinedAt: !1067)
!1069 = !DILocation(line: 519, column: 47, scope: !998, inlinedAt: !1067)
!1070 = !DILocation(line: 170, column: 45, scope: !270, inlinedAt: !1064)
!1071 = !DILocation(line: 31, column: 25, scope: !1057)
!1072 = !DILocation(line: 31, column: 9, scope: !1057)
!1073 = !DILocation(line: 31, column: 23, scope: !1057)
!1074 = !DILocation(line: 32, column: 5, scope: !1057)
!1075 = !DILocation(line: 35, column: 9, scope: !1076)
!1076 = distinct !DILexicalBlock(scope: !963, file: !1, line: 35, column: 9)
!1077 = !DILocation(line: 35, column: 13, scope: !1076)
!1078 = !DILocation(line: 36, column: 28, scope: !1079)
!1079 = distinct !DILexicalBlock(scope: !1076, file: !1, line: 35, column: 19)
!1080 = !DILocation(line: 36, column: 26, scope: !1079)
!1081 = !DILocation(line: 36, column: 9, scope: !1079)
!1082 = !DILocation(line: 36, column: 19, scope: !1079)
!1083 = !DILocation(line: 37, column: 33, scope: !1079)
!1084 = !DILocation(line: 170, column: 31, scope: !270, inlinedAt: !1085)
!1085 = distinct !DILocation(line: 37, column: 25, scope: !1079)
!1086 = !DILocation(line: 170, column: 58, scope: !270, inlinedAt: !1085)
!1087 = !DILocation(line: 519, column: 33, scope: !998, inlinedAt: !1088)
!1088 = distinct !DILocation(line: 170, column: 45, scope: !270, inlinedAt: !1085)
!1089 = !DILocation(line: 519, column: 61, scope: !998, inlinedAt: !1088)
!1090 = !DILocation(line: 519, column: 47, scope: !998, inlinedAt: !1088)
!1091 = !DILocation(line: 170, column: 45, scope: !270, inlinedAt: !1085)
!1092 = !DILocation(line: 37, column: 25, scope: !1079)
!1093 = !DILocation(line: 37, column: 9, scope: !1079)
!1094 = !DILocation(line: 37, column: 23, scope: !1079)
!1095 = !DILocation(line: 38, column: 5, scope: !1079)
!1096 = !DILocation(line: 41, column: 9, scope: !1097)
!1097 = distinct !DILexicalBlock(scope: !963, file: !1, line: 41, column: 9)
!1098 = !DILocation(line: 41, column: 13, scope: !1097)
!1099 = !DILocation(line: 42, column: 28, scope: !1100)
!1100 = distinct !DILexicalBlock(scope: !1097, file: !1, line: 41, column: 19)
!1101 = !DILocation(line: 42, column: 26, scope: !1100)
!1102 = !DILocation(line: 42, column: 9, scope: !1100)
!1103 = !DILocation(line: 42, column: 19, scope: !1100)
!1104 = !DILocation(line: 43, column: 33, scope: !1100)
!1105 = !DILocation(line: 170, column: 31, scope: !270, inlinedAt: !1106)
!1106 = distinct !DILocation(line: 43, column: 25, scope: !1100)
!1107 = !DILocation(line: 170, column: 58, scope: !270, inlinedAt: !1106)
!1108 = !DILocation(line: 519, column: 33, scope: !998, inlinedAt: !1109)
!1109 = distinct !DILocation(line: 170, column: 45, scope: !270, inlinedAt: !1106)
!1110 = !DILocation(line: 519, column: 61, scope: !998, inlinedAt: !1109)
!1111 = !DILocation(line: 519, column: 47, scope: !998, inlinedAt: !1109)
!1112 = !DILocation(line: 170, column: 45, scope: !270, inlinedAt: !1106)
!1113 = !DILocation(line: 43, column: 25, scope: !1100)
!1114 = !DILocation(line: 43, column: 9, scope: !1100)
!1115 = !DILocation(line: 43, column: 23, scope: !1100)
!1116 = !DILocation(line: 44, column: 5, scope: !1100)
!1117 = !DILocation(line: 47, column: 9, scope: !1118)
!1118 = distinct !DILexicalBlock(scope: !963, file: !1, line: 47, column: 9)
!1119 = !DILocation(line: 47, column: 13, scope: !1118)
!1120 = !DILocation(line: 48, column: 31, scope: !1121)
!1121 = distinct !DILexicalBlock(scope: !1118, file: !1, line: 47, column: 19)
!1122 = !DILocation(line: 48, column: 29, scope: !1121)
!1123 = !DILocation(line: 48, column: 9, scope: !1121)
!1124 = !DILocation(line: 48, column: 19, scope: !1121)
!1125 = !DILocation(line: 49, column: 33, scope: !1121)
!1126 = !DILocation(line: 170, column: 31, scope: !270, inlinedAt: !1127)
!1127 = distinct !DILocation(line: 49, column: 25, scope: !1121)
!1128 = !DILocation(line: 170, column: 58, scope: !270, inlinedAt: !1127)
!1129 = !DILocation(line: 519, column: 33, scope: !998, inlinedAt: !1130)
!1130 = distinct !DILocation(line: 170, column: 45, scope: !270, inlinedAt: !1127)
!1131 = !DILocation(line: 519, column: 61, scope: !998, inlinedAt: !1130)
!1132 = !DILocation(line: 519, column: 47, scope: !998, inlinedAt: !1130)
!1133 = !DILocation(line: 170, column: 45, scope: !270, inlinedAt: !1127)
!1134 = !DILocation(line: 49, column: 25, scope: !1121)
!1135 = !DILocation(line: 49, column: 9, scope: !1121)
!1136 = !DILocation(line: 49, column: 23, scope: !1121)
!1137 = !DILocation(line: 50, column: 5, scope: !1121)
!1138 = !DILocation(line: 53, column: 9, scope: !1139)
!1139 = distinct !DILexicalBlock(scope: !963, file: !1, line: 53, column: 9)
!1140 = !DILocation(line: 53, column: 13, scope: !1139)
!1141 = !DILocation(line: 54, column: 32, scope: !1142)
!1142 = distinct !DILexicalBlock(scope: !1139, file: !1, line: 53, column: 19)
!1143 = !DILocation(line: 54, column: 30, scope: !1142)
!1144 = !DILocation(line: 54, column: 9, scope: !1142)
!1145 = !DILocation(line: 54, column: 19, scope: !1142)
!1146 = !DILocation(line: 55, column: 33, scope: !1142)
!1147 = !DILocation(line: 170, column: 31, scope: !270, inlinedAt: !1148)
!1148 = distinct !DILocation(line: 55, column: 25, scope: !1142)
!1149 = !DILocation(line: 170, column: 58, scope: !270, inlinedAt: !1148)
!1150 = !DILocation(line: 519, column: 33, scope: !998, inlinedAt: !1151)
!1151 = distinct !DILocation(line: 170, column: 45, scope: !270, inlinedAt: !1148)
!1152 = !DILocation(line: 519, column: 61, scope: !998, inlinedAt: !1151)
!1153 = !DILocation(line: 519, column: 47, scope: !998, inlinedAt: !1151)
!1154 = !DILocation(line: 170, column: 45, scope: !270, inlinedAt: !1148)
!1155 = !DILocation(line: 55, column: 25, scope: !1142)
!1156 = !DILocation(line: 55, column: 9, scope: !1142)
!1157 = !DILocation(line: 55, column: 23, scope: !1142)
!1158 = !DILocation(line: 56, column: 5, scope: !1142)
!1159 = !DILocation(line: 59, column: 9, scope: !1160)
!1160 = distinct !DILexicalBlock(scope: !963, file: !1, line: 59, column: 9)
!1161 = !DILocation(line: 59, column: 13, scope: !1160)
!1162 = !DILocation(line: 60, column: 21, scope: !1163)
!1163 = distinct !DILexicalBlock(scope: !1160, file: !1, line: 59, column: 19)
!1164 = !DILocation(line: 60, column: 32, scope: !1163)
!1165 = !DILocation(line: 60, column: 30, scope: !1163)
!1166 = !DILocation(line: 60, column: 9, scope: !1163)
!1167 = !DILocation(line: 60, column: 19, scope: !1163)
!1168 = !DILocation(line: 61, column: 9, scope: !1163)
!1169 = !DILocation(line: 61, column: 23, scope: !1163)
!1170 = !DILocation(line: 62, column: 5, scope: !1163)
!1171 = !DILocation(line: 63, column: 1, scope: !963)
