pfzin()
{
    pacman -Slq | fzf -m --preview 'pacman -Sii {1}' | xargs -ro sudo pacman -S
}