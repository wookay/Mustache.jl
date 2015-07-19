using Mustache
using Base.Test

tpl = mt"a:{{x}} b:{{{y}}}"

x, y = "ex", "why"
d = @compat Dict("x"=>"ex", "y"=>"why")
type ThrowAway
    x
    y
end

@test render(tpl, Main) == "a:ex b:why"
@test render(tpl, d) == "a:ex b:why"
@test render(tpl, ThrowAway(x,y)) == "a:ex b:why"


## triple quoted
tpl = mt"""a:{{x}} b:{{y}}"""


@test render(tpl, Main) == "a:ex b:why"
@test render(tpl, d) == "a:ex b:why"
@test render(tpl, ThrowAway(x,y)) == "a:ex b:why"

## conditional
tpl = "{{#b}}this doesn't show{{/b}}{{#a}}this does show{{/a}}"
@test render(tpl, @compat Dict("a" => 1)) == "this does show"

## dict using symbols
d = @compat Dict(:a => x, :b => y)
tpl = "a:{{:a}} b:{{:b}}"
@test render(tpl, d) == "a:ex b:why"

## keyword args
@test render(tpl, a="ex", b="why") == "a:ex b:why"

## unicode 
module TMP
α = 1
β = 2
end
@test render("{{α}} + 1 = {{β}}", TMP) == "1 + 1 = 2"
@test render("{{:β}}", β=2) == "2"
@test render("α - {{:β}}", β=2) == "α - 2"
@test render("{{:α}}", α="β") == "β"

## {{.}} test
tpl = mt"{{#:vec}}{{.}} {{/:vec}}"
@test render(tpl, vec=[1,2,3]) == "1 2 3 "
