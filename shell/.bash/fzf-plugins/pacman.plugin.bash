pfzin()
{
    pacman -Slq | fzf -m --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S
}