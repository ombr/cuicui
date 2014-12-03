Browser.modern_rules.clear
Browser.modern_rules << -> b { b.webkit? }
Browser.modern_rules << -> b { b.firefox? && b.version.to_i >= 17 }
Browser.modern_rules << -> b { b.ie? && b.version.to_i >= 11 }
Browser.modern_rules << -> b { b.opera? && b.version.to_i >= 12 }
Browser.modern_rules << lambda do |b|
  b.firefox? && b.tablet? && b.android? && b.version.to_i >= 14
end
