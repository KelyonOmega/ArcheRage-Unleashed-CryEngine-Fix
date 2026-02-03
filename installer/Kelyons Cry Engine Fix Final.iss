[Setup]
AppName=Kelyons CryEngine Fix
AppVersion=1.0
DefaultDirName={autopf}\KelyonsCryEngineFix
DisableDirPage=yes
DisableProgramGroupPage=yes
DisableReadyPage=yes
OutputBaseFilename=CryEngineFixInstaller
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Files]
Source: "Checking.CPU.RAM.GPU.exe"; DestDir: "{app}"; Flags: ignoreversion

[Code]
var
  RAM_MB: Integer;
  CPUThreads: Integer;
  VRAM_MB: Integer;
  UseLODs: Integer;
  ConfigPath: string;
  SystemCfgPage: TInputFileWizardPage;

const
  FIX_BEGIN = '; ==== KELYONS CRYENGINE FIX ====';
  FIX_END   = '; ==== KELYONS CRYENGINE FIX END ====';

procedure RunScannerAndReadResults;
var
  ResultCode: Integer;
  Lines: TStringList;
  ScannerPath: string;
  ScanFile: string;
  i: Integer;
  Key, Val: string;
  p: Integer;
begin
  ScannerPath := ExpandConstant('{app}\Checking.CPU.RAM.GPU.exe');
  ScanFile := ExpandConstant('{app}\scan_result.txt');

  if not FileExists(ScannerPath) then
  begin
    MsgBox('Scanner executable not found:'#13#10 + ScannerPath, mbError, MB_OK);
    Abort;
  end;

  if not Exec(ScannerPath, '', ExpandConstant('{app}'), SW_HIDE, ewWaitUntilTerminated, ResultCode) then
  begin
    MsgBox('Failed to execute scanner!', mbError, MB_OK);
    Abort;
  end;

  Sleep(500);

  if not FileExists(ScanFile) then
  begin
    MsgBox('Scanner output not found:'#13#10 + ScanFile + #13#10#13#10 + 'ResultCode: ' + IntToStr(ResultCode), mbError, MB_OK);
    Abort;
  end;

  Lines := TStringList.Create;
  try
    Lines.LoadFromFile(ScanFile);
    
    for i := 0 to Lines.Count - 1 do
    begin
      p := Pos('=', Lines[i]);
      if p = 0 then Continue;

      Key := Trim(UpperCase(Copy(Lines[i], 1, p - 1)));
      Val := Trim(Copy(Lines[i], p + 1, Length(Lines[i])));

      if Key = 'RAM_MB' then 
        RAM_MB := StrToIntDef(Val, 8192);
      if Key = 'CPU_THREADS' then 
        CPUThreads := StrToIntDef(Val, 4);
      if Key = 'VRAM_MB' then 
        VRAM_MB := StrToIntDef(Val, 4096);
      if Key = 'IS_SSD' then
      begin
        if StrToIntDef(Val, 0) = 1 then 
          UseLODs := 1
        else 
          UseLODs := 0;
      end;
    end;
  finally
    Lines.Free;
  end;

  if (RAM_MB = 0) or (CPUThreads = 0) or (VRAM_MB = 0) then
  begin
    MsgBox('Error reading system values!'#13#10#13#10 + 
           'RAM: ' + IntToStr(RAM_MB) + ' MB'#13#10 +
           'CPU Threads: ' + IntToStr(CPUThreads) + #13#10 +
           'VRAM: ' + IntToStr(VRAM_MB) + ' MB', mbError, MB_OK);
    Abort;
  end;
end;

procedure ApplyFix;
var
  Src, Dst, Fix: TStringList;
  i: Integer;
  InFix: Boolean;
  Line: string;
begin
  Src := TStringList.Create;
  Dst := TStringList.Create;
  Fix := TStringList.Create;
  try
    Src.LoadFromFile(ConfigPath);

    InFix := False;
    for i := 0 to Src.Count - 1 do
    begin
      Line := Src[i];
      
      if Pos(FIX_BEGIN, Line) > 0 then
      begin
        InFix := True;
        Continue;
      end;
      
      if Pos(FIX_END, Line) > 0 then
      begin
        InFix := False;
        Continue;
      end;
      
      if not InFix then
        Dst.Add(Line);
    end;

    Fix.Add('');
    Fix.Add(FIX_BEGIN);
    Fix.Add('sys_job_system_enable = 1');
    Fix.Add('sys_budget_videomem = ' + IntToStr(VRAM_MB));
    Fix.Add('sys_budget_sysmem = ' + IntToStr(RAM_MB));
    Fix.Add('sys_streaming_memory_size = ' + IntToStr(RAM_MB));
    Fix.Add('sys_job_system_max_worker = ' + IntToStr(CPUThreads));
    Fix.Add('sys_streaming_use_lods = ' + IntToStr(UseLODs));
    Fix.Add('sys_budget_frametime = 16');
    Fix.Add('r_UsePBuffers = 0');
    Fix.Add('r_TexturesStreamPoolSize = 1536');
    Fix.Add('r_UseParticlesHalfRes = 1');
    Fix.Add('r_PostProcessEffects = 1');
    Fix.Add('e_ParticlesMaxScreenFill = 32');
    Fix.Add('r_TexturesStreaming = 1');
    Fix.Add('sys_streaming_max_concurrent_requests = 40');
    Fix.Add('ui_RenderThreadUpdate = 1');
    Fix.Add('e_ObjFastRegister = 1');
    Fix.Add('e_StatObjMerge = 1');
    Fix.Add('e_MergedMeshes = 1');
    Fix.Add('e_MergedMeshesInstanceDist = 512');
    Fix.Add('r_GeomInstancing = 1');
    Fix.Add('r_UseHardwareOcclusionQueries = 1');
    Fix.Add('e_PreloadMaterials = 1');
    Fix.Add('r_UseShaderThread = 1');
    Fix.Add('r_UseThreadedShaders = 1');
    Fix.Add('r_ShaderCompilationAsync = 1');
    Fix.Add('r_ShadersPrecache = 1');
    Fix.Add('gpu_ParticlePhysics = 0');
    Fix.Add('r_TexturesStreamingPrioritizeVisibleMips = 1');
    Fix.Add(FIX_END);
    Fix.Add('');

    Dst.AddStrings(Fix);
    
    Dst.SaveToFile(ConfigPath);
    
    MsgBox('CryEngine Fix successfully installed!'#13#10#13#10 +
           'Applied values:'#13#10 +
           'RAM: ' + IntToStr(RAM_MB) + ' MB'#13#10 +
           'VRAM: ' + IntToStr(VRAM_MB) + ' MB'#13#10 +
           'CPU Threads: ' + IntToStr(CPUThreads) + #13#10 +
           'LODs: ' + IntToStr(UseLODs) + ' (0=SSD, 1=HDD)', mbInformation, MB_OK);
  finally
    Src.Free;
    Dst.Free;
    Fix.Free;
  end;
end;

procedure InitializeWizard;
begin
  SystemCfgPage := CreateInputFilePage(
    wpSelectDir,
    'Select system.cfg',
    'Path to ArcheAge system.cfg',
    'Please select your ArcheAge system.cfg file.'
  );

  SystemCfgPage.Add(
    'system.cfg file:',
    'CFG files (*.cfg)|*.cfg|All files (*.*)|*.*',
    '.cfg'
  );

  if FileExists(ExpandConstant('{userdocs}\ArcheAge\system.cfg')) then
    SystemCfgPage.Values[0] := ExpandConstant('{userdocs}\ArcheAge\system.cfg');
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    ConfigPath := SystemCfgPage.Values[0];

    if (ConfigPath = '') or (not FileExists(ConfigPath)) then
    begin
      MsgBox('The system.cfg file was not found or not selected!', mbError, MB_OK);
      Abort;
    end;

    if not CopyFile(ConfigPath, ConfigPath + '.bak', False) then
    begin
      if MsgBox('Backup could not be created. Continue anyway?', mbConfirmation, MB_YESNO) = IDNO then
        Abort;
    end;

    RunScannerAndReadResults;
    
    ApplyFix;
  end;
end;